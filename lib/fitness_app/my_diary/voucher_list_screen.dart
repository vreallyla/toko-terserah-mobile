import 'dart:convert';
import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:tokoterserah/model/product_model.dart';
// import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/material.dart';
import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:tokoterserah/Constant/Constant.dart';
import 'package:async/async.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VoucherListScreen extends StatefulWidget {
  const VoucherListScreen({Key key, this.animationController})
      : super(key: key);

  final AnimationController animationController;
  @override
  _VoucherListScreenState createState() => _VoucherListScreenState();
}

class _VoucherListScreenState extends State<VoucherListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<dynamic> _listCart;

  List _selecteCarts = List();

  bool isLoading = false, isConnect = true, isCheckAll = false;

  int _total = 0;

  String _token;

  int jmlhCart = 0, user_id;

  var dataUser;

  // lock back when load data
  bool canBack = true;

  final formatter = new NumberFormat("#,###.00", 'id_ID');

  String userData;
  TextEditingController cari = new TextEditingController();
  bool noData = false;

  int voucherCount = 0;
  List dataVoucher = [];
  List<Widget> dataRes = [];

  void addAllData() {
    dataRes = [];
    dataVoucher.forEach((element) {
      dataRes.add(cardVoucher(
        element['start'],
        element['end'],
        element['promo_code'],
        element['banner'],
        element['id'],
      ));
    });
    print('asd');
    setState(() {});
  }

  _getUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('token');
      dataUser = jsonDecode(prefs.getString('dataUser'));
      user_id = dataUser['user']['id'];
      print(user_id);
    } catch (e) {
      print(e);
    }
  }

  _getDataApis(String q) async {
    isLoading = true;
    noData = false;

    setState(() {});
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await ProductModel.getVoucher(q).then((v) {
          print(v.data);
          isLoading = false;
          dataVoucher = [];
          voucherCount = 0;

          if (v.error) {
            noData = true;
          } else {
            dataVoucher = v.data['daftar'];
            noData = !(v.data['jumlah'] > 0);
          }
          addAllData();

          setState(() {});
        });
      }
    } on SocketException catch (_) {
      noData = true;
      isLoading = false;

      setState(() {});
    }
  }

  _postVoucher(int voucher_id) async {
    try {
      final response = await http
          .post(globalBaseUrl + globalPathProduct + 'use_voucher', body: {
        'user_id': user_id.toString(),
        'voucher_id': voucher_id.toString()
      }, headers: {
        'Authorization': 'bearer ' + _token
      });

      if (response.statusCode == 200) {
        showSnackBar("Voucher Telah dipakai", Colors.green, Icon(Icons.check));
        setState(() {});
        _getDataApis('');
      } else {
        print(json.decode(response.body));
      }
    } catch (e) {
      print(e);
    }
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

  @override
  void initState() {
    super.initState();
    _getUser();
    Future.delayed(Duration.zero, () {
      _getDataApis('');
    });
  }

  @override
  Widget build(BuildContext context) {
    //final wh_ = MediaQuery.of(context).size;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return WillPopScope(
      onWillPop: () {
        if (canBack) {
          Navigator.pop(context, jmlhCart);
        } else {
          showSnackBar(
              'Harap tunggu loading!', Colors.red, Icon(Icons.notifications));

          return;
        }
      },
      child: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: new Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.grey[200],
              brightness: Brightness.light,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  if (canBack) {
                    Navigator.pop(context, jmlhCart);
                  } else {
                    showSnackBar('Harap tunggu loading!', Colors.red,
                        Icon(Icons.notifications));

                    return;
                  }
                },
              ),
              title: const Text(
                'Daftar Voucher',
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
            body:
                // (_token == null
                //     ? noLogin()
                //     : (!isConnect
                //         ? noConnection()
                //         : (!isLoading ? mainContainter(context) : reqLoad()))),
                mainContainter(context, bottom)),
      ),
    );
  }

  Widget noLogin() {
    return Container(
      alignment: Alignment.center,
      color: Color(0xfff0f4f7),
      padding: EdgeInsets.only(top: 120),
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
            'Maaf Sob',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Text('Silahkan login untuk menggunakan fitur ini',
              style: TextStyle(color: Colors.black54)),
          Container(
            margin: EdgeInsets.only(top: 15),
            child: RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              color: Colors.green,
              child: Text('Login', style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  Widget noConnection() {
    return Container(
      color: Color(0xfff0f4f7),
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 120),
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
                  isLoading = true;
                  isConnect = true;
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

  Widget mainContainter(context, bottom) {
    final wh_ = MediaQuery.of(context).size;

    return Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: .5, color: Colors.grey[300]),
              ),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    width: wh_.width - 51 - 70,
                    child: TextField(
                      controller: cari,
                      onSubmitted: (v) => _getDataApis(v),
                      style: TextStyle(
                        height: .5,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          hintText: 'Masukkan Kode Voucher',
                          labelText: 'Kode Voucher'),
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: RaisedButton(
                      color: Colors.green,
                      onPressed: () => _getDataApis(cari.text),
                      child: Text(
                        'Cari',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
            noData || isLoading
                ? Container(
                    height: wh_.height - 190 - bottom,
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: .5, color: Colors.grey[300]),
                    ),
                    child: isLoading
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                  'assets/fitness_app/global_loader.gif',
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover),
                            ],
                          )
                        : Container(
                            height: double.infinity,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/fitness_app/data_empty.png',
                                  width: 180,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    'Data tidak ditemukan!',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          ))
                : Container(
                    margin: EdgeInsets.only(top: 10),
                    width: double.infinity,
                    height: wh_.height - 190 - bottom,
                    child: ListView(
                      children: dataRes,
                    ),
                  )
          ],
        ));
  }

  Widget cardVoucher(start, end, kode, img, voucher_id) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: .5, color: Colors.grey[300]),
      ),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              height: 110,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                    image:
                        NetworkImage(img ?? 'https://via.placeholder.com/300'),
                    fit: BoxFit.fitWidth),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(0),
                  bottomLeft: Radius.circular(0),
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          kode,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Berlaku sampai : ${end}',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.topRight,
                        child: RaisedButton(
                          color: Colors.green,
                          onPressed: () {
                            // ClipboardManager.copyToClipBoard(kode)
                            //     .then((result) {
                            //   showSnackBar('Berhasil disalin!', Colors.green,
                            //       Icon(Icons.content_copy));
                            // });
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10.0)), //this right here
                                    child: Container(
                                      height:250,
                                      color: Colors.black,
                                      child: Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: 30, bottom: 10),
                                              child: Text(
                                                  'Scan Barcode ke Kasir Toko Terserah...',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 18)),
                                            ),
                                            Container(
                                                color: Colors.white,
                                                padding: EdgeInsets.all(5),
                                                height: 100,
                                                child: Column(
                                                  children: [
                                                    BarCodeImage(
                                                      params:
                                                          Code128BarCodeParams(
                                                        kode,
                                                        lineWidth:
                                                            1.2, // width for a single black/white bar (default: 2.0)
                                                        barHeight:
                                                            60.0, // height for the entire widget (default: 100.0)
                                                        withText:
                                                            false, // Render with text label or not (default: false)
                                                      ),
                                                      onError: (error) {
                                                        // Error handler
                                                        print('error = $error');
                                                      },
                                                    ),
                                                 
                                                  ],
                                                )),
                                                 RaisedButton(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            new BorderRadius
                                                                .circular(4.0),
                                                      ),
                                                      child: Text(
                                                        'Gunakan Voucher',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      onPressed: () async {
                                                        _postVoucher(voucher_id);
                                                       await Navigator.pop(context);
                                                      },
                                                      color: Colors.green,
                                                    )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Text(
                            'Gunakan Offline',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

//  ListView.builder(
//               physics: const BouncingScrollPhysics(),
//               shrinkWrap: true,
//               itemCount: _listCart.length == null ? 0 : _listCart.length,
//               itemBuilder: (context, i) {
//                 return Column(
//                   children: [
//                     Text(''),
//                     SizedBox(
//                       height: 20,
//                     )
//                   ],
//                 );
//               }),

// end stack end
