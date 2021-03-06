import 'dart:async';
import 'dart:convert';
// import 'dart:developer';
import 'dart:io';

// import 'package:tokoterserah/model/user_model.dart';
import 'package:tokoterserah/Constant/Constant.dart';
import 'package:tokoterserah/fitness_app/register/register_screen_i.dart';
import 'package:tokoterserah/model/keranjang_model.dart';
import 'package:tokoterserah/model/wishlist_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../fintness_app_theme.dart';
import './item_wishlist_view.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen(
      {Key key, this.animationController, this.funcChangeCartQty,})
      : super(key: key);

  final AnimationController animationController;
  final Function(int qty) funcChangeCartQty;
  // final AnimationController animationController;
  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;

  List<Widget> listViews = <Widget>[];
  List dataWish = [];
  List dataTest = [];
  final ScrollController scrollController = ScrollController();
  bool isLogin = true;
  bool isConnect = true;
  bool isLoading = true;
  bool isLoading2 = false;
  Timer _timer;
  TextEditingController searchInput = new TextEditingController();

  double topBarOpacity = 0.0;

  _setData() async {
    // await _getDataApi('');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var resWishlist = prefs.getString('dataWishlist');
    // print(resWishlist);

    if (resWishlist != null && isLogin) {
      isLoading = false;
      dataTest = json.decode(resWishlist)['data'];
      // print('dasd');
      // print(dataTest);

    }
    addAllListData();
    setState(() {});
  }

  _getDataApi() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await WishlistModel.getWish(searchInput.text).then((value) {
          print(value.error);

          if (value.error) {
            isLogin = false;
            setState(() {});
          }
          isLoading = false;
          _setData();
        });
      }
    } on SocketException catch (_) {
      isConnect = false;
      isLoading = false;
      addAllListData();
      setState(() {});
    }
  }

  _addCartApi(String id, String qty) async {
    setState(() {
      isLoading2 = true;
    });
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await KeranjangModel.addCart(id, qty).then((value) {
          isLoading2 = false;
          Map<String, dynamic> res = json.decode(value.data);
          // print(value.data);

          if (value.error && !res.containsKey('error')) {
            isLogin = false;
          } else {
            // widget.funcChangeCartQty(jsonDecode(value.data))['count_cart'];
            // print(jsonDecode(value.data));
            widget.funcChangeCartQty(res['count_cart']);
          }
          setState(() {
            _getDataApi();
            addAllListData();
          });

          showDialog(
              context: context,
              builder: (BuildContext builderContext) {
                _timer = Timer(Duration(seconds: 2), () {
                  Navigator.of(context).pop();
                });

                return new AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  content: Builder(
                    builder: (context) {
                      // Get available height and width of the build area of this widget. Make a choice depending on the size.
                      var height = MediaQuery.of(context).size.height;
                      var width = MediaQuery.of(context).size.width;

                      return Container(
                        height: 120,
                        width: width - 100,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 20),
                              child: Text(
                                value.error
                                    ? (res.containsKey('error')
                                        ? 'Stok Kosong!'
                                        : 'Gagal memasukkan ke Keranjang!')
                                    : 'Wishlist telah dimasukan ke keranjang!',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: RaisedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                color: value.error ? Colors.red : Colors.green,
                                child: Text(
                                  'OK',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                );
              }).then((val) {
            if (_timer.isActive) {
              _timer.cancel();
            }
          });

          setState(() {});
        });
      }
    } on SocketException catch (_) {
      // print('dasd');
      isLoading2 = false;

      isConnect = false;
      isLoading = false;
      addAllListData();
      setState(() {});
    }
  }

  Widget noLogin() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 80),
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
                  isLoading = true;
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

  //show login message on screen
  void setLogin(bool cond) {
    setState(() {
      isLogin = cond;
    });
  }

  // change screen with loading image
  void setLoading(bool cond) {
    setState(() {
      isLoading = cond;
    });
  }

  // block screen
  void setOverlay(bool cond) {
    setState(() {
      isLoading2 = cond;
    });
  }

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    _getDataApi();

    // Future.delayed(Duration(seconds: 0), () {
    // getDataApi();
    addAllListData();
    // });

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  void addAllListData() {
    listViews = [];
    const int count = 9;

    // dataWish.add({"nama": "agus"});
    // dataWish.add({"nama": "adib"});

    // cari textfield
    listViews.add(Container(
      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
      decoration: BoxDecoration(
        // borderRadius: const BorderRadius.only(
        //   bottomRight: Radius.circular(20),
        //   bottomLeft: Radius.circular(20),
        //   topLeft: Radius.circular(0),
        //   topRight: Radius.circular(0),
        // ),
        color: Colors.white,
      ),
      margin: EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 40,
        child: TextFormField(
          controller: searchInput,
          onChanged: (text) {
            setState(() {});
            _getDataApi();
          },
          // onSubmitted: (_) => FocusScope.of(context).nextFocus(),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black54, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black38, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black38, width: 1),
            ),
            hintText: 'Cari Wishlist',
            fillColor: Colors.white,
            filled: true,
          ),
          style: new TextStyle(
            fontFamily: "Poppins",
          ),
        ),
      ),
    ));
    if (!isConnect) {
      listViews.add(noConnection());
    }
    //loading
    else if (isLoading) {
      listViews.add(reqLoad());
    } else if (!isLogin) {
      listViews.add(noLogin());
    } else if (dataTest.length == 0) {
      listViews.add(dataKosong());
    }
    //fill data
    else {
      listViews.add(
        ItemWishlistView(
          qtyCart:(int qty){
            widget.funcChangeCartQty(qty);
          },
          eventHandle: (bool login, bool loading, bool loadingOverlay) {
            setLogin(login);
            setLoading(loading);
            setOverlay(loadingOverlay);
          },
          functAddCart: (String id, String qty) {
            _addCartApi(id, qty);
          },
          mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: widget.animationController,
                  curve: Interval((1 / count) * 3, 1.0,
                      curve: Curves.fastOutSlowIn))),
          mainScreenAnimationController: widget.animationController,
          countWishlist: dataTest.length,
          dataWishlist: dataTest,
        ),
      );
    }
  }

  Container cardWishlist() {
    return (Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
      child: Card(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Colors.black45,
                width: 20,
                height: 20,
              )
            ],
          ),
        ),
      ),
    ));
  }

  BoxDecoration borderTop() {
    return BoxDecoration(
      border: Border(
        top: BorderSide(width: 0.8, color: Colors.black26),
      ),
      color: Colors.white,
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: FintnessAppTheme.background,
      child: Scaffold(
        // appBar: AppBar(
        //     // Use Brightness.light for dark status bar
        //     // or Brightness.dark for light status bar
        //     brightness: Brightness.light),
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Stack(
            children: <Widget>[
              getMainListViewUI(),
              getAppBarUI(),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              ),
              isLoading2
                  ? Container(
                      width: size.width,
                      height: size.height,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.2),
                      ),
                      child: Image.asset(
                        'assets/fitness_app/global_loader.gif',
                        scale: 5,
                      ),
                    )
                  : Text(
                      '',
                      style: TextStyle(fontSize: 0),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: FintnessAppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                        // bottomLeft: Radius.circular(32.0),
                        ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: FintnessAppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.arrow_back_ios)),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Wishlist',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: FintnessAppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: FintnessAppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
