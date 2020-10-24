import 'dart:convert';
import 'dart:io';

import 'package:best_flutter_ui_templates/Controllers/harga_controller.dart';
import 'package:best_flutter_ui_templates/fitness_app/produk_detail/detail_card_view.dart';

import 'package:best_flutter_ui_templates/fitness_app/produk_detail/qna_product_view.dart';
import 'package:best_flutter_ui_templates/fitness_app/produk_detail/review_product_view.dart';
import 'package:best_flutter_ui_templates/fitness_app/produk_detail/titlenprice_product_view.dart';
import 'package:best_flutter_ui_templates/model/keranjang_model.dart';
import 'package:best_flutter_ui_templates/model/product_model.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import 'CustomShowDialog.dart';
import 'carousel_product_view.dart';
import 'cart_card_view.dart';
import 'package:best_flutter_ui_templates/Constant/Constant.dart';

class ProductDetail2 extends StatefulWidget {
  const ProductDetail2({Key key, this.productId = ''}) : super(key: key);

  final String productId;

  @override
  _ProductDetail2State createState() => _ProductDetail2State();
}

void beliSekarang(int jmlBeli) {}

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
  int jmlh_pcs = 0;

  //id product
  String idProduct;

  //jml cart
  int jmlCart = 0;

  bool loadOverlay = false;

  //
  String qna = 'Hello', _token;

  //Key untuk menumculkan snackbar
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //simpan data user
  var dataUser;

  //overlay loading event
  void loadOverlayEvent(bool cond) {
    setState(() {
      loadOverlay = cond;
    });
  }

