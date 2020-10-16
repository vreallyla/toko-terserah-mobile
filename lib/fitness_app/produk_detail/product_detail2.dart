import 'dart:convert';
import 'dart:io';

import 'package:best_flutter_ui_templates/Controllers/harga_controller.dart';
import 'package:best_flutter_ui_templates/fitness_app/produk_detail/detail_card_view.dart';

import 'package:best_flutter_ui_templates/fitness_app/produk_detail/qna_product_view.dart';
import 'package:best_flutter_ui_templates/fitness_app/produk_detail/review_product_view.dart';
import 'package:best_flutter_ui_templates/fitness_app/produk_detail/titlenprice_product_view.dart';
import 'package:best_flutter_ui_templates/model/product_model.dart';
import 'package:flutter/material.dart';

import 'CustomShowDialog.dart';
import 'carousel_product_view.dart';
import 'cart_card_view.dart';

class ProductDetail2 extends StatefulWidget {
  
  @override
  _ProductDetail2State createState() => _ProductDetail2State();
}

class HeaderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // double topBarOpacity = 0.0;
    TextEditingController editingController = TextEditingController();

    return AppBar(
      backgroundColor: Colors.grey[200],
      brightness: Brightness.light,
      leading: Transform.translate(
        offset: Offset(-5, 0),
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      titleSpacing: -30,
      centerTitle: false,
      title: Container(
        padding: EdgeInsets.only(left: 20, right: 40),
        child: TextField(
          onChanged: (value) {},
          controller: editingController,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              // labelText: "Cari Produk",
              labelStyle: TextStyle(color: Colors.grey),
              hintText: "Cari Produk",
              hintStyle: TextStyle(color: Colors.grey),
              contentPadding: const EdgeInsets.all(1.0),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 5.0),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)))),
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 15),
          child: Stack(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Icon(
                    Icons.shopping_cart,
                    size: 24,
                    color: Colors.black54,
                  )),
              Container(
                margin: EdgeInsets.only(top: 8, left: 10),
                alignment: Alignment.center,
                height: 20,
                width: 20,
                child: Text(
                  '0',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w500),
                ),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              )
            ],
          ),
        )
      ],
    );
  }
}

class _ProductDetail2State extends State<ProductDetail2>
    with TickerProviderStateMixin {
  // data widget
  List<Widget> listViews = <Widget>[];

  //gambar carousel
  List<dynamic> imageLists = [];

  // data detail produk
  Map<String, dynamic> detailProduct;

  // data untuk ulasan
  Map<String, dynamic> reviewData;

  //data untuk pertanyaan
  List<dynamic> qnAData;

  //check inet
  bool isConnect = true;

  // status login checker
  bool isLogin = false;

  // load ajax process
  bool isLoading = false;

  // jumlah qty pcs
  int jmlh_pcs=0;

  void showAddDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                color: const Color(0xFFFFFF),
                borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
              ),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CardCardView(dataProduct:detailProduct,getPcs:(int value){
                    setState(() {
                    jmlh_pcs=value;
                      
                    });
                  }),
                  MaterialButton(
                    onPressed: () {
                      print(jmlh_pcs);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 18,
                      padding: EdgeInsets.all(1.0),
                      child: Material(
                          color: kondToCart(detailProduct) || jmlh_pcs==0?Colors.grey: Colors.green,
                          borderRadius: BorderRadius.circular(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'TAMBAH KE KERANJANG',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontFamily: 'helvetica_neue_light',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

  _getDataApi() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await ProductModel.getProduct('36').then((value) {
          if (value.error) {
            isLogin = false;
          } else {
            Map<String, dynamic> dataLoad = json.decode(value.data);

            // set data
            detailProduct = dataLoad['detail'];
            imageLists = detailProduct['galeri'] ?? [detailProduct['gambar']];
            reviewData = dataLoad['review'];
            qnAData = dataLoad['qna'];
            print(reviewData['data']);
            addAllListData();
            setState(() {});
            // print(detailProduct['count_ulasan']);

          }
          // _setData();
          // print(value.data);
        });
      }
    } on SocketException catch (_) {
      // print('dasd');
      isConnect = false;
      isLoading = false;
      addAllListData();
      setState(() {});
    }
  }

  Widget noConnection() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 70),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 160,
            width: 160,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fitness_app/not_found.gif'),
                fit: BoxFit.fitHeight,
              ),
            ),
            padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
          ),
          Text(
            'Koneksi Terputus',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Text('Periksa sambungan internet kamu',
              style: TextStyle(color: Colors.black54)),
          Container(
            margin: EdgeInsets.only(top: 15),
            child: RaisedButton(
              onPressed: () {
                setState(() {
                  // isLoading = true;
                  isConnect = true;
                  _getDataApi();
                });
              },
              color: Colors.green,
              child: Text('COBA LAGI', style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  @override
  // ignore: must_call_super
  void initState() {
    _getDataApi();
    Future.delayed(Duration(seconds: 1), () {
      addAllListData();
    });
  }

  void addAllListData() {
    listViews = [];

    listViews.add(CarouselProductView(imageList: imageLists));

    listViews.add(TitleNPriceProductView(detailList: detailProduct));
    Map<String, dynamic> mapDetailCard = detailProduct;

    listViews.add(DetailCardView(
      detailList: mapDetailCard,
      title: 'Deskripsi',
      moreText: false,
    ));

    listViews.add(DetailCardView(
        detailList: mapDetailCard, title: "Detail Produk", moreText: false));

    if (reviewData['data'] != null) {
      listViews.add(ReviewProductView(
        dataReview: reviewData,
        listReview: detailProduct['get_ulasan'],
      ));
    }

    listViews.add(QnAProductView(dataQnA: qnAData));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0), child: HeaderPage()),
      bottomNavigationBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: BottomAppBar(
          child: new Row(
            children: <Widget>[
              Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: ButtonTheme(
                  minWidth: 150,
                  height: 40,
                  child: RaisedButton(
                    child: Text(
                      'MASUKKAN KERANJANG',
                      style: TextStyle(color: Colors.green),
                    ),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.green)),
                    onPressed: () {
                      if(detailProduct.containsKey('nama')){
                      jmlh_pcs=setMinOrder(detailProduct).round();
                      }
                      showAddDialog(context);
                    },
                  ),
                ),
              ),
              Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: ButtonTheme(
                  minWidth: 150,
                  height: 40,
                  child: RaisedButton(
                    child: Text(
                      'BELI SEKARANG',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.green,
                    onPressed: () {
                      // Navigate to the second screen using a named route.
                      Navigator.pushNamed(context, '/cart_list');
                    },
                  ),
                ),
              ),
              Spacer(flex: 1),
            ],
          ),
        ),
      ),
      body: Container(
        child: ListView(
          children: listViews,
        ),
      ),
    );
  }
}

BoxDecoration borderTop() {
  return BoxDecoration(
    border: Border(
      top: BorderSide(width: 0.5, color: Colors.black26),
    ),
    color: Colors.white,
  );
}
