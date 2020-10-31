import 'package:best_flutter_ui_templates/fitness_app/produk_detail/CustomShowDialog.dart';
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
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:best_flutter_ui_templates/fitness_app/check_out/checkout.dart';
import 'package:best_flutter_ui_templates/model/wishlist_model.dart';
import 'package:best_flutter_ui_templates/design_course/test.dart';

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

  int jmlhCart = 0;

  // lock back when load data
  bool canBack = false;

  final formatter = new NumberFormat("#,###.00", 'id_ID');

  Future _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(_token);
    setState(() {
      _token = prefs.getString('token');
    });
  }

  _getData() async {
    setState(() {
      canBack = false;
    });
    try {
      if (_token != null) {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          setState(() {
            canBack = true;
          });
          var response = await http.get(globalBaseUrl + 'api/cart',
              headers: {"Authorization": "Bearer " + _token});
          var _response = json.decode(response.body);

          _listCart = _response['data']['produk'];
          jmlhCart = _response['data']['count_produk'];
          // print(_listCart);
        }
        setState(() {
          isLoading = false;
        });

        //Foreach total to get subtotal
        // _listCart.forEach((element) {
        //   // log(element['id'].toString());
        //   _total = _total + int.parse(element['total']);
        // });
      } else if (_token == null) {
        setState(() {
          canBack = true;
        });
      }
    } on SocketException catch (_) {
      isConnect = false;
      isLoading = false;
      canBack = true;

      setState(() {});
    }
  }

  _switchWishedApi(String id) async {
    setState(() {
      isLoading = true;
      canBack = false;
    });
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await WishlistModel.switchWish(id).then((value) {
          Map<String, dynamic> res = json.decode(value.data);
          setState(() {
            canBack = true;
          });
          if (value.error) {
            showSnackBar('Terjadi Kesalahan!', Colors.red, Icon(Icons.close));
          }
          //success
          else {
            // showSnackBar('Berhasil Memfavoritkan produk', Colors.green,
            //     Icon(Icons.check_circle_outline));
          }
          _getData();
        });
      }
    } on SocketException catch (_) {
      showSnackBar('Terjadi Kesalahan!', Colors.red, Icon(Icons.close));
      canBack = true;

      setState(() {});
    }
  }

  /**
   * increase decrease qty item
   * 
   */
  _changeQty(int id, int qty) async {
    setState(() {
      canBack = false;
    });
    try {
      //do something
      // print(id);
      var response = await http.post(globalBaseUrl + 'api/cart/update_cart',
          body: {"id": id.toString(), "qty": qty.toString()},
          headers: {"Authorization": "Bearer " + _token});
      var _response = json.decode(response.body);
      setState(() {
        isLoading = true;
        canBack = true;
      });
      _getData();
      showSnackBar(_response['data']['message'], Colors.green,
          Icon(Icons.check_circle_outline));
    } on SocketException catch (_) {
      //catch Socket error
      isConnect = false;
      isLoading = false;
      canBack = true;

      setState(() {});
    } catch (e) {
      //catch any error
      print(e);
    }
  }

  /**
   * Delete Selected Cart Item
   * 
   */
  _deleteCart(id) async {
    setState(() {
      canBack = false;
    });
    try {
      var response = await http.post(
          globalBaseUrl + globalPathCart + 'delete_cart',
          body: {"id": id.toString()},
          headers: {"Authorization": "Bearer " + _token});

      setState(() {
        canBack = true;
      });

      var _response = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          isLoading = true;
        });
        _getData();
        showSnackBar(_response['data']['message'], Colors.green,
            Icon(Icons.check_circle_outline));
        setState(() {
          jmlhCart = _response['data']['count_produk'];
        });
      } else {
        showSnackBar(
            _response['data']['message'], Colors.red, Icon(Icons.close));
      }
    } catch (e) {
      setState(() {
        canBack = true;
      });
      showSnackBar(e.toString(), Colors.red, Icon(Icons.close));
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
          content: Text("Apakah anda yakin ingin menghapus item ini ?"),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Ya",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                Navigator.of(context).pop();

                _deleteCart(id);
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

/**
 *  send parameter to checkout 
 * 
 */
  _checkCart() {
    if (_selecteCarts.length < 1) {
      showSnackBar("Item Keranjang belum dipilih", Colors.red,
          FaIcon(FontAwesomeIcons.timesCircle));
    } else {
      // showSnackBar("Lanjut mas Semongko", Colors.green,
      //     FaIcon(FontAwesomeIcons.checkCircle));
      Navigator.push(
          //push screen to check out and send parameter
          context,
          MaterialPageRoute(
            builder: (context) => CheckOut(
              idProducts: _selecteCarts,
            ),
          ));
      //  Navigator.push(
      // //push screen to check out and send parameter
      // context,
      // MaterialPageRoute(
      //   builder: (context) => TestWebView(

      //   ),
      // ));
    }
  }

  /**
   * Showing Modal sunting item
   * 
   */
  _suntingCart(int i, BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    double qty = double.parse(_listCart[i]['qty']);
    double minOrder =
        double.parse(_listCart[i]['get_produk']['min_qty'] ?? '1');
    double maxOrder = double.parse(_listCart[i]['get_produk']['stock'] ?? '0') +
        double.parse(_listCart[i]['qty'] ?? '0');
    int cart_id = _listCart[i]['id'];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          content: Container(
            height: sizeu.width / 1.6,
            padding: EdgeInsets.fromLTRB(15, 0, 0, 5),
            decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              color: const Color(0xFFFFFF),
              borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: sizeu.width / 4 / 1.5,
                        width: sizeu.width / 4 / 1.5,
                        margin: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          image: new DecorationImage(
                              image: NetworkImage(globalBaseUrl +
                                      locationProductImage +
                                      _listCart[i]['get_produk']['gambar'] ??
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
                        width:
                            sizeu.width - sizeu.width / 4 / 1.5 - 20 - 30 - 30,
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
                            Row(
                              children: [
                                Card(
                                  color: Colors.green[100],
                                  child: Container(
                                      margin: EdgeInsets.all(2),
                                      child: Text(
                                        _listCart[i]['get_produk']
                                                    ['isGrosir'] ==
                                                1
                                            ? "Grosir"
                                            : 'Retail',
                                        style: TextStyle(
                                          color: Colors.green[800],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      )),
                                ),
                                Card(
                                  color: Colors.blue[100],
                                  child: Container(
                                      margin: EdgeInsets.all(2),
                                      child: Text(
                                        '${_listCart[i]['qty']} pcs',
                                        style: TextStyle(
                                          color: Colors.blue[800],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      )),
                                ),
                                Card(
                                  color: Colors.red[100],
                                  child: Container(
                                      margin: EdgeInsets.all(2),
                                      child: Text(
                                        'Tersedia ${_listCart[i]['get_produk']['stock'] ?? 0} pcs',
                                        style: TextStyle(
                                          color: Colors.red[800],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      )),
                                ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              width: sizeu.width - 50 - sizeu.width / 4 - 10,
                              child: Text(
                                'Rp${formatter.format(int.parse(_listCart[i]['total']))}',
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              width: sizeu.width - 50 - sizeu.width / 4 - 10,
                              child: Text(
                                'Minimal ' +
                                    '${_listCart[i]['get_produk']['min_qty'] ?? 1}' +
                                    ' Pcs',
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 13, color: Colors.blueGrey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                SpinBox(
                  min: minOrder,
                  max: maxOrder,
                  value: qty,
                  onChanged: (value) {
                    // print(int.parse(value.toString()));
                    qty = value;
                    // print(qty);
                  },
                ),
                MaterialButton(
                  onPressed: () {
                    // print('Hello');
                    Navigator.of(context).pop();
                    _changeQty(cart_id, qty.round());
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 18,
                    padding: EdgeInsets.all(1.0),
                    child: Material(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'SIMPAN',
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

  @override
  void initState() {
    // TODO: implement initState

    _getToken();
    Future.delayed(Duration(seconds: 1), () {
      _getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final wh_ = MediaQuery.of(context).size;

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
        body: (_token == null
            ? noLogin()
            : (!isConnect
                ? noConnection()
                : (!isLoading ? mainContainter(context) : reqLoad()))),
      ),
    );
  }

  Widget noLogin() {
    return Container(
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
                  _getData();
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

  Widget mainContainter(context) {
    return Container(
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
            }));
  }

  Widget cardKerangjang(context, i) {
    final sizeu = MediaQuery.of(context).size;
    int qty = int.parse(_listCart[i]['qty']);

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
          //Info Section
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
                        image: NetworkImage(globalBaseUrl +
                                locationProductImage +
                                _listCart[i]['get_produk']['gambar'] ??
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
                      Row(
                        children: [
                          Card(
                            color: Colors.green[100],
                            child: Container(
                                margin: EdgeInsets.all(2),
                                child: Text(
                                  _listCart[i]['get_produk']['isGrosir'] == 1
                                      ? "Grosir"
                                      : 'Retail',
                                  style: TextStyle(
                                    color: Colors.green[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                )),
                          ),
                          Card(
                            color: Colors.blue[100],
                            child: Container(
                                margin: EdgeInsets.all(2),
                                child: Text(
                                  '${_listCart[i]['qty']} pcs',
                                  style: TextStyle(
                                    color: Colors.blue[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                )),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        width: sizeu.width - 50 - sizeu.width / 4 - 10,
                        child: Text(
                          'Rp${formatter.format(int.parse(_listCart[i]['total']))}',
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),

          // Bottom button section
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
                    padding: EdgeInsets.only(top: 5),
                    child: Row(
                      children: <Widget>[
                        //Wishlist
                        Container(
                            width: 80,
                            padding: EdgeInsets.only(left: 5),
                            color: Colors.white,
                            child: FlatButton(
                              onPressed: () {
                                _switchWishedApi(
                                    '${_listCart[i]['get_produk']['id']}');
                              },
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(4)),
                              color: Colors.white,
                              child: Icon(
                                _listCart[i]['get_produk']['getWishlist'] == 0
                                    ? Icons.favorite_border
                                    : Icons.favorite,
                                color: Colors.green[300],
                              ),
                            )),

                        //Sunting
                        Container(
                            width: 80,
                            padding: EdgeInsets.only(left: 5),
                            color: Colors.white,
                            child: FlatButton(
                              onPressed: () {
                                _suntingCart(i, context);
                              },
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(4)),
                              color: Colors.white,
                              child: Icon(
                                Icons.edit,
                                color: Colors.yellow[800],
                              ),
                            )),

                        //Hapus
                        Container(
                            width: 80,
                            padding: EdgeInsets.only(left: 5),
                            color: Colors.white,
                            child: FlatButton(
                              onPressed: () {
                                confirmHapus(context, _listCart[i]['id']);
                              },
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(4)),
                              color: Colors.white,
                              child: Icon(
                                Icons.delete,
                                color: Colors.red[400],
                              ),
                            )),
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
                      'Rp${formatter.format(_total)}',
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
                color: Colors.green,
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
                      'Rp${total}',
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
