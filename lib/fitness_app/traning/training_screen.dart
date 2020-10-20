import 'dart:convert';
import 'dart:io';

import 'package:best_flutter_ui_templates/Constant/Constant.dart';
import 'package:best_flutter_ui_templates/Constant/EventHelper.dart';
// import 'package:best_flutter_ui_templates/fitness_app/login/form_login_view.dart';
import 'package:best_flutter_ui_templates/model/login_model.dart';
import 'package:best_flutter_ui_templates/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../fintness_app_theme.dart';
import './profil_card_view.dart';
import 'package:barcode_flutter/barcode_flutter.dart';

// import '../../bar_icons.dart';
import 'dart:async';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;

  @override
  _TrainingScreenState createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;

  List<Widget> listViews = <Widget>[];
  bool sudahLogin = false;
  bool isLoading = true;
  bool isConnect = true;
  String tokenFixed;
  var res;
  var kodeBarcode = '123s4';

  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  Widget rowButton(String titlen, Widget icon, bool conBorder, bool conMargin,
      String subTitle, String eventn) {
    List textTitle = <Widget>[];
    double wid = conBorder ? 0.5 : 0;
    Color warna = conBorder ? Colors.black26 : Colors.white;
    double marginr = conMargin ? 15 : 0;

    textTitle.add(Text(titlen,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        )));

    if (subTitle.length > 0) {
      textTitle.add(Text(subTitle,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey,
          )));
    }

    return InkWell(
      onTap: () {
        eclick(eventn);
      },
      child: Container(
        height: 70,
        margin: EdgeInsets.only(bottom: marginr),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: wid, color: warna),
          ),
          color: Colors.white,
        ),
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Row(
          children: <Widget>[
            icon,
            Container(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: textTitle,
                ))
          ],
        ),
      ),
    );
  }

  void eclick(String no) {
    // AnimationController animationController;

    switch (no) {
      case "barcode":
        {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0)), //this right here
                  child: Container(
                    height: 200,
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 30, bottom: 10),
                            child: Text(
                                'Scan Barcode ke Kasir Toko Terserah...',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18)),
                          ),
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(5),
                            height: 100,
                            child: BarCodeImage(
                              params: Code39BarCodeParams(
                                kodeBarcode,
                                lineWidth:
                                    2.0, // width for a single black/white bar (default: 2.0)
                                barHeight:
                                    90.0, // height for the entire widget (default: 100.0)
                                withText:
                                    true, // Render with text label or not (default: false)
                              ),
                              onError: (error) {
                                // Error handler
                                print('error = $error');
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        }
        break;

      case 'alamat':
        {
          Navigator.pushNamed(context, '/listalamat');
        }
        break;
      case 'keluar':
        {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0)), //this right here
                  child: Container(
                    height: 160,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.bottomRight,
                              padding: EdgeInsets.only(right: 8, bottom: 15),
                              child: FaIcon(
                                FontAwesomeIcons.times,
                                color: Colors.black54,
                                size: 16,
                              ),
                            ),
                          ),
                          Container(
                            child: Text('Apa anda yakin keluar?',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18)),
                          ),
                          Container(
                              color: Colors.white,
                              padding: EdgeInsets.all(5),
                              height: 100,
                              child: Row(
                                children: [
                                  Spacer(
                                    flex: 1,
                                  ),
                                  RaisedButton(
                                    child: Text(
                                      'Ya',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Colors.green,
                                    onPressed: () {
                                      LoginModel.logout().then((value) {
                                        if (!value.error) {
                                          sudahLogin = false;

                                          setState(() {
                                            addAllListData();
                                          });
                                        }
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil('/home',
                                                (Route<dynamic> route) => false,
                                                arguments: {
                                              "after_logout": true
                                            });
                                      });
                                    },
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                  RaisedButton(
                                    child: Text(
                                      'Tidak',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Colors.red[500],
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                );
              });
        }
        break;
      default:
        {
          //statements;
        }
        break;
    }
  }

  

  _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    tokenFixed = prefs.getString('token');
    kodeBarcode = prefs.getString('dataUser');
    print(tokenFixed);
    isLoading = true;

    _getBarcode();
    setState(() {});

    if (tokenFixed != null) {
      checkConnection();
    } else {
      sudahLogin = false;
      isLoading = false;
      setState(() {});
    }
    //  prefs.getString('token');
  }

  _getBarcode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    kodeBarcode = prefs.getString('dataUser');
    kodeBarcode = kodeBarcode != null
        ? await zerofill(
            jsonDecode(kodeBarcode)['user']['id'].toInt(), lenBarcode)
        : '000s021';
  }

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    _getToken();
    addAllListData();

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

  void checkConnection() async {
    if (tokenFixed != null) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          this.getData();
          new Future.delayed(Duration(seconds: 0), () {
            // isConnect=false;
            UserModel.akunRes().then((value) {
              res = jsonDecode(value.data);

              if (value.error) {
              } else {
                sudahLogin = true;

                if (kodeBarcode != '123s4') {
                  _getBarcode();
                }

                print(res);
              }
              isLoading = false;

              setState(() {
                addAllListData();
              });
            });
          });
        }
      } on SocketException catch (_) {
        isConnect = false;
        setState(() {});
      }
    } else {
      isLoading = false;
      setState(() {});
    }
  }

  void _loginMasuk(BuildContext context) async {
    var result = await Navigator.pushNamed(context, '/login');
    setState(() {
      listViews.clear();
    });
    // Scaffold.of(context).showSnackBar(SnackBar(
    //   content: Text("$result"),
    //   duration: Duration(seconds: 3),
    // ));

    var data = jsonDecode(result);

    if (data["load"]) {
      print('back');
      sudahLogin = false;

      _getToken();
      addAllListData();

      setState(() {});
    }
  }

  void addAllListData() {
    setState(() {
      listViews.clear();
    });
    if (sudahLogin) {
      const int count = 9;
      listViews = <Widget>[];
      listViews.add(
        ProfilCardView(
          mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: widget.animationController,
                  curve: Interval((1 / count) * 3, 1.0,
                      curve: Curves.fastOutSlowIn))),
          mainScreenAnimationController: widget.animationController,
        ),
      );
    } else {
      listViews.add(Container(
        height: 160,
        decoration: BoxDecoration(
          // borderRadius: const BorderRadius.only(
          //   bottomRight: Radius.circular(20),
          //   bottomLeft: Radius.circular(20),
          //   topLeft: Radius.circular(0),
          //   topRight: Radius.circular(0),
          // ),
          color: Colors.green[700],
        ),
        padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
        margin: EdgeInsets.only(bottom: 30),
        child: Column(children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 15),
            child: Text(
              'Mari bergabung dengan kami dan temukan kemudahannya...',
              style: TextStyle(color: Colors.white, fontSize: 15),
              textAlign: TextAlign.justify,
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.only(right: 5),
                    child: RaisedButton(
                      padding: EdgeInsets.all(10),
                      onPressed: () {
                        _loginMasuk(context);
                      },
                      color: Colors.white,
                      child: Text(
                        'MASUK',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.only(left: 5),
                    child: RaisedButton(
                      padding: EdgeInsets.all(10),
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      color: Colors.green,
                      child: Text(
                        'DAFTAR',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  )),
            ],
          )
        ]),
      ));
    }

    if (sudahLogin) {
      listViews.add(rowButton(
        'Lihat Barcode',
        FaIcon(
          FontAwesomeIcons.barcode,
          color: Colors.grey,
        ),
        false,
        false,
        'Gunakan barcode dikasir',
        'barcode',
      ));

      listViews.add(rowButton(
        'Daftar Alamat',
        FaIcon(
          FontAwesomeIcons.streetView,
          color: Colors.grey,
        ),
        true,
        false,
        '',
        'alamat',
      ));

      listViews.add(rowButton(
        'Keluar',
        Icon(Icons.exit_to_app, color: Colors.grey),
        true,
        true,
        '',
        'keluar',
      ));
    }

    listViews.add(rowButton(
      'Hubungi Kami',
      Icon(Icons.phone, color: Colors.grey),
      false,
      false,
      'Hubungi langsung tim kami',
      'barcode',
    ));

    listViews.add(rowButton(
      'Syarat & Ketentuan',
      Icon(Icons.library_books, color: Colors.grey),
      true,
      false,
      '',
      'barcode',
    ));

    listViews.add(rowButton(
      'Kebijakan Privasi',
      Icon(Icons.lock_outline, color: Colors.grey),
      true,
      false,
      '',
      'barcode',
    ));
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
Widget noConnection(){
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top:120),
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
          Text('Koneksi Terputus',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
          Text('Periksa sambungan internet kamu',style:TextStyle(color: Colors.black54)),
          Container(
            margin:EdgeInsets.only(top:15),
            child: RaisedButton(
              onPressed: (){
                setState(() {
                  isLoading=true;
                  isConnect=true;
                checkConnection();
                });
              },
              color: Colors.green,
              child: Text('COBA LAGI',style:TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
  );
}


    return Container(
      color: FintnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            (!isConnect
                ? noConnection()
                : (!isLoading ? getMainListViewUI() : reqLoad())),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
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
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Data Akun',
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

  startTime() async {
    var duration = new Duration(seconds: 6);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushNamed(context, '/listalamat');
  }
}
