import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:expandable/expandable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:best_flutter_ui_templates/Constant/Constant.dart';

class TransaksiDetailScreen extends StatefulWidget {
  const TransaksiDetailScreen({Key key, this.dashboardId, this.status})
      : super(key: key);

  final String dashboardId;
  final String status;
  @override
  _TransaksiDetailScreenState createState() => _TransaksiDetailScreenState();
}

class _TransaksiDetailScreenState extends State<TransaksiDetailScreen> {
  String _token;

  bool isLoading = true, isConnect = true;

  var _data;

  Future _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(_token);
    setState(() {
      _token = prefs.getString('token');
    });
  }

  _getData() async {
    try {
      if (_token != null) {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          var response = await http.get(
              globalBaseUrl + 'api/dashboard/detail/' + widget.dashboardId,
              headers: {"Authorization": "Bearer " + _token});
          var _response = json.decode(response.body);
          _data = _response;
          print(_response);
        }
        setState(() {
          isLoading = false;
        });
      }
    } on SocketException catch (_) {
      isConnect = false;
      isLoading = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    print(widget.dashboardId);
    _getToken();
    Future.delayed(Duration(milliseconds: 50), () {
      _getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final wh_ = MediaQuery.of(context).size;
    return new Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.grey[200],
        title: const Text(
          'Rincian Pesanan',
          style: TextStyle(color: Colors.black),
        ),
      ),
      bottomNavigationBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: BottomAppBar(
            child: Container(
                padding: EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                child: RaisedButton(
                  onPressed: () {},
                  child: Text(
                    'Nilai',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.green,
                ))),
      ),
      body: isLoading
          ? reqLoad()
          : Container(
              color: Colors.grey[300],
              child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: <Widget>[
                    StatusTransaksi(
                      data: _data,
                      status: widget.status,
                    ),
                    HeadDaftarTransaksi(
                        dataItem: _data['data']['carts'], data: _data),
                    AlamatTransaksi(
                      data: _data['data']['alamat_pengiriman'],
                    ),
                    _data['data']['isLunas'] == 1
                        ? (_data['data']['recent_track'] == null
                            ? Dikemas(
                                status: _data['data']['status'],
                                isAmbil: _data['data']['isAmbil'],
                              )
                            : TrackerTransaksi(
                                dataTracking: _data['data']['full_track'],
                                kurir: _data['data']['kode_kurir'],
                                layanan: _data['data']['layanan_kurir'],
                              ))
                        : Container(),

                    // TransaksiVia(),
                  ]),
            ),
    );
  }
}
// end stack end

class StatusTransaksi extends StatelessWidget {
  final Map<String, dynamic> data;
  final String status;

  const StatusTransaksi({this.data, this.status});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
      color: Colors.green[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.only(bottom: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 30,
                    child: FaIcon(
                      FontAwesomeIcons.infoCircle,
                      color: Colors.black54,
                      size: 18,
                    ),
                  ),
                  Container(
                      width: size.width / 3,
                      child: Text('Status',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ))),
                  Container(
                    width: size.width / 2,
                    alignment: Alignment.centerRight,
                    child: Text('${status}',
                        style: TextStyle(
                          color: Colors.black54,
                        )),
                  )
                ],
              )),
          Container(
            padding: EdgeInsets.only(left: 30),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      width: size.width - 30 - 110 - 30,
                      child: Text('${data['data']['uni_code']}')),
                ]),
          ),
          Container(
            padding: EdgeInsets.only(left: 30, top: 5),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 110,
                    child: Text('Tgl. Diterima'),
                  ),
                  Container(
                      width: size.width - 30 - 110 - 30,
                      child: Text(': ${data['data']['tgl_diterima'] ?? '-'}',
                          maxLines: 2)),
                ]),
          ),
        ],
      ),
    );
  }
}

class AlamatTransaksi extends StatelessWidget {
  final Map<String, dynamic> data;

  const AlamatTransaksi({this.data});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
      margin: EdgeInsets.only(bottom: 15),
      color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 30,
              child: FaIcon(
                FontAwesomeIcons.locationArrow,
                color: Colors.green,
                size: 18,
              ),
            ),
            Container(
                width: size.width - 30 - 100 - 30,
                child: Text('Alamat',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ))),
            Container(
              width: 100,
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {},
                child: Text('Salin',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
                    width: size.width - 30 - 30,
                    child: Text(
                      '${data['nama']}',
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
                    width: size.width - 30 - 30,
                    child: Text(
                      '${data['telp']}',
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
                    width: size.width - 30 - 30,
                    child: Text(
                      '${data['alamat']}',
                      maxLines: 4,
                    )),
              ]),
        ),
      ]),
    );
  }
}

class TrackerTransaksi extends StatelessWidget {
  final List dataTracking;
  final String kurir;
  final String layanan;
  const TrackerTransaksi({this.dataTracking, this.kurir, this.layanan});

