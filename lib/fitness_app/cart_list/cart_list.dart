import 'package:best_flutter_ui_templates/model/register_model.dart';
import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/model/user_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:best_flutter_ui_templates/Constant/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
import 'package:intl/intl.dart';

class CartList extends StatefulWidget {
  const CartList({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;
  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<dynamic> _listCart;

  List _selecteCarts = List();

  bool isLoading = true, isConnect = true, isCheckAll = false;

  int _total = 0;

  String _token;

  final formatter = new NumberFormat("#,###");

  Future _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(_token);
    setState(() {
      _token = prefs.getString('token');
    });
    log(_token);
  }

  _getData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var response = await http.get(globalBaseUrl + 'api/cart',
            headers: {"Authorization": "Bearer " + _token});
        var _response = json.decode(response.body);

        _listCart = _response['data']['produk'];
        setState(() {
          isLoading = false;
        });

        //Foreach total to get subtotal
        // _listCart.forEach((element) {
        //   // log(element['id'].toString());
        //   _total = _total + int.parse(element['total']);
        // });
      }
    } on SocketException catch (_) {
      isConnect = false;
      isLoading = false;
      setState(() {});
    }
  }

  /**
   * Set Check box active or not by cart_id
   * 
   */
  void _onCartSelected(bool selected, cart_id, total) {
    if (selected == true) {
      setState(() {
        _selecteCarts.add(cart_id);
        _total = _total + int.parse(total);
      });
    } else {
      setState(() {
        _selecteCarts.remove(cart_id);
        _total = _total - int.parse(total);
      });
    }
    log(_selecteCarts.toString());
  }

/**
 * Select All Cart
 * 
 */
  void _checkAllCart() {
    isCheckAll = !isCheckAll;
    if (isCheckAll == true) {
      _listCart.forEach((element) {
        if (_selecteCarts.contains(element['id'])) {
          //Check if id contais in list
        } else {
          //if doesnt exist
          _onCartSelected(isCheckAll, element['id'], element['total']);
          // _total = _total + int.parse(element['total']);
        }
      });
    } else {
      _listCart.forEach((element) {
        if (_selecteCarts.contains(element['id'])) {
          //Check if id contais in list
          _onCartSelected(isCheckAll, element['id'], element['total']);
          // _total = _total - int.parse(element['total']);
        } else {
          //if doesnt exist
        }
      });
    }
  }

  /**
   * Confirm delete Item Cart
   * 
   */
  confirmHapus(context, id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text("Apakah anda yakin ingin menghapus data ini ?"),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Ya",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                showSnackBar("Lanjut mas Semongko", Colors.green,
                    Icon(Icons.check_circle_outline));
              },
            ),
            FlatButton(
              child: Text("Tidak"),
              onPressed: () {
                //Put your code here which you want to execute on No button click.
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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

  _checkCart() {
    if (_selecteCarts.length < 1) {
      showSnackBar("Item Keranjang belum dipilih", Colors.red,
          FaIcon(FontAwesomeIcons.timesCircle));
    } else {
      showSnackBar("Lanjut mas Semongko", Colors.green,
          FaIcon(FontAwesomeIcons.checkCircle));
      Navigator.pushNamed(context, '/checkout');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getToken();
    Future.delayed(Duration(seconds: 1), () {
      _getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    //final wh_ = MediaQuery.of(context).size;

    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        brightness: Brightness.light,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Keranjang',
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
      bottomNavigationBar: footer(context),
      body: isLoading
          ? reqLoad()
          : Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _listCart.length == null ? 0 : _listCart.length,
                  itemBuilder: (context, i) {
                    return Column(
                      children: [
                        cardKerangjang(context, i),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    );
                  })),
    );
  }

  Widget cardKerangjang(context, i) {
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
                    value: _selecteCarts.contains(_listCart[i]['id']),
                    onChanged: (bool selected) {
                      _onCartSelected(
                          selected, _listCart[i]['id'], _listCart[i]['total']);
                    },
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                    tristate: false,
                  ),
                ),
                Container(
                  height: sizeu.width / 4 / 1.5,
                  width: sizeu.width / 4 / 1.5,
                  decoration: BoxDecoration(
                    image: new DecorationImage(
                                      image: NetworkImage(globalBaseUrl +locationProductImage + _listCart[i]['get_produk']['gambar'] ??
                                          'https://via.placeholder.com/300'),
                                      fit: BoxFit.cover),
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
                          '${_listCart[i]['get_produk']['nama']}',
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
                          'Rp ${formatter.format(int.parse(_listCart[i]['total']))}',
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
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
                      onPressed: () {
                        confirmHapus(context, _listCart[i]['qty']);
                      },
                      color: Colors.black54,
                    ),
                  ),
                  // Container(
                  //   width: 20,
                  //   height: 30,
                  //   margin: EdgeInsets.only(right: 15),
                  //   alignment: Alignment.topLeft,
                  //   // color: Colors.yellow,
                  //   child: IconButton(
                  //     icon: Icon(Icons.favorite),
                  //     onPressed: () {},
                  //     color: Colors.black54,
                  //   ),
                  // ),
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
                            controller: TextEditingController()
                              ..text = '${_listCart[i]['qty']}',
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

  Widget footer(context) {
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
              width: size.width / 2 - 40,
              child: new Row(
                children: <Widget>[
                  Checkbox(
                    value: isCheckAll,
                    onChanged: (value) {
                      _checkAllCart();
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
              height: 70,
              padding: EdgeInsets.only(top: 15, bottom: 5),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Subtotal',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'Rp ${formatter.format(_total)}',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
            ),
            InkWell(
              onTap: () {
                // Navigate to the second screen using a named route.
                // Navigator.pushNamed(context, '/checkout');
                _checkCart();
              },
              child: Container(
                height: 50,
                color: Colors.green[300],
                alignment: Alignment.center,
                width: 90,
                child: Text(
                  'CHECKOUT',
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

class FooterApp extends StatelessWidget {
  final int total;

  FooterApp({
    Key key,
    /*@required*/
    this.total,
  }) : super(key: key);

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
              width: size.width / 2 - 40,
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
              height: 70,
              padding: EdgeInsets.only(top: 15, bottom: 5),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Subtotal',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'Rp ${total}',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
            ),
            InkWell(
              onTap: () {
                // Navigate to the second screen using a named route.
                Navigator.pushNamed(context, '/checkout');
              },
              child: Container(
                height: 50,
                color: Colors.green[300],
                alignment: Alignment.center,
                width: 90,
                child: Text(
                  'CHECKOUT',
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

// end stack end
