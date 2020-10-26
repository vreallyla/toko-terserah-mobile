import 'dart:convert';
import 'dart:io';

import 'package:best_flutter_ui_templates/Constant/Constant.dart';
import 'package:best_flutter_ui_templates/design_course/test.dart';
import 'package:best_flutter_ui_templates/fitness_app/check_out/product_detail_view.dart';
import 'package:best_flutter_ui_templates/fitness_app/midtrans/midtrans_screen.dart';
import 'package:best_flutter_ui_templates/model/alamat_model.dart';
import 'package:best_flutter_ui_templates/model/keranjang_model.dart';
import 'package:best_flutter_ui_templates/model/midtrans_model.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CheckOut extends StatefulWidget {
  const CheckOut({Key key, this.idProducts}) : super(key: key);

  final List idProducts;
  @override
  _CheckOutState createState() => _CheckOutState();
}

class NewItem {
  bool isExpanded;
  String header;
  Widget body;
  Icon iconpic;
  NewItem(this.isExpanded, this.header, this.body, this.iconpic);
}

class _CheckOutState extends State<CheckOut> {
  PanelController _pc = new PanelController();

  bool isConnect = true;
  bool isLoading = false;
  bool loadOverlay = false;
  Map<String, dynamic> productDetail = {};

  //overlay loading event
  void loadOverlayEvent(bool cond) {
    setState(() {
      loadOverlay = cond;
    });
  }

