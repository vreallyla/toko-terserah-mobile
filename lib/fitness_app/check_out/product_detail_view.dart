import 'dart:developer';

import 'package:tokoterserah/Constant/Constant.dart';
import 'package:tokoterserah/Controllers/harga_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CheckOutProductDetailView extends StatefulWidget {
  final Map<String, dynamic> product;
  final Map<String, dynamic> packing;

  CheckOutProductDetailView({
    Key key,
    /*@required*/
    this.product,
    this.packing,
  }) : super(key: key);

  @override
  _CheckOutProductDetailViewState createState() =>
      _CheckOutProductDetailViewState();
}

class _CheckOutProductDetailViewState extends State<CheckOutProductDetailView> {
  bool show = false;
  List<Widget> dataList = <Widget>[];

  void addAllData() {
    dataList = [];
    
    if(widget.packing['use']){
      dataList.add(CheckOutCard(product: widget.product['produk'][0],hargaPacking: widget.packing['nominal'],descPacking: widget.packing['desc'],));
    }

    if (widget.product.containsKey('count_produk') &&
        show &&
        widget.product['count_produk'] > 1) {
      widget.product['produk']
          .forEach((element) => dataList.add(CheckOutCard(product: element)));

      dataList.add(eventCollapse());
    } else {
      dataList.add(CheckOutCard(
          product: widget.product.containsKey('count_produk')
              ? widget.product['produk'][0]
              : {}));
      if (widget.product.containsKey('count_produk') &&
          widget.product['count_produk'] > 1) {
        dataList.add(eventCollapse());
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    addAllData();

    return Container(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: const BorderRadius.only(
        //   bottomRight: Radius.circular(8.0),
        //   bottomLeft: Radius.circular(8.0),
        //   topLeft: Radius.circular(8.0),
        //   topRight: Radius.circular(8.0),
        // ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: dataList,
      ),
    );
  }

  Widget eventCollapse() {
    int count = widget.product.containsKey('count_produk')
        ? widget.product['count_produk']
        : 0;
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: count > 1 ? .5 : 0, color: Colors.grey[400]),
        ),
      ),
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: InkWell(
        onTap: () {
          show = !show;
          addAllData();
          setState(() {});
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count > 1
                  ? (show
                      ? 'Sembunyikan Produk'
                      : 'Tampilkan +' +
                          (widget.product.containsKey('count_produk')
                              ? (widget.product['count_produk'] - 1).toString()
                              : 0) +
                          ' Produk Lagi')
                  : '',
              style: TextStyle(
                  fontSize: count > 1 ? 14 : 0,
                  color: Colors.green,
                  fontWeight: FontWeight.w500),
            ),
            Icon(
              show ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: Colors.grey[600],
              size: count > 1 ? 22 : 0,
            )
          ],
        ),
      ),
    );
  }
}

class CheckOutCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final double hargaPacking;
  final String descPacking;

  CheckOutCard({
    Key key,
    /*@required*/
    this.product,
    this.descPacking,
    this.hargaPacking:0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    bool kond = product.containsKey('id');

    return kond
        ? Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        height: sizeu.width / 4 / 1.5,
                        width: sizeu.width / 4 / 1.5,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                          image: DecorationImage(
                            image:hargaPacking>0?AssetImage('assets/fitness_app/boxes.png'): NetworkImage(globalBaseUrl +
                                locationProductImage +
                                product['get_produk']['gambar']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Card(
                        color: hargaPacking>0?Colors.grey:Colors.green[100],
                        child: Container(
                            margin: EdgeInsets.all(2),
                            child: kond
                                ? Text(
                                    hargaPacking>0?'Biaya':isGrosir(product['get_produk']),
                                    style: TextStyle(
                                      color: hargaPacking>0?Colors.white:Colors.green[800],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 9,
                                    ),
                                  )
                                : Container(
                                    height: 9,
                                    width: 9,
                                    color: Colors.grey,
                                  )),
                      ),
                    ],
                  ),
                  Container(
                    // height: sizeu.width / 3 - sizeu.width / 17,
                    width: sizeu.width - sizeu.width / 4 / 1.5 - 20 - 30 - 30,
                    // color: Colors.red,
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(bottom: 3),
                          width: sizeu.width - 50 - sizeu.width / 4 - 10,
                          child: Text(
                            hargaPacking>0?'Biaya Packing':product['get_produk']['nama'],
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Text(
                          hargaPacking>0?descPacking:(pointGroup(int.parse(product['qty'])) +
                              ' Pcs (' +
                              decimalPointTwo(
                                  double.parse(product['berat']) / 1000) +
                              ' Kg)'),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 2),
                          width: sizeu.width - 50 - sizeu.width / 4 - 10,
                          child: Row(
                            children: [
                              // Text(
                              //   disconCondition(product['get_produk']) > 0
                              //       ? beforeDisc(product['get_produk'])
                              //       : '',
                              //   maxLines: 2,
                              //   style: TextStyle(
                              //       decoration: TextDecoration.lineThrough,
                              //       color: Colors.grey[700],
                              //       fontSize:
                              //           disconCondition(product['get_produk']) >
                              //                   0
                              //               ? 15
                              //               : 0),
                              // ),

                              Text(
                                hargaPacking>0?NumberFormat.currency(locale: "id_ID", symbol: "Rp").format(hargaPacking):
                                setHargaWithQty(product['get_produk'],
                                    double.parse(product['qty'])),
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
          )
        : Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        height: sizeu.width / 4 / 1.5,
                        width: sizeu.width / 4 / 1.5,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                        ),
                      ),
                      Card(
                        color: Colors.green[100],
                        child: Container(
                            margin: EdgeInsets.all(2),
                            child: kond
                                ? Text(
                                    isGrosir(product['get_produk']),
                                    style: TextStyle(
                                      color: Colors.green[800],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 9,
                                    ),
                                  )
                                : Container(
                                    height: 9,
                                    width: 9,
                                    color: Colors.grey,
                                  )),
                      ),
                    ],
                  ),
                  Container(
                    // height: sizeu.width / 3 - sizeu.width / 17,
                    width: sizeu.width - sizeu.width / 4 / 1.5 - 20 - 30 - 30,

                    // color: Colors.red,
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topLeft,
                          color: Colors.grey,
                          padding: EdgeInsets.only(bottom: 3),
                          width: sizeu.width - 50 - sizeu.width / 4 - 10,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 2),
                          color: Colors.grey,
                          height: 9,
                          width: sizeu.width - 50 - sizeu.width / 4 - 10,
                        ),
                      ],
                    ),
                  ),
                ]),
          );
  }
}