  @override
  Widget build(BuildContext context) {
    final dateFormat = new DateFormat.yMMMMd('id_ID');
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 0.5, color: Colors.black26),
        ),
        color: Colors.white,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 30,
              child: FaIcon(
                FontAwesomeIcons.shippingFast,
                color: Colors.green,
                size: 18,
              ),
            ),
            Container(
                width: size.width - 30 - 100 - 30,
                child: Text('Status Pengiriman',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ))),
            Container(
              width: 100,
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {},
                child: Text('',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
              ),
            )
          ],
        )),
        Column(
          children: <Widget>[
            ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount:
                    dataTracking.length == null ? 0 : dataTracking.length,
                itemBuilder: (context, i) {
                  if (i == 0) {
                    return Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: 15,
                          ),
                          padding: EdgeInsets.only(left: 15, bottom: 15),
                          decoration: BoxDecoration(
                            border: Border(
                              left:
                                  BorderSide(width: 0.5, color: Colors.black54),
                            ),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              //lokasi tracker
                              Container(
                                width: size.width - 30 - 30,
                                child: Text(
                                  '${dataTracking[i]['manifest_description']}',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                  maxLines: 2,
                                ),
                              ),
                              Container(
                                width: size.width - 30 - 30,
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                    '${kurir.toUpperCase()} ( ${layanan.toUpperCase()} )'),
                              ),
                              Container(
                                width: size.width - 30 - 30,
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                    '${dateFormat.format(DateTime.parse(dataTracking[i]['manifest_date']))} | ${dataTracking[i]['manifest_time']}',
                                    style: TextStyle(color: Colors.green)),
                              )
                            ],
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 10, left: 10.5),
                            decoration: BoxDecoration(
                              color: Colors.green[300],
                            ),
                            height: 10,
                            width: 10),
                      ],
                    );
                  } else {
                    return Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: 15,
                          ),
                          padding: EdgeInsets.only(left: 15, bottom: 15),
                          decoration: BoxDecoration(
                            border: Border(
                              left:
                                  BorderSide(width: 0.5, color: Colors.black54),
                            ),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              //lokasi tracker
                              Container(
                                width: size.width - 30 - 30,
                                child: Text(
                                  '${dataTracking[i]['manifest_description']}',
                                  style: TextStyle(
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                  maxLines: 2,
                                ),
                              ),
                              Container(
                                width: size.width - 30 - 30,
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  '${kurir.toUpperCase()} ( ${layanan.toUpperCase()} )',
                                  style: TextStyle(color: Colors.grey[500]),
                                ),
                              ),
                              Container(
                                width: size.width - 30 - 30,
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                    '${dateFormat.format(DateTime.parse(dataTracking[i]['manifest_date']))} | ${dataTracking[i]['manifest_time']}',
                                    style: TextStyle(color: Colors.grey[500])),
                              )
                            ],
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 10, left: 10.5),
                            decoration: BoxDecoration(
                              color: Colors.grey[500],
                            ),
                            height: 10,
                            width: 10),
                      ],
                    );
                  }
                }),
          ],
        )
      ]),
    );
  }
}

