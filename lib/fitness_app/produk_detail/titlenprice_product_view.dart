import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:best_flutter_ui_templates/Constant/Constant.dart';
import 'package:best_flutter_ui_templates/Controllers/harga_controller.dart';
import 'package:best_flutter_ui_templates/model/wishlist_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TitleNPriceProductView extends StatefulWidget {
  const TitleNPriceProductView({Key key, this.detailList, this.funcLoad})
      : super(key: key);
  final Map<String, dynamic> detailList;
  final Function(bool cond) funcLoad;

  @override
  _TitleNPriceProductViewState createState() => _TitleNPriceProductViewState();
}

class _TitleNPriceProductViewState extends State<TitleNPriceProductView> {
  bool wished = false;

  _switchWishedApi(String id) async {
    setState(() {
      widget.funcLoad(true);
    });
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await WishlistModel.switchWish(id).then((value) {
          widget.funcLoad(false);

          Map<String, dynamic> res = json.decode(value.data);

          if (value.error) {
            loadNotice(context, 'Terjadi Kesalahan!');
          }
          //success
          else {
            wished = res['status_wished'];
          }
          setState(() {});
        });
      }
    } on SocketException catch (_) {
      widget.funcLoad(false);
      loadNotice(context, 'Terjadi Kesalahan!');
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // wished = widget.detailList['isWished'] > 0;

    return widget.detailList == null
        ? Container(
            padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
            margin: EdgeInsets.only(bottom: 15),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                //harga
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          alignment: Alignment.topLeft,
                          width: size.width - 100,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 30,
                                  color: Colors.blueGrey.withOpacity(.5),
                                ),
                                Container(
                                  height: 15,
                                  margin: EdgeInsets.only(top: 5),
                                  color: Colors.blueGrey.withOpacity(.5),
                                ),
                              ])),
                      Container(
                        width: 70,
                        height: 30,
                        alignment: Alignment.topRight,
                        color: Colors.blueGrey.withOpacity(.5),
                      ),
                    ],
                  ),
                ),
                //judul
                Container(
                  height: 15,
                  margin: EdgeInsets.only(top: 5),
                  color: Colors.blueGrey.withOpacity(.5),
                ), //bintang
              ],
            ))
        : Container(
            padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
            margin: EdgeInsets.only(bottom: 15),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                //harga
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          alignment: Alignment.topLeft,
                          width: size.width - 100,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  setHarga(widget.detailList),
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Card(
                                      color: Colors.red[100],
                                      child: Container(
                                          padding: EdgeInsets.all(
                                              disconCondition(
                                                          widget.detailList) >
                                                      0
                                                  ? 5
                                                  : 0),
                                          child: Text(
                                            '-' +
                                                disconCondition(
                                                        widget.detailList)
                                                    .toString() +
                                                '%',
                                            style: TextStyle(
                                              color: Colors.red[800],
                                              fontWeight: FontWeight.bold,
                                              fontSize: disconCondition(
                                                          widget.detailList) >
                                                      0
                                                  ? 15
                                                  : 0,
                                            ),
                                          )),
                                    ),
                                    Text(
                                      beforeDisc(widget.detailList),
                                      style: TextStyle(
                                          fontSize: disconCondition(
                                                      widget.detailList) >
                                                  0
                                              ? 20
                                              : 0,
                                          decoration:
                                              TextDecoration.lineThrough),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ])),
                      InkWell(
                          onTap: () {
                            setState(() {
                              _switchWishedApi(
                                  widget.detailList['id'].toString());
                            });
                          },
                          child: Container(
                            width: 70,
                            alignment: Alignment.topRight,
                            child: (wished != widget.detailList['isWished'] > 0
                                    ? wished
                                    : widget.detailList['isWished'] > 0)
                                ? Icon(
                                    Icons.favorite,
                                    color: Colors.pink,
                                    size: 35,
                                  )
                                : Icon(
                                    Icons.favorite_border,
                                    size: 35,
                                  ),
                          )),
                    ],
                  ),
                ),
                //judul
                Container(
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                      Text(
                        widget.detailList['nama'],
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                //bintang
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(top: 15),
                  child: Row(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Card(
                        color: Colors.green[100],
                        child: Container(
                            margin: EdgeInsets.all(5),
                            child: Text(
                              isGrosir(widget.detailList),
                              style: TextStyle(
                                color: Colors.green[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            )),
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.green,
                        size: 25,
                      ),
                      Text(
                        ' ' +
                            decimalPointOne(
                                widget.detailList['avg_ulasan'].toString()),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '  (' +
                            pointGroup(widget.detailList['count_ulasan']) +
                            ' ulasan)',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
                //stok, berat, minim
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(top: 18),
                  child: Row(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                Text("Stok : ", style: TextStyle(fontSize: 13)),
                                new Text(
                                    pointGroup(int.parse(
                                            widget.detailList['stock'])) +
                                        " pcs ",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      new Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            children: <Widget>[
                              Text("Berat : ", style: TextStyle(fontSize: 13)),
                              new Text(
                                  decimalPointTwo(double.parse(
                                              widget.detailList['berat']) /
                                          1000) +
                                      " kg ",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      new Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            children: <Widget>[
                              Text("Minim : ", style: TextStyle(fontSize: 13)),
                              new Text(
                                  pointGroup(isGrosir(widget.detailList) ==
                                              'Grosir'
                                          ? int.parse(
                                              widget.detailList['min_qty'])
                                          : 1) +
                                      " pcs ",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }
}
