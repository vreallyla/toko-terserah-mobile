import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:best_flutter_ui_templates/Constant/Constant.dart';
import 'package:best_flutter_ui_templates/Constant/expandeable_custom.dart';
import 'package:best_flutter_ui_templates/Controllers/harga_controller.dart';
import 'package:best_flutter_ui_templates/design_course/test.dart';
import 'package:best_flutter_ui_templates/fitness_app/check_out/product_detail_view.dart';
import 'package:best_flutter_ui_templates/fitness_app/midtrans/midtrans_screen.dart';
import 'package:best_flutter_ui_templates/fitness_app/register/register_screen_i.dart';
import 'package:best_flutter_ui_templates/model/alamat_model.dart';
import 'package:best_flutter_ui_templates/model/keranjang_model.dart';
import 'package:best_flutter_ui_templates/model/midtrans_model.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:math' as math;

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
  bool isWrong = false;
  String subnotice = '';
  bool loadOverlay = false;
  Map<String, dynamic> productDetail = {};
  bool showExpand = false;
  Color animateColor = Colors.white;
  List daftarAlamat = [];
  Map<String, dynamic> alamatPengiriman;
  Map<String, dynamic> alamatPenagihan;
  Map<String, dynamic> dataSurabaya;

  // hide show
  bool pengirimanCollapse = false;
  bool penagihanCollapse = false;
  bool opsiCollapse = false;
  bool opsiLogistikCollapse = false;
  bool catatanCollapse = false;

  //harga
  double totalProduct = 0;
  double potonganVoucher = 0;
  double tambahanOngkir = 0;
  double beratProduct = 0;

  // CATATAN
  String catatanValue = '';
  TextEditingController catatanInput = new TextEditingController();

  //opsi pengiriman
  String pilihanOpsi = ''; // '' = belum pilih; logistik;terserah;ambil
  String kodeKurir = '', layananKurir = ''; // berdasarkan raja ongkir
  List rajaOngkirData = [];
  List dataLayanan = [];
  Map<String, dynamic> layananDetail;

  // gunakan voucher
  String kodeVoucherDigunakan = '';

  //overlay loading event
  void loadOverlayEvent(bool cond) {
    setState(() {
      loadOverlay = cond;
    });
  }

  //ucwords
  capitalize(String string) {
    return "${string[0].toUpperCase()}${string.substring(1)}";
  }

  // chunk to two data layanan
  layananPartision(List data) {
    List chunks = [];
    for (var i = 0; i < data.length; i += 2) {
      chunks.add(data.sublist(i, i + 2 > data.length ? data.length : i + 2));
    }
    dataLayanan = chunks;
  }

  // replace data layanan by courier
  selectionCorierData(String res) {
    List<int> example = [1, 2, 3];

    for (Map e in rajaOngkirData) {
      if (e['code'] == res) {
        List callb = e['costs'];
        layananPartision(callb);
        break;
      }
    }
  }

  // check etd by hari jam menit
  formatETD(String etd) {
    String unit = '';
    if (etd != "") {
      if (etd.toLowerCase().indexOf('hari') < 0 &&
          etd.toLowerCase().indexOf('jam') < 0) {
        unit = ' hari';
      }
      return etd.toLowerCase() + unit;
    } else {
      return 'N/A';
    }
  }

  _getDataApi() async {
    List data = widget.idProducts;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await KeranjangModel.getCart(data).then((value) {
          Map<String, dynamic> resProduct = json.decode(value.data);
          if (value.error) {
            resError(resProduct);
          } else {
            totalProduct = 0;
            productDetail = resProduct;
            List dataPro = productDetail['produk'];

            for (int i = 0; i < dataPro.length; i++) {
              totalProduct = totalProduct +
                  (nilaiDoubleHarga(dataPro[i]['get_produk']) *
                      double.parse(dataPro[i]['qty']));
              beratProduct = beratProduct + (double.parse(dataPro[i]['berat']));
            }

            _getAlamatApi();
            // print('hello');
          }
          setState(() {});
        });
      }
    } on SocketException catch (_) {
      loadNotice(context, 'hello', true, 'OK', () {});

      isConnect = false;
      isLoading = false;
      isWrong = true;

      setState(() {});
    }
  }

  resError(Map<String, dynamic> resProduct) {
    isWrong = true;
    isLoading = false;
    subnotice = resProduct['message'];
    setState(() {});
  }

  _getAlamatApi() async {
    List data = widget.idProducts;
    // print(data);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await AlamatModel.getAlamat().then((value) {
          isLoading = false;
          Map<String, dynamic> resAlamat = json.decode(value.data);

          if (value.error) {
            resError(resAlamat);
          } else {
            isLoading = false;
            daftarAlamat = resAlamat['address'];
            alamatPengiriman = alamatPenagihan = resAlamat['isUtama'] != null
                ? resAlamat['isUtama']
                : (resAlamat['address'].length > 0
                    ? resAlamat['address'][0]
                    : null);

            dataSurabaya = resAlamat['surabaya'];
            _getHargaByRajaOngkir();

            setState(() {});
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
                    token: tokenFixed,
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

  _getHargaByRajaOngkir() async {
    try {
      String idKecamatan = alamatPengiriman['kecamatan_id'].toString();

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await AlamatModel.getRajaOngkir(
          idKecamatan,
          beratProduct.toString(),
        ).then((value) {
          loadOverlayEvent(false);
          print(loadOverlay);
          isLoading = false;

          if (value.error) {
            loadNotice(
                context, 'Terjadi kesalahan pada opsi pengiriman!', false, 'OK',
                () {
              Navigator.of(context).pop();
            });
          } else {
            rajaOngkirData = json.decode(value.data)['results'];

            // print('hello');
          }
          setState(() {});
        });
      }
    } on SocketException catch (_) {
      loadOverlayEvent(false);
      loadNotice(
          context, 'Terjadi kesalahan pada opsi pengiriman!', false, 'OK', () {
        Navigator.of(context).pop();
      });

      isConnect = false;
      isLoading = false;

      setState(() {});
    }
  }

  String tokenFixed = '';

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
        elevation: 0,
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
          FooterApp(
              sendMidtrans: () {
                _getSnapMidtransApi();
              },
              total:
                  (totalProduct + tambahanOngkir + potonganVoucher).toString()),
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
      body: isWrong
          ? pesanFullScreen(() {
              isWrong = false;
              isLoading = true;
              _getDataApi();
              setState(() {});
            }, 'Terjadi Kesalahan', subnotice, 'OK')
          : (!isConnect
              ? noConnection()
              : (isLoading
                  ? reqLoad()
                  : SlidingUpPanel(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
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
                      //slide
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
                              width: size.width - 223,
                              child: Text('Voucher Diskon')),
                          SizedBox(
                            width: 150,
                            child: RaisedButton(
                              color: Colors.deepOrange,
                              child: Text(
                                "GUNAKAN VOUCHER",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                              onPressed: () => _pc.open(),
                            ),
                          ),
                        ],
                      ),
                    ))),
    );
  }

  Widget _body() {
    final size = MediaQuery.of(context).size;
    double _width = size.width;

    return Container(
      padding: EdgeInsets.only(
        bottom: 40,
      ),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: 180),
        children: <Widget>[
          CheckOutProductDetailView(product: productDetail),
          // Catatan
          ExpandableCustom(
            show: catatanCollapse,
            funcShowHide: (bool hideOrShow) {
              catatanCollapse = hideOrShow;
              setState(() {});
            },
            icon: FontAwesomeIcons.solidEdit,
            head: Row(
              children: [
                Text(
                  'CATATAN',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            bodyHide: Text(
              catatanValue.length == 0 ? 'Kosong...' : catatanValue,
              textAlign: catatanValue.length == 0
                  ? TextAlign.center
                  : TextAlign.justify,
            ),
            bodyShow: SizedBox(
              child: TextField(
                style:
                    TextStyle(fontSize: 13.0, height: 1, color: Colors.black),
                controller: catatanInput,
                textAlign: TextAlign.start,
                maxLines: 4,
                maxLength: 250,
                onChanged: (text) => {setState(() {})},
                decoration: new InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38, width: 1),
                  ),
                  hintText: 'Catatan....',
                ),
              ),
            ),
            useFooter: catatanCollapse,
            footer: SizedBox(
              width: _width - 30,
              height: 30,
              child: RaisedButton(
                onPressed: () {
                  catatanCollapse=false;
                  catatanValue=catatanInput.text;
                  setState(() {
                    
                  });
                },
                color: Colors.green,
                child: Text(
                  'SIMPAN',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),

          // alamat pengiriman
          Padding(
            padding: EdgeInsets.only(top: 15),
          ),

          ExpandableCustom(
            show: pengirimanCollapse,
            funcShowHide: (bool hideOrShow) {
              pengirimanCollapse = hideOrShow;
              setState(() {});
            },
            icon: FontAwesomeIcons.solidEdit,
            head: Row(
              children: [
                Text(
                  'ALAMAT PENGIRIMAN',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                // Padding(
                //   padding: EdgeInsets.only(left: 5),
                // ),
                // FaIcon(
                //   FontAwesomeIcons.solidPlusSquare,
                //   size: 16,
                //   color: Colors.grey,
                // )
              ],
            ),
            bodyHide: alamatPengiriman == null
                ? Text(
                    'Belum ada alamat terdaftar!',
                    textAlign: TextAlign.center,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Container(
                            child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                top: 4,
                              ),
                              margin: EdgeInsets.only(right: 10),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(locationOccupation +
                                      alamatPengiriman['get_occupancy']
                                          ['image']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                                width: size.width - 30 - 10 - 20 - 120,
                                child: Text(
                                    alamatPengiriman['get_occupancy']['name'],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ))),
                            Container(
                              width: 120,
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {},
                                child: Text('DIPILIH',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    )),
                              ),
                            )
                          ],
                        )),
                        //nama
                        Container(
                          padding: EdgeInsets.only(left: 30, top: 5),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 15,
                                  padding: EdgeInsets.only(top: 2),
                                  child: FaIcon(
                                    FontAwesomeIcons.idCard,
                                    size: 13,
                                    color: Colors.black45,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                ),
                                Container(
                                    width: size.width - 30 - 30 - 10 - 20,
                                    child: Text(
                                      alamatPengiriman['nama'],
                                      maxLines: 1,
                                    )),
                              ]),
                        ),
                        // no telp
                        Container(
                          padding: EdgeInsets.only(left: 30, top: 5),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 15,
                                  padding: EdgeInsets.only(top: 2),
                                  child: FaIcon(
                                    FontAwesomeIcons.phone,
                                    size: 13,
                                    color: Colors.black45,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                ),
                                Container(
                                    width: size.width - 30 - 30 - 10 - 20,
                                    child: Text(
                                      alamatPengiriman['telp'] == null
                                          ? '-'
                                          : alamatPengiriman['telp'],
                                      maxLines: 1,
                                    )),
                              ]),
                        ),
                        // alamat
                        Container(
                          padding: EdgeInsets.only(left: 30, top: 5),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 15,
                                  padding: EdgeInsets.only(top: 2),
                                  child: FaIcon(
                                    FontAwesomeIcons.mapMarkedAlt,
                                    size: 13,
                                    color: Colors.black45,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                ),
                                Container(
                                    width: size.width - 30 - 30 - 10 - 20,
                                    child: Text(
                                      alamatPengiriman['alamat'],
                                      maxLines: 4,
                                    )),
                              ]),
                        ),
                      ]),
            bodyShow: alamatPengiriman == null
                ? Text(
                    'Belum ada alamat terdaftar!',
                    textAlign: TextAlign.center,
                  )
                : Container(
                    height: 250,
                    child: ListView(
                      children: daftarAlamat.map((e) {
                        double widthBoder = 4;
                        bool kondCHeck = e['id'] == alamatPengiriman['id'];
                        return InkWell(
                          onTap: () {
                            alamatPengiriman = e;
                            if (alamatPengiriman['get_kecamatan']['kota_id'] !=
                                    dataSurabaya['id'] ||
                                pilihanOpsi == 'logistik') {
                              pilihanOpsi = '';
                              tambahanOngkir = 0;
                              loadOverlayEvent(true);
                              _getHargaByRajaOngkir();
                            }

                            setState(() {
                              pengirimanCollapse = !pengirimanCollapse;

                              pengirimanCollapse = false;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: widthBoder / (kondCHeck ? 2 : 4),
                                color: kondCHeck
                                    ? Colors.green
                                    : Colors.grey.withOpacity(.4),
                              ),
                              // borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(
                                          top: 4,
                                        ),
                                        margin: EdgeInsets.only(right: 10),
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                locationOccupation +
                                                    e['get_occupancy']
                                                        ['image']),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Container(
                                          width: size.width -
                                              30 -
                                              10 -
                                              20 -
                                              120 -
                                              10 -
                                              widthBoder,
                                          child:
                                              Text(e['get_occupancy']['name'],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                  ))),
                                      Container(
                                        width: 120,
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: () {},
                                          child: Icon(Icons.check,
                                              color: Colors.green,
                                              size: kondCHeck ? 20 : 0),
                                        ),
                                      )
                                    ],
                                  )),
                                  //nama
                                  Container(
                                    padding: EdgeInsets.only(left: 30, top: 5),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: 15,
                                            padding: EdgeInsets.only(top: 2),
                                            child: FaIcon(
                                              FontAwesomeIcons.idCard,
                                              size: 13,
                                              color: Colors.black45,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 5),
                                          ),
                                          Container(
                                              width: size.width -
                                                  30 -
                                                  30 -
                                                  10 -
                                                  20 -
                                                  widthBoder,
                                              child: Text(
                                                e['nama'],
                                                maxLines: 1,
                                              )),
                                        ]),
                                  ),
                                  // no telp
                                  Container(
                                    padding: EdgeInsets.only(left: 30, top: 5),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: 15,
                                            padding: EdgeInsets.only(top: 2),
                                            child: FaIcon(
                                              FontAwesomeIcons.phone,
                                              size: 13,
                                              color: Colors.black45,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 5),
                                          ),
                                          Container(
                                              width: size.width -
                                                  30 -
                                                  30 -
                                                  10 -
                                                  20 -
                                                  widthBoder,
                                              child: Text(
                                                e['telp'] == null
                                                    ? '-'
                                                    : e['telp'],
                                                maxLines: 1,
                                              )),
                                        ]),
                                  ),
                                  // alamat
                                  Container(
                                    padding: EdgeInsets.only(left: 30, top: 5),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: 15,
                                            padding: EdgeInsets.only(top: 2),
                                            child: FaIcon(
                                              FontAwesomeIcons.mapMarkedAlt,
                                              size: 13,
                                              color: Colors.black45,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 5),
                                          ),
                                          Container(
                                              width: size.width -
                                                  30 -
                                                  30 -
                                                  10 -
                                                  20 -
                                                  widthBoder,
                                              child: Text(
                                                e['alamat'],
                                                maxLines: 4,
                                              )),
                                        ]),
                                  ),
                                ]),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
            useFooter: true,
            footer: SizedBox(
              width: _width - 30,
              height: 30,
              child: RaisedButton(
                onPressed: () {},
                color: Colors.green,
                child: Text(
                  'TAMBAH ALAMAT',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),

          // opsi pengiriman
          Padding(
            padding: EdgeInsets.only(top: 15),
          ),
          ExpandableCustom(
            show: opsiCollapse,
            funcShowHide: (bool hideOrShow) {
              opsiCollapse = hideOrShow;
              opsiLogistikCollapse = false;
              // print('dasd');
              setState(() {});
            },
            icon: FontAwesomeIcons.solidEdit,
            head: Text(
              'OPSI PENGIRIMAN',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            bodyHide: pilihanOpsi.length == 0
                ? Text(
                    'Anda belum memilih opsi pengiriman',
                    textAlign: TextAlign.center,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Container(
                            child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                top: 4,
                              ),
                              margin: EdgeInsets.only(right: 10),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(pilihanOpsi == 'logistik' &&
                                          kodeKurir.length > 0
                                      ? 'assets/fitness_app/' +
                                          kodeKurir +
                                          '.png'
                                      : 'assets/fitness_app/logo.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Container(
                                width: size.width - 30 - 10 - 20 - 120,
                                child: Text(
                                    pilihanOpsi == 'ambil'
                                        ? 'Ambil di Toko Terserah'
                                        : (pilihanOpsi == 'logistik'
                                            ? (kodeKurir == 'pos'
                                                ? 'Pos Indonesia'
                                                : kodeKurir.toUpperCase())
                                            : 'Kuris Toko Terserah'),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ))),
                            Container(
                              width: 120,
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {},
                                child: Text('DIPILIH',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    )),
                              ),
                            )
                          ],
                        )),
                        //nama layanan
                        Container(
                          padding: EdgeInsets.only(left: 30, top: 5),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 15,
                                  padding: EdgeInsets.only(top: 2),
                                  child: FaIcon(
                                    FontAwesomeIcons.shippingFast,
                                    size: 13,
                                    color: Colors.black45,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                ),
                                Container(
                                    width: size.width - 30 - 30 - 10 - 20,
                                    child: Text(
                                      pilihanOpsi == 'ambil'
                                          ? 'Ambil di Toko Terserah'
                                          : (pilihanOpsi == 'logistik'
                                              ? (layananDetail
                                                      .containsKey('service')
                                                  ? layananDetail['description']
                                                  : 'Logistik')
                                              : 'Kuris Toko Terserah'),
                                      maxLines: 1,
                                    )),
                              ]),
                        ),
                        // waktu
                        Container(
                          padding: EdgeInsets.only(left: 30, top: 5),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 15,
                                  padding: EdgeInsets.only(top: 2),
                                  child: FaIcon(
                                    FontAwesomeIcons.solidClock,
                                    size: 13,
                                    color: Colors.black45,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                ),
                                Container(
                                    width: size.width - 30 - 30 - 10 - 20,
                                    child: Text(
                                      pilihanOpsi == 'logistik'
                                          ? formatETD(
                                              layananDetail['cost'][0]['etd'])
                                          : '-',
                                      maxLines: 1,
                                    )),
                              ]),
                        ),
                        // harga
                        Container(
                          padding: EdgeInsets.only(left: 30, top: 5),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 15,
                                  padding: EdgeInsets.only(top: 2),
                                  child: FaIcon(
                                    FontAwesomeIcons.moneyBill,
                                    size: 13,
                                    color: Colors.black45,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                ),
                                Container(
                                    width: size.width - 30 - 30 - 10 - 20,
                                    child: Text(
                                      pilihanOpsi == 'logistik'
                                          ? 'Rp' +
                                              decimalPointTwo(double.parse(
                                                  layananDetail['cost'][0]
                                                          ['value']
                                                      .toString()))
                                          : 'Rp0,00',
                                      maxLines: 4,
                                    )),
                              ]),
                        ),
                      ]),
            bodyShow: opsiKonten(),
            useFooter: opsiLogistikCollapse,
            footer: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 40),
                  height: 30,
                  width: (_width - 30) / 2 - 10 - 40,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        // borderRadius:
                        //     BorderRadius.circular(4.0),
                        side: BorderSide(color: Colors.green)),
                    onPressed: () {
                      opsiLogistikCollapse = false;
                      kodeKurir = layananKurir = '';
                      pilihanOpsi = '';
                      setState(() {});
                    },
                    color: Colors.white,
                    child: Text(
                      'RESET',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                ),
                Container(
                  margin: EdgeInsets.only(right: 40),
                  height: 30,
                  width: (_width - 30) / 2 - 10 - 40,
                  child: RaisedButton(
                    onPressed: () {
                      opsiLogistikCollapse = false;
                      opsiCollapse = false;
                      pilihanOpsi = 'logistik';
                      setState(() {});
                    },
                    color: kodeKurir.length > 0 && layananKurir.length > 0
                        ? Colors.green
                        : Colors.green[200],
                    child: Text(
                      'SET',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // alamat penagihan
          Padding(
            padding: EdgeInsets.only(top: 15),
          ),
          ExpandableCustom(
            show: penagihanCollapse,
            funcShowHide: (bool hideOrShow) {
              penagihanCollapse = hideOrShow;
              setState(() {});
            },
            icon: FontAwesomeIcons.solidEdit,
            head: Text(
              'ALAMAT PENAGIHAN',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            bodyHide: alamatPenagihan == null
                ? Text(
                    'Belum ada alamat terdaftar!',
                    textAlign: TextAlign.center,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Container(
                            child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                top: 4,
                              ),
                              margin: EdgeInsets.only(right: 10),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(locationOccupation +
                                      alamatPenagihan['get_occupancy']
                                          ['image']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                                width: size.width - 30 - 10 - 20 - 120,
                                child: Text(
                                    alamatPenagihan['get_occupancy']['name'],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ))),
                            Container(
                              width: 120,
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {},
                                child: Text('DIPILIH',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    )),
                              ),
                            )
                          ],
                        )),
                        //nama
                        Container(
                          padding: EdgeInsets.only(left: 30, top: 5),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 15,
                                  padding: EdgeInsets.only(top: 2),
                                  child: FaIcon(
                                    FontAwesomeIcons.idCard,
                                    size: 13,
                                    color: Colors.black45,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                ),
                                Container(
                                    width: size.width - 30 - 30 - 10 - 20,
                                    child: Text(
                                      alamatPenagihan['nama'],
                                      maxLines: 1,
                                    )),
                              ]),
                        ),
                        // no telp
                        Container(
                          padding: EdgeInsets.only(left: 30, top: 5),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 15,
                                  padding: EdgeInsets.only(top: 2),
                                  child: FaIcon(
                                    FontAwesomeIcons.phone,
                                    size: 13,
                                    color: Colors.black45,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                ),
                                Container(
                                    width: size.width - 30 - 30 - 10 - 20,
                                    child: Text(
                                      alamatPenagihan['telp'] == null
                                          ? '-'
                                          : alamatPengiriman['telp'],
                                      maxLines: 1,
                                    )),
                              ]),
                        ),
                        // alamat
                        Container(
                          padding: EdgeInsets.only(left: 30, top: 5),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 15,
                                  padding: EdgeInsets.only(top: 2),
                                  child: FaIcon(
                                    FontAwesomeIcons.mapMarkedAlt,
                                    size: 13,
                                    color: Colors.black45,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                ),
                                Container(
                                    width: size.width - 30 - 30 - 10 - 20,
                                    child: Text(
                                      alamatPenagihan['alamat'],
                                      maxLines: 4,
                                    )),
                              ]),
                        ),
                      ]),
            bodyShow: alamatPenagihan == null
                ? Text(
                    'Belum ada alamat terdaftar!',
                    textAlign: TextAlign.center,
                  )
                : Container(
                    height: 250,
                    child: ListView(
                      children: daftarAlamat.map((e) {
                        double widthBoder = 4;
                        bool kondCHeck = e['id'] == alamatPenagihan['id'];
                        return InkWell(
                          onTap: () {
                            alamatPenagihan = e;
                            setState(() {
                              penagihanCollapse = false;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: widthBoder / (kondCHeck ? 2 : 4),
                                color: kondCHeck
                                    ? Colors.green
                                    : Colors.grey.withOpacity(.4),
                              ),
                              // borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(
                                          top: 4,
                                        ),
                                        margin: EdgeInsets.only(right: 10),
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                locationOccupation +
                                                    e['get_occupancy']
                                                        ['image']),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Container(
                                          width: size.width -
                                              30 -
                                              10 -
                                              20 -
                                              120 -
                                              10 -
                                              widthBoder,
                                          child:
                                              Text(e['get_occupancy']['name'],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                  ))),
                                      Container(
                                        width: 120,
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: () {},
                                          child: Icon(Icons.check,
                                              color: Colors.green,
                                              size: kondCHeck ? 20 : 0),
                                        ),
                                      )
                                    ],
                                  )),
                                  //nama
                                  Container(
                                    padding: EdgeInsets.only(left: 30, top: 5),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: 15,
                                            padding: EdgeInsets.only(top: 2),
                                            child: FaIcon(
                                              FontAwesomeIcons.idCard,
                                              size: 13,
                                              color: Colors.black45,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 5),
                                          ),
                                          Container(
                                              width: size.width -
                                                  30 -
                                                  30 -
                                                  10 -
                                                  20 -
                                                  widthBoder,
                                              child: Text(
                                                e['nama'],
                                                maxLines: 1,
                                              )),
                                        ]),
                                  ),
                                  // no telp
                                  Container(
                                    padding: EdgeInsets.only(left: 30, top: 5),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: 15,
                                            padding: EdgeInsets.only(top: 2),
                                            child: FaIcon(
                                              FontAwesomeIcons.phone,
                                              size: 13,
                                              color: Colors.black45,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 5),
                                          ),
                                          Container(
                                              width: size.width -
                                                  30 -
                                                  30 -
                                                  10 -
                                                  20 -
                                                  widthBoder,
                                              child: Text(
                                                e['telp'] == null
                                                    ? '-'
                                                    : e['telp'],
                                                maxLines: 1,
                                              )),
                                        ]),
                                  ),
                                  // alamat
                                  Container(
                                    padding: EdgeInsets.only(left: 30, top: 5),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: 15,
                                            padding: EdgeInsets.only(top: 2),
                                            child: FaIcon(
                                              FontAwesomeIcons.mapMarkedAlt,
                                              size: 13,
                                              color: Colors.black45,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 5),
                                          ),
                                          Container(
                                              width: size.width -
                                                  30 -
                                                  30 -
                                                  10 -
                                                  20 -
                                                  widthBoder,
                                              child: Text(
                                                e['alamat'],
                                                maxLines: 4,
                                              )),
                                        ]),
                                  ),
                                ]),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
            useFooter: false,
          ),
        ],
      ),
    );
  }

  Widget opsiKonten() {
    final size = MediaQuery.of(context).size;
    double _width = size.width;
    // pilihan opsi logistik
    if (opsiLogistikCollapse) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Logistik :'),
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                children: [
                  //jne
                  InkWell(
                    onTap: () {
                      kodeKurir = 'jne';
                      layananKurir = '';
                      selectionCorierData('jne');

                      // layananPartision(rajaOngkirData)
                      setState(() {});
                    },
                    child: Container(
                      padding: EdgeInsets.all(3),
                      width: (_width - 30 - 20) / 3,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: kodeKurir == 'jne'
                              ? Colors.green
                              : Colors.grey.withOpacity(.6),
                        ),
                        color: Colors.white,
                      ),
                      child: Image.asset(
                        'assets/fitness_app/jne.png',
                        fit: BoxFit.fitWidth,
                        // scale: 1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                  ),
                  //tiki
                  InkWell(
                    onTap: () {
                      kodeKurir = 'tiki';
                      layananKurir = '';
                      selectionCorierData('tiki');

                      setState(() {});
                    },
                    child: Container(
                      padding: EdgeInsets.all(3),
                      width: (_width - 30 - 20) / 3,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: kodeKurir == 'tiki'
                              ? Colors.green
                              : Colors.grey.withOpacity(.6),
                        ),
                        color: Colors.white,
                      ),
                      child: Image.asset(
                        'assets/fitness_app/tiki.png',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                  ),
                  // pos indonesia
                  InkWell(
                    onTap: () {
                      kodeKurir = 'pos';
                      layananKurir = '';
                      selectionCorierData('pos');

                      setState(() {});
                    },
                    child: Container(
                      padding: EdgeInsets.all(3),
                      width: (_width - 30 - 20) / 3,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: kodeKurir == 'pos'
                              ? Colors.green
                              : Colors.grey.withOpacity(.6),
                        ),
                        color: Colors.white,
                      ),
                      child: Image.asset(
                        'assets/fitness_app/pos.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Text('Jenis Layanan :'),
            dataLayanan.length == 0
                ? Text(
                    '',
                    style: TextStyle(fontSize: 0),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: dataLayanan.map((e) {
                      var das = <Widget>[];

                      for (var i = 0; i < e.length; i++) {
                        das.add(InkWell(
                          onTap: () {
                            layananKurir = e[i]['service'];
                            layananDetail = e[i];
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.only(
                                left: i != 0 ? 5 : 0, right: i == 0 ? 5 : 0),
                            width: (_width - 30 - 10) / 2,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: layananKurir == e[i]['service']
                                    ? Colors.green
                                    : Colors.grey.withOpacity(.6),
                              ),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // nama layanan
                                Padding(
                                  padding: EdgeInsets.only(top: 3, bottom: 3),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 25,
                                        child: FaIcon(
                                          FontAwesomeIcons.shippingFast,
                                          size: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(
                                        width: (_width -
                                                30 -
                                                10 -
                                                4 -
                                                25 -
                                                16 -
                                                10 -
                                                40) /
                                            2,
                                        child: Text(
                                          e[i]['description'],
                                          style: TextStyle(
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // estimasi layanan
                                Padding(
                                  padding: EdgeInsets.only(top: 3, bottom: 3),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 25,
                                        child: FaIcon(
                                          FontAwesomeIcons.solidClock,
                                          size: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(
                                        width: (_width -
                                                30 -
                                                10 -
                                                4 -
                                                25 -
                                                16 -
                                                10 -
                                                40) /
                                            2,
                                        child: Text(
                                          formatETD(e[i]['cost'][0]['etd']),
                                          style: TextStyle(
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // harga layanan
                                Padding(
                                  padding: EdgeInsets.only(top: 3, bottom: 3),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 25,
                                        child: FaIcon(
                                          FontAwesomeIcons.moneyBill,
                                          size: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(
                                        width: (_width -
                                                30 -
                                                10 -
                                                4 -
                                                25 -
                                                16 -
                                                10 -
                                                40) /
                                            2,
                                        child: Text(
                                          'Rp' +
                                              decimalPointTwo(double.parse(e[i]
                                                      ['cost'][0]['value']
                                                  .toString())),
                                          style: TextStyle(
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
                      }

                      return Container(
                        padding: EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                        ),
                        child: Row(
                          children: das,
                        ),
                      );
                    }).toList())
          ],
        ),
      );
    }
    // pilihan opsi logistik, kurir, ambil ketoko
    else {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //opsi pilihan btn
            Row(
              children: [
                // logistik
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      opsiLogistikCollapse = true;
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 5, right: 5),
                      padding: EdgeInsets.all(5),
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: pilihanOpsi == 'logistik'
                              ? Colors.green
                              : Colors.grey.withOpacity(.6),
                        ),
                        color: Colors.white,
                      ),
                      child: Text(
                        'Logistik (JNE/POS/TIKI)',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                // kurir
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      if (alamatPengiriman['get_kecamatan']['kota_id'] ==
                              dataSurabaya['id'] &&
                          totalProduct > 200000) {
                        setState(() {
                          pilihanOpsi = 'terserah';
                          opsiCollapse = false;
                          tambahanOngkir = 0;
                        });
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 5, right: 5),
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: pilihanOpsi == 'terserah'
                              ? Colors.green
                              : (alamatPengiriman['get_kecamatan']['kota_id'] ==
                                          dataSurabaya['id'] &&
                                      totalProduct > 200000
                                  ? Colors.grey.withOpacity(.6)
                                  : Colors.grey.withOpacity(.3)),
                        ),
                        color: Colors.white,
                      ),
                      child: Text(
                        'Kurir Toko Terserah',
                        style: TextStyle(
                          color: alamatPengiriman['get_kecamatan']['kota_id'] ==
                                      dataSurabaya['id'] &&
                                  totalProduct > 200000
                              ? Colors.black
                              : Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                // ambil di toko
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      opsiCollapse = !opsiCollapse;
                      pilihanOpsi = 'ambil';
                      tambahanOngkir = 0;
                      setState(() {});
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 5, right: 5),
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: pilihanOpsi == 'ambil'
                              ? Colors.green
                              : Colors.grey.withOpacity(.6),
                        ),
                        color: Colors.white,
                      ),
                      child: Text(
                        'Ambil di Toko Terserah',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // notice opsi pengiriman
            Container(
                width: _width - 30 - 10,
                padding: EdgeInsets.only(left: 5, top: 10),
                child: RichText(
                  text: TextSpan(
                    text: 'Opsi pengiriman ',
                    style: TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: '"Kurir Toko Terserah"',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: ' hanya berlaku untuk :'),
                    ],
                  ),
                )),
            Container(
              width: _width - 30 - 10,
              padding: EdgeInsets.only(left: 5, top: 5),
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.angleRight,
                    size: 16,
                  ),
                  Container(
                    width: _width - 30 - 10 - 16,
                    padding: EdgeInsets.only(left: 5),
                    child: Text('Pembelian diatas Rp200.000,00 '),
                  )
                ],
              ),
            ),
            Container(
              width: _width - 30 - 10,
              padding: EdgeInsets.only(left: 5, top: 5),
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.angleRight,
                    size: 16,
                  ),
                  Container(
                    width: _width - 30 - 10 - 16,
                    padding: EdgeInsets.only(left: 5),
                    child:
                        Text('Pengiriman di daerah Surabaya dan sekitarnya.'),
                  )
                ],
              ),
            )
          ],
        ),
      );
    }
  }
}

class FooterApp extends StatelessWidget {
  const FooterApp({Key key, this.sendMidtrans, this.total: '0'})
      : super(key: key);

  final Function() sendMidtrans;
  final String total;
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
                      withCurrency(total),
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