  _getDataApi() async {
    List data = widget.idProducts;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await KeranjangModel.getCart(data).then((value) {
          isLoading = false;

          if (value.error) {
          } else {
            productDetail = json.decode(value.data);
            setState(() {});
            // print('hello');
          }
        });
      }
    } on SocketException catch (_) {
      // print('dasd');
      isConnect = false;
      isLoading = false;

      setState(() {});
    }
  }

  _getAlamatApi() async {
    List data = widget.idProducts;
    // print(data);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await AlamatModel.getAlamat().then((value) {
          isLoading = false;

          if (value.error) {
          } else {
            // productDetail = json.decode(value.data);
            // print(value.data);
            // print('qwx');
            setState(() {});
            // print('hello');
          }
        });
      }
    } on SocketException catch (_) {
      // print('dasd');
      isConnect = false;
      isLoading = false;

      setState(() {});
    }
  }

  _getSnapMidtransApi() async {
    loadOverlayEvent(true);

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await MidtransModel.getSnap({
          'pengiriman_id': '1',
          'penagihan_id': '1',
          'ongkir': '100000',
          'discount_price': '',
          'cart_ids': '56,58,59',
          'total': '50000',
        }).then((value) {
          loadOverlayEvent(false);

          if (value.error) {
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TestWebView(
                    pengirimanId: '1',
                    penagihanId: '1',
                    cartIds: '56,58,59',
                    discountPrice: '',
                    ongkir: '100000',
                    total: '50000',
                    snapToken: value.data,
                    weight: '3',
                    note: 'Coba aja dulu',
                    durasiPengiriman: '2-3',
                    promoCode: 'logistik',
                    opsi: 'logistik',
                    kodeKurir: 'jne',
                    layananKurir: 'CTC',
                    token:tokenFixed,
                  ),
                ));
            setState(() {});
            // print('hello');
          }
        });
      }
    } on SocketException catch (_) {
      loadOverlayEvent(false);

      isConnect = false;
      isLoading = false;

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
String tokenFixed='';

  _getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  tokenFixed = prefs.getString('token');
  //  prefs.getString('token');
}

  @override
  // ignore: must_call_super
  void initState() {
    isLoading = true;
    _getToken();

    _getDataApi();
    _getAlamatApi();
    // _getSnapMidtransApi();
    super.initState();
  }

  ExpansionPanelList listcheckout;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    //final wh_ = MediaQuery.of(context).size;

    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        brightness: Brightness.light,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.notifications),
          //   onPressed: () {},
          //   color: Colors.black,
          // )
        ],
      ),
      bottomNavigationBar: Stack(
        children: [
          FooterApp(sendMidtrans: () {
            _getSnapMidtransApi();
          }),
          loadOverlay
              ? Container(
                  width: size.width,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.0),
                  ))
              : Text(
                  '',
                  style: TextStyle(fontSize: 0),
                )
        ],
      ),
      body: isLoading
          ? reqLoad()
          : SlidingUpPanel(
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(.4), blurRadius: 3.0)
              ],
              minHeight: 60,
              maxHeight: 220,
              controller: _pc,
              onPanelOpened: () {
                // print(coba);
              },
              onPanelClosed: () {
                // print(coba);
              },
              panel: Center(
                child: Stack(
                  children: [
                    ApplyVoucher(),
                  ],
                ),
              ),
              body: Stack(
                children: [
                  _body(),
                  loadOverlay
                      ? Container(
                          width: size.width,
                          height: size.height - 130,
                          child: Image.asset(
                            'assets/fitness_app/global_loader.gif',
                            scale: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(.0),
                          ))
                      : Text(
                          '',
                          style: TextStyle(fontSize: 0),
                        )
                ],
              ),
              collapsed: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 25),
                  ),
                  SizedBox(
                    width: 18,
                    child: FaIcon(
                      FontAwesomeIcons.ticketAlt,
                      color: Colors.green,
                      size: 18,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                  ),
                  SizedBox(
                      width: size.width - 223, child: Text('Voucher Diskon')),
                  SizedBox(
                    width: 150,
                    child: RaisedButton(
                      color: Colors.deepOrange,
                      child: Text(
                        "GUNAKAN VOUCHER",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      onPressed: () => _pc.open(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _body() {
    return Container(
      // padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: ListView(
        children: <Widget>[
          Container(
              child: Column(
            children: [
              CheckOutProductDetailView(product: productDetail),
              ExpandableNotifier(
                  child: Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: <Widget>[
                      ScrollOnExpand(
                        scrollOnExpand: true,
                        scrollOnCollapse: true,
                        child: ExpandablePanel(
                          theme: const ExpandableThemeData(
                            headerAlignment:
                                ExpandablePanelHeaderAlignment.center,
                            tapBodyToCollapse: true,
                          ),
                          header: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                "Alamat Pengiriman",
                                style: Theme.of(context).textTheme.body2,
                              )),
                          collapsed: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fahmi',
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'Jl. Sudirman No.1, Candi, Sidoajo, Jawa Timur',
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'dasd',
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          expanded: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              for (var _ in Iterable.generate(5))
                                Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      'dasd',
                                      softWrap: true,
                                      overflow: TextOverflow.fade,
                                    )),
                            ],
                          ),
                          builder: (_, collapsed, expanded) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              child: Expandable(
                                collapsed: collapsed,
                                expanded: expanded,
                                theme: const ExpandableThemeData(
                                    crossFadePoint: 0),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )),
              ExpandableNotifier(
                  child: Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: <Widget>[
                      ScrollOnExpand(
                        scrollOnExpand: true,
                        scrollOnCollapse: true,
                        child: ExpandablePanel(
                          theme: const ExpandableThemeData(
                            headerAlignment:
                                ExpandablePanelHeaderAlignment.center,
                            tapBodyToCollapse: true,
                          ),
                          header: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                "ExpandablePanel",
                                style: Theme.of(context).textTheme.body2,
                              )),
                          collapsed: Text(
                            'dasd',
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          expanded: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              for (var _ in Iterable.generate(5))
                                Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      'dasd',
                                      softWrap: true,
                                      overflow: TextOverflow.fade,
                                    )),
                            ],
                          ),
                          builder: (_, collapsed, expanded) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              child: Expandable(
                                collapsed: collapsed,
                                expanded: expanded,
                                theme: const ExpandableThemeData(
                                    crossFadePoint: 0),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )),
              ExpandableNotifier(
                  child: Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: <Widget>[
                      ScrollOnExpand(
                        scrollOnExpand: true,
                        scrollOnCollapse: true,
                        child: ExpandablePanel(
                          theme: const ExpandableThemeData(
                            headerAlignment:
                                ExpandablePanelHeaderAlignment.center,
                            tapBodyToCollapse: true,
                          ),
                          header: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                "ExpandablePanel",
                                style: Theme.of(context).textTheme.body2,
                              )),
                          collapsed: Text(
                            'dasd',
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          expanded: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              for (var _ in Iterable.generate(5))
                                Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      'dasd',
                                      softWrap: true,
                                      overflow: TextOverflow.fade,
                                    )),
                            ],
                          ),
                          builder: (_, collapsed, expanded) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              child: Expandable(
                                collapsed: collapsed,
                                expanded: expanded,
                                theme: const ExpandableThemeData(
                                    crossFadePoint: 0),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )),
              ExpandableNotifier(
                  child: Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: <Widget>[
                      ScrollOnExpand(
                        scrollOnExpand: true,
                        scrollOnCollapse: true,
                        child: ExpandablePanel(
                          theme: const ExpandableThemeData(
                            headerAlignment:
                                ExpandablePanelHeaderAlignment.center,
                            tapBodyToCollapse: true,
                          ),
                          header: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                "ExpandablePanel",
                                style: Theme.of(context).textTheme.body2,
                              )),
                          collapsed: Text(
                            'dasd',
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          expanded: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              for (var _ in Iterable.generate(5))
                                Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      'dasd',
                                      softWrap: true,
                                      overflow: TextOverflow.fade,
                                    )),
                            ],
                          ),
                          builder: (_, collapsed, expanded) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              child: Expandable(
                                collapsed: collapsed,
                                expanded: expanded,
                                theme: const ExpandableThemeData(
                                    crossFadePoint: 0),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ))
            ],
          )),
        ],
      ),
    );
  }
}