// tambah ke kerenjang event
  _addCart(String id, String qty, bool redirect) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await KeranjangModel.addCart(id, qty).then((value) {
          Map<String, dynamic> res = json.decode(value.data);

          if (value.error && !res.containsKey('error')) {
            loadNotice(context, 'Terjadi Kesalahan!', true, 'OK', () {
              Navigator.of(context).pop();
            });
          }
          // login exc
          else if (res.containsKey('error')) {
            loadNotice(context, 'Anda Belum Login!', false, 'LOGIN', () {
              Navigator.pushNamed(context, '/login');
            });
          }
          //success
          else {
            print(res);
            if (!redirect) {
              loadNotice(
                  context, 'Berhasil ditambah ke keranjang!', false, 'OK', () {
                Navigator.of(context).pop();
              });
            }

            _getDataApi();
            Future.delayed(Duration(seconds: 1), () {
              if (redirect) {
                loadOverlayEvent(false);

                Navigator.pushNamed(context, '/cart_list');
              }
            });
          }
          setState(() {});
        });
      }
    } on SocketException catch (_) {
      loadOverlayEvent(false);

      loadNotice(context, 'Terjadi Kesalahan!', true, 'OK', () {
        Navigator.of(context).pop();
      });
      setState(() {});
    }
  }

  Future _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(_token);
    setState(() {
      _token = prefs.getString('token');
      if (_token != null) {
        dataUser = jsonDecode(prefs.getString('dataUser'));
      }
    });
  }

  void showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: 250,
            decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              color: const Color(0xFFFFFF),
              borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CardCardView(
                    dataProduct: detailProduct,
                    getPcs: (int value) {
                      setState(() {
                        jmlh_pcs = value;
                      });
                    }),
                MaterialButton(
                  onPressed: () {
                    if (!(kondToCart(detailProduct) || jmlh_pcs == 0)) {
                      Navigator.of(context).pop();
                      loadOverlayEvent(true);
                      _addCart(detailProduct['id'].toString(),
                          jmlh_pcs.toString(), false);
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 15,
                    padding: EdgeInsets.all(1.0),
                    child: Material(
                        color: kondToCart(detailProduct) || jmlh_pcs == 0
                            ? Colors.grey
                            : Colors.green,
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
        await ProductModel.getProduct(idProduct).then((value) {
          loadOverlayEvent(false);

          if (value.error) {
            isLogin = false;
          } else {
            Map<String, dynamic> dataLoad = json.decode(value.data);

            // set data
            jmlCart = dataLoad['count_cart'];

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

  _submitQna(newAbc) async {
    try {
      if (_token != null) {
        if (newAbc == null || newAbc == '') {
          //if parameter null

          showSnackBar("Silahkan isi kolom pertanyaannya dulu Sob", Colors.red,
              FaIcon(FontAwesomeIcons.timesCircle));
        } else {
          var response =
              await http.post(globalBaseUrl + globalPathProduct + 'qna', body: {
            'user_id': dataUser['user']['id'].toString(),
            'produk_id': widget.productId,
            'tanya': newAbc
          }, headers: {
            "Authorization": "Bearer " + null
          });
          var _response = json.decode(response.body);
          showSnackBar(_response['data']['message'], Colors.green,
              Icon(Icons.announcement));
        }

        setState(() {});
        _getDataApi();
      } else {
        showSnackBar("Silahhkan Login Sob untuk bertanya", Colors.red,
            FaIcon(FontAwesomeIcons.timesCircle));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  // ignore: must_call_super
  void initState() {
    idProduct = widget.productId;
    _getToken();
    Future.delayed(Duration(seconds: 0), () {
      _getDataApi();
    });
    Future.delayed(Duration(seconds: 0), () {
      addAllListData();
    });
  }

  /**
   * Cutom Alert response
   * 
   */
  showSnackBar(String value, Color color, icons) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Row(
        children: <Widget>[
          icons,
          SizedBox(
            width: 20,
          ),
          Text(value)
        ],
      ),
      backgroundColor: color,
      duration: Duration(seconds: 3),
    ));
  }

/**
 * Add view to list 
 */
  void addAllListData() {
    listViews = [];

    listViews.add(CarouselProductView(imageList: imageLists));

    listViews.add(TitleNPriceProductView(
        detailList: detailProduct,
        funcLoad: (bool cond) {
          loadOverlayEvent(cond);
        }));
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

    listViews.add(QnAProductView(
      dataQnA: qnAData,
      callback: _submitQna,
      token: _token,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: Stack(
            children: [
              HeaderPage(countCard: jmlCart),
              loadOverlay
                  ? Container(
                      width: size.width,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.2),
                      ))
                  : Text(
                      '',
                      style: TextStyle(fontSize: 0),
                    )
            ],
          )),
      bottomNavigationBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: BottomAppBar(
          child: Stack(
            children: [
              new Row(
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
                          // Navigate to the second screen using a named route.
                          if (detailProduct.containsKey('nama')) {
                            jmlh_pcs = setMinOrder(detailProduct).round();
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
                      loadOverlayEvent(true);

                          _addCart(detailProduct['id'].toString(), 1.toString(),
                              true);
                        },
                      ),
                    ),
                  ),
                  Spacer(flex: 1),
                ],
              ),
              loadOverlay
                  ? Container(
                      width: size.width,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.2),
                      ))
                  : Text(
                      '',
                      style: TextStyle(fontSize: 0),
                    )
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            child: ListView(
              children: listViews,
            ),
          ),
          loadOverlay
              ? Container(
                  width: size.width,
                  height: size.height,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.2),
                  ),
                  child: Image.asset(
                    'assets/fitness_app/global_loader.gif',
                    scale: 5,
                  ),
                )
              : Text(
                  '',
                  style: TextStyle(fontSize: 0),
                )
        ],
      ),
    );
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
}

class HeaderPage extends StatelessWidget {
  HeaderPage({Key key, this.countCard}) : super(key: key);

  int countCard;

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
          onSubmitted: (v) {
            Navigator.of(context).pushNamed('/',
                arguments: {"search_product": true, 'keyword_product': v});
          },
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
          child: InkWell(
            onTap: () => Navigator.of(context).pushNamed('/cart_list'),
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
                    countCard > 99 ? '99+' : countCard.toString(),
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
          ),
        )
      ],
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