class HeadDaftarTransaksi extends StatelessWidget {
  final Map<String, dynamic> data;
  final List dataItem;
  const HeadDaftarTransaksi({this.dataItem, this.data});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final formatter = new NumberFormat("#,###.00", 'id_ID');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // daftar pesanan
        Container(
          color: Colors.white,
          padding: EdgeInsets.all(15),
          child: ExpandablePanel(
            theme: ExpandableThemeData(
              iconColor: Colors.grey,
              // iconSize: 25,
              // iconPadding: EdgeInsets.only(bottom: 3),
              fadeCurve: Curves.linear,
              sizeCurve: Curves.fastOutSlowIn,
              hasIcon: false,
            ),
            header: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 30,
                  child: FaIcon(
                    FontAwesomeIcons.boxes,
                    color: Colors.green,
                    size: 18,
                  ),
                ),
                Container(
                    width: size.width - 30 - 30 - 100,
                    child: Text('Daftar Pesanan (${dataItem.length} item)',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ))),
                Container(
                  width: 100,
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Lihat',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            expanded: Container(
              padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // daftar pesanan
                  ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: dataItem.length == null ? 0 : dataItem.length,
                      itemBuilder: (context, i) {
                        return Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 70,
                                height: 70,
                                margin: EdgeInsets.only(right: 10),
                                color: Colors.grey,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(top: 7),
                                    width: size.width - 60 - 80,
                                    child: Text(
                                      '${dataItem[i]['produk']['nama']}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 7),
                                    width: size.width - 60 - 80,
                                    child: Text(
                                      'X ${dataItem[i]['qty']}',
                                      maxLines: 2,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 7),
                                    alignment: Alignment.topRight,
                                    width: size.width - 60 - 80,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // Text(
                                        //   '(Rp500.000,-)',
                                        //   style: TextStyle(
                                        //     fontSize: 12,
                                        //     fontWeight: FontWeight.w500,
                                        //     color: Colors.black54,
                                        //     decoration:
                                        //         TextDecoration.lineThrough,
                                        //   ),
                                        // ),
                                        Text(
                                          '  Rp ${formatter.format(int.parse(dataItem[i]['total']))}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      })
                ],
              ),
            ),
          ),
        ),
        //summary cost
        Container(
          decoration: borderTop(),
          margin: EdgeInsets.only(bottom: 15),
          padding: EdgeInsets.only(left: 45, top: 15, bottom: 8, right: 15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //subtotal
                Container(
                  padding: EdgeInsets.only(top: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          alignment: Alignment.topLeft,
                          width: 160,
                          child: Text('Subtotal',
                              style: TextStyle(
                                color: Colors.black54,
                              ))),
                      Container(
                          alignment: Alignment.topRight,
                          width: (size.width - 30 - 30) - 160,
                          child: Text(
                              'Rp${formatter.format(data['data']['subtotal'])}',
                              style: TextStyle(
                                color: Colors.black54,
                              ))),
                    ],
                  ),
                ),
                // pengiriman
                Container(
                  padding: EdgeInsets.only(top: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          alignment: Alignment.topLeft,
                          width: 160,
                          child: Text('Pengiriman',
                              style: TextStyle(
                                color: Colors.black54,
                              ))),
                      Container(
                          alignment: Alignment.topRight,
                          width: (size.width - 30 - 30) - 160,
                          child: Text(
                              'Rp${formatter.format(int.parse(data['data']['ongkir']))}',
                              style: TextStyle(
                                color: Colors.black54,
                              ))),
                    ],
                  ),
                ),
                // potongan voucher
                Container(
                  padding: EdgeInsets.only(top: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          alignment: Alignment.topLeft,
                          width: 160,
                          child: Text('Potongan Voucher',
                              style: TextStyle(
                                color: Colors.black54,
                              ))),
                      Container(
                          alignment: Alignment.topRight,
                          width: (size.width - 30 - 30) - 160,
                          child: Text('Rp0,-',
                              style: TextStyle(
                                color: Colors.black54,
                              ))),
                    ],
                  ),
                ),

                //total pesanan
                Container(
                  padding: EdgeInsets.only(top: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          alignment: Alignment.topLeft,
                          width: 160,
                          child: Text('Total Pesanan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ))),
                      Container(
                          alignment: Alignment.topRight,
                          width: (size.width - 30 - 30) - 160,
                          child: Text(
                              'Rp${formatter.format(int.parse(data['data']['ongkir']) + data['data']['subtotal'])}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                              ))),
                    ],
                  ),
                ),
              ]),
        ),
      ],
    );
  }
}

class Dikemas extends StatelessWidget {
  final String status;
  final int isAmbil;
  const Dikemas({this.status, this.isAmbil});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return isAmbil == 1
        ? Container(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
            margin: EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 0.5, color: Colors.black26),
              ),
              color: Colors.white,
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 30,
                    child: FaIcon(
                      FontAwesomeIcons.shippingFast,
                      color: Colors.green,
                      size: 18,
                    ),
                  ),
                  Container(
                      width: size.width - 30 - 100 - 30,
                      child: Text('Status Pengiriman',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ))),
                  Container(
                    width: 100,
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {},
                      child: Text('',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                    ),
                  )
                ],
              )),
              Column(
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          left: 15,
                        ),
                        padding: EdgeInsets.only(left: 15, bottom: 15),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(width: 0.5, color: Colors.black54),
                          ),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            //lokasi tracker
                            Container(
                              width: size.width - 30 - 30,
                              child: Text(
                                '${status}',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                                maxLines: 2,
                              ),
                            ),
                            Container(
                              width: size.width - 30 - 30,
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                isAmbil == 1 ? 'Ambil di Toko Terserah' : '',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                            Container(
                              width: size.width - 30 - 30,
                              padding: EdgeInsets.only(top: 5),
                              child: Text(isAmbil == 1 ? 'Hari ini' : '',
                                  style: TextStyle(color: Colors.green)),
                            )
                          ],
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 10, left: 10.5),
                          decoration: BoxDecoration(
                            color: Colors.green,
                          ),
                          height: 10,
                          width: 10),
                    ],
                  )
                ],
              )
            ]),
          )
        : Container();
  }
}

class TransaksiVia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        // border: Border(
        //   top: BorderSide(width: 0.5, color: Colors.black26),
        // ),
        color: Colors.white,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 30,
              child: FaIcon(
                FontAwesomeIcons.commentsDollar,
                color: Colors.green,
                size: 18,
              ),
            ),
            Container(
                width: size.width - 30 - 100 - 30,
                child: Text('Metode Pembayaran',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ))),
            // Container(
            //   width: 100,
            //   alignment: Alignment.centerRight,
            //   child: InkWell(
            //     onTap: () {},
            //     child: Text('Lacak',
            //         style: TextStyle(
            //           color: Colors.green,
            //           fontWeight: FontWeight.bold,
            //           fontSize: 16,
            //         )),
            //   ),
            // )
          ],
        )),
        Container(
          margin: EdgeInsets.only(left: 15, top: 10),
          padding: EdgeInsets.only(left: 15, bottom: 15),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //lokasi tracker
              Container(
                width: size.width - 30 - 30,
                child: Text(
                  'Bank BCA (Transfer Otomatis)',
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ]),
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