class FooterApp extends StatelessWidget {
  const FooterApp({Key key, this.sendMidtrans}) : super(key: key);

  final Function() sendMidtrans;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return PreferredSize(
      preferredSize: Size.fromHeight(80.0),
      child: BottomAppBar(
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: size.width - 110,
              height: 70,
              padding: EdgeInsets.only(top: 15, bottom: 5, left: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Subtotal',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'Rp4.000.000',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
            ),
            InkWell(
              onTap: () {
                sendMidtrans();
              },
              child: Container(
                height: 50,
                color: Colors.green,
                alignment: Alignment.center,
                width: 90,
                child: Text(
                  'BAYAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ApplyVoucher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(top: 25),
      height: 130,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 15),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(bottom: 10),
              child: Text('Punya kode voucher? masukkan di sini',
                  style: TextStyle(color: Colors.black54))),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: sizeu.width - 80 - 30,
                height: 40,
                child: TextField(
                  textAlign: TextAlign.left,
                  onChanged: (text) => {},
                  decoration: new InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38, width: 1),
                    ),
                    hintText: 'Masukkan kode voucher',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: SizedBox(
                  height: 40,
                  width: 75,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(4.0),
                        bottomLeft: Radius.circular(4.0),
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
                    ),
                    onPressed: () {},
                    color: Colors.green,
                    child: Text(
                      'SET',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(1, 10, 1, 1),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.green, fontSize: 15),
                  children: [
                    TextSpan(text: 'Voucher FREE1 telah dipakai '),
                    WidgetSpan(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class DetailAlamat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(bottom: 15),
      width: size.width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            child: Padding(
                padding: EdgeInsets.fromLTRB(15, 1, 15, 15),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.green, fontSize: 16),
                    children: [
                      TextSpan(text: 'Tambah / Pilih Alamat '),
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Icon(
                            Icons.add_location,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. sapien leo lobortis quam, sed finibus tortor metus a dolor. Maecenas et ligula nibh.',
              style: TextStyle(
                fontSize: 15,
              ),
              textAlign: TextAlign.start,
              maxLines: 4,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailPengiriman extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(bottom: 15),
      width: size.width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            child: Padding(
                padding: EdgeInsets.fromLTRB(15, 1, 15, 15),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.green, fontSize: 16),
                    children: [
                      TextSpan(text: 'Pilih Kurir Pengiriman '),
                      // WidgetSpan(
                      //   child: Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      //     child: Icon(
                      //       Icons.add,
                      //       color: Colors.green,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                )),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: Row(
              children: [
                Text(
                  'JNE Reguler (2 Hari) ',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.start,
                  maxLines: 7,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: Row(
              children: [
                Text(
                  'Ongkos Kirim : ',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.start,
                  maxLines: 7,
                ),
                Text(
                  'Rp. 15.000,00',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Colors.green),
                  textAlign: TextAlign.start,
                  maxLines: 7,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// end stack end
