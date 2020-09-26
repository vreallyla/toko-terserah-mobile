import 'package:flutter/material.dart';

class CheckOut extends StatefulWidget {
  const CheckOut({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;
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
  List<NewItem> items = <NewItem>[
    new NewItem(
        false, 'Alamat Pengiriman', SizedBox(), new Icon(Icons.expand_more)),
    new NewItem(
        false, 'Opsi Pengiriman', SizedBox(), new Icon(Icons.expand_more)),
    //give all your items here
  ];

  ExpansionPanelList listcheckout;
  @override
  Widget build(BuildContext context) {
    items = <NewItem>[
      new NewItem(items[0].isExpanded, 'Alamat Pengiriman', DetailAlamat(),
          new Icon(Icons.expand_more)),
      new NewItem(items[1].isExpanded, 'Opsi Pengiriman', DetailPengiriman(),
          new Icon(Icons.expand_more)),
      //give all your items here
    ];
    //final wh_ = MediaQuery.of(context).size;
    listcheckout = ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          items[index].isExpanded = !isExpanded;
          print(items[index].isExpanded);
        });
      },
      children: items.map((NewItem item) {
        return new ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            print(item.isExpanded);
            return new ListTile(
                title: new Text(
              item.header,
              textAlign: TextAlign.left,
              style: new TextStyle(
                fontSize: 18.0,
                color: Colors.green,
                fontWeight: FontWeight.w200,
              ),
            ));
          },
          isExpanded: item.isExpanded,
          body: item.body,
        );
      }).toList(),
    );

    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        brightness: Brightness.light,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Check Out',
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
      bottomNavigationBar: FooterApp(),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: ListView(
          children: <Widget>[
            Container(
                child: Column(
              children: [CardCart(), listcheckout, ApplyVoucher()],
            )),
          ],
        ),
      ),
    );
  }
}

class FooterApp extends StatelessWidget {
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
              width: size.width - 120,
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
                      'Rp 4.000.000',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
            ),
            InkWell(
              child: Container(
                height: 50,
                color: Colors.green[300],
                alignment: Alignment.center,
                width: 90,
                child: Text(
                  'Bayar',
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
      height: 160,
      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          //background color of box
          BoxShadow(
            color: Colors.black12,
            blurRadius: 0.5, // soften the shadow
            spreadRadius: .5, //extend the shadow
            offset: Offset(
              .5, // Move to right 10  horizontally
              .5, // Move to bottom 10 Vertically
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(bottom: 10),
              child: Text('Punya kode voucher? masukan di sini',
                  style: TextStyle(color: Colors.black54))),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: sizeu.width - 80 - 40 - 5,
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
                      'Pakai',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(1, 20, 1, 1),
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
          // Padding(
          //   padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
          //   child: Row(
          //     children: [
          //       Text(
          //         'Kota :',
          //         style: TextStyle(
          //           fontSize: 15,
          //         ),
          //         textAlign: TextAlign.start,
          //         maxLines: 7,
          //       ),
          //       Text(
          //         'Surabaya',
          //         style: TextStyle(
          //           fontSize: 15,
          //         ),
          //         textAlign: TextAlign.justify,
          //         maxLines: 7,
          //       ),
          //     ],
          //   ),
          // ),
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

class CardCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;

    return Container(
      height: sizeu.width / 2 - sizeu.width / 15,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(8.0),
          bottomLeft: Radius.circular(8.0),
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
        boxShadow: [
          //background color of box
          BoxShadow(
            color: Colors.black12,
            blurRadius: 0.5, // soften the shadow
            spreadRadius: .5, //extend the shadow
            offset: Offset(
              .5, // Move to right 10  horizontally
              .5, // Move to bottom 10 Vertically
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Container(
                //   width: 30,
                //   height: sizeu.width / 4 / 1.5,
                //   alignment: Alignment.topLeft,
                //   // color: Colors.red,
                //   child: Checkbox(
                //     value: false,
                //     onChanged: (value) {},
                //     activeColor: Colors.green,
                //     checkColor: Colors.white,
                //     tristate: false,
                //   ),
                // ),
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
                Container(
                  height: sizeu.width / 3 - sizeu.width / 17,
                  width: sizeu.width - sizeu.width / 4 / 1.5 - 20 - 30 - 30,
                  // color: Colors.red,
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        width: sizeu.width - 50 - sizeu.width / 4 - 10,
                        child: Text(
                          'Ini Nama Barangnya tinggal diisi disini gak apa-apa kok :)',
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Card(
                        color: Colors.green[100],
                        child: Container(
                            margin: EdgeInsets.all(2),
                            child: Text(
                              'Grosir',
                              style: TextStyle(
                                color: Colors.green[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            )),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        width: sizeu.width - 50 - sizeu.width / 4 - 10,
                        child: Text(
                          'Rp 40.000',
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Row(
                      //   children: [
                      //     Card(
                      //       color: Colors.red[100],
                      //       child: Container(
                      //           margin: EdgeInsets.all(2),
                      //           child: Text(
                      //             '-10%',
                      //             style: TextStyle(
                      //               color: Colors.red[800],
                      //               fontWeight: FontWeight.bold,
                      //               fontSize: 12,
                      //             ),
                      //           )),
                      //     ),
                      //     Text(
                      //       'Rp50.000,00',
                      //       style: TextStyle(
                      //           fontSize: 15,
                      //           decoration: TextDecoration.lineThrough),
                      //       textAlign: TextAlign.left,
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ]),
          // Container(
          //     height: (sizeu.width / 2 - sizeu.width / 15) -
          //         30 -
          //         (sizeu.width / 3 - sizeu.width / 17),
          //     margin: EdgeInsets.only(left: sizeu.width / 4 / 1.5 + 30),
          //     // color: Colors.yellow,
          //     child: Row(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: <Widget>[
          //         Container(
          //           width: 20,
          //           height: 30,
          //           alignment: Alignment.topLeft,
          //           margin: EdgeInsets.only(right: 15),
          //           // color: Colors.red,
          //           child: IconButton(
          //             icon: Icon(Icons.delete),
          //             onPressed: () {},
          //             color: Colors.black54,
          //           ),
          //         ),
          //         Container(
          //           width: 20,
          //           height: 30,
          //           margin: EdgeInsets.only(right: 15),
          //           alignment: Alignment.topLeft,
          //           // color: Colors.yellow,
          //           child: IconButton(
          //             icon: Icon(Icons.favorite),
          //             onPressed: () {},
          //             color: Colors.black54,
          //           ),
          //         ),
          //         Container(
          //           padding: EdgeInsets.only(top: 5),
          //           child: Row(
          //             children: <Widget>[
          //               ButtonTheme(
          //                 padding: EdgeInsets.only(top: 0),
          //                 minWidth: 10.0,
          //                 height: 20.0,
          //                 child: FlatButton(
          //                   color: Colors.black26,
          //                   onPressed: () {},
          //                   child: Icon(Icons.remove),
          //                 ),
          //               ),
          //               SizedBox(
          //                 width: 30,
          //                 child: TextField(
          //                   textAlign: TextAlign.center,
          //                   controller: TextEditingController()..text = '1',
          //                   onChanged: (text) => {},
          //                 ),
          //               ),
          //               ButtonTheme(
          //                 padding: EdgeInsets.only(top: 0),
          //                 minWidth: 10.0,
          //                 height: 20.0,
          //                 child: FlatButton(
          //                   color: Colors.black26,
          //                   onPressed: () {},
          //                   child: Icon(Icons.add),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         )
          //       ],
          //     )),
        ],
      ),
    );
  }
}

// end stack end
