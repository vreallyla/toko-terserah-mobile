import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:best_flutter_ui_templates/fitness_app/fintness_app_theme.dart';

class CartList extends StatefulWidget {
  const CartList({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;
  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  @override
  Widget build(BuildContext context) {
    //final wh_ = MediaQuery.of(context).size;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[200],
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Keranjang',
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {},
              color: Colors.black,
            )
          ],
        ),
        bottomNavigationBar: footerApp(),
        body: Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: ListView(
            children: <Widget>[
              cardCart(),
            ],
          ),
        ),
      ),
    );
  }
}

class footerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    bool checkAll = false;

    void toggleCheckbox(bool value) {}

    return PreferredSize(
      preferredSize: Size.fromHeight(80.0),
      child: BottomAppBar(
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: size.width / 2 - 30,
              child: new Row(
                children: <Widget>[
                  Checkbox(
                    value: checkAll,
                    onChanged: (value) {
                      toggleCheckbox(value);
                    },
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                    tristate: false,
                  ),
                  Text(
                    'Pilih Semua',
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
            Container(
              width: size.width / 2 - 60,
              height: 50,
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Subtotal',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'Rp15.000.000,-',
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

class cardCart extends StatelessWidget {
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
                Container(
                  width: 30,
                  height: sizeu.width / 4 / 1.5,
                  alignment: Alignment.topLeft,
                  // color: Colors.red,
                  child: Checkbox(
                    value: false,
                    onChanged: (value) {},
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                    tristate: false,
                  ),
                ),
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
                          'Rp 40.000,-',
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          Card(
                            color: Colors.red[100],
                            child: Container(
                                margin: EdgeInsets.all(2),
                                child: Text(
                                  '-10%',
                                  style: TextStyle(
                                    color: Colors.red[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                )),
                          ),
                          Text(
                            'Rp50.000,00',
                            style: TextStyle(
                                fontSize: 15,
                                decoration: TextDecoration.lineThrough),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
          Container(
              height: (sizeu.width / 2 - sizeu.width / 15) -
                  30 -
                  (sizeu.width / 3 - sizeu.width / 17),
              margin: EdgeInsets.only(left: sizeu.width / 4 / 1.5 + 30),
              // color: Colors.yellow,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 20,
                    height: 30,
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(right: 15),
                    // color: Colors.red,
                    child: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {},
                      color: Colors.black54,
                    ),
                  ),
                  Container(
                    width: 20,
                    height: 30,
                    margin: EdgeInsets.only(right: 15),
                    alignment: Alignment.topLeft,
                    // color: Colors.yellow,
                    child: IconButton(
                      icon: Icon(Icons.favorite),
                      onPressed: () {},
                      color: Colors.black54,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Row(
                      children: <Widget>[
                        ButtonTheme(
                          padding: EdgeInsets.only(top: 0),
                          minWidth: 10.0,
                          height: 20.0,
                          child: FlatButton(
                            color: Colors.black26,
                            onPressed: () {},
                            child: Icon(Icons.remove),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: TextEditingController()..text = '1',
                            onChanged: (text) => {},
                          ),
                        ),
                        ButtonTheme(
                          padding: EdgeInsets.only(top: 0),
                          minWidth: 10.0,
                          height: 20.0,
                          child: FlatButton(
                            color: Colors.black26,
                            onPressed: () {},
                            child: Icon(Icons.add),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
}

// end stack end
