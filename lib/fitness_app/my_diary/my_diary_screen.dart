import 'dart:convert';
import 'dart:io';

import 'package:tokoterserah/Constant/Constant.dart';
import 'package:tokoterserah/event/animation/spinner.dart';
import 'package:tokoterserah/fitness_app/my_diary/voucher_list_screen.dart';
import 'package:tokoterserah/fitness_app/ui_view/title_view.dart';
import 'package:tokoterserah/fitness_app/fintness_app_theme.dart';
import 'package:tokoterserah/fitness_app/my_diary/item_square_view.dart';
import 'package:tokoterserah/model/product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDiaryScreen extends StatefulWidget {
  const MyDiaryScreen({
    Key key,
    this.animationController,
    this.searchAlocation,
    this.funcChangeCartQty,
  }) : super(key: key);

  final AnimationController animationController;
  final Function(String jenis, String search) searchAlocation;
  final Function(int qty) funcChangeCartQty;

  @override
  _MyDiaryScreenState createState() => _MyDiaryScreenState();
}

class _MyDiaryScreenState extends State<MyDiaryScreen>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;
  TextEditingController editingController = TextEditingController();

  var size;
  double sizeHeight = 0;
  var dataHome = [];
  List dataFlashSale = [];
  List dataProductBaru = [];
  List dataUnggulan = [];
  List dataTerlaris = [];
  bool isConnect = true;
  int _current = 0;
  int voucherCount = 0;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  TextStyle txtstyle = TextStyle(color: Colors.white);
  Color coloricon = Colors.white;

  _getHome(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dataRes = json.decode(prefs.getString('dataHome'));
    // dataHome = json.decode(prefs.getString('dataHome'));

    // log(prefs.getString('dataHome').toString());
   if(dataRes['message']==null){
    dataHome = dataRes['banner'];
    dataFlashSale = dataRes['flash_sale'];
    dataProductBaru = dataRes['newest'];
    dataUnggulan = dataRes['popular'];
    dataTerlaris = dataRes['top_rated'];
    voucherCount = dataRes['voucher_count'];
   }
  
    addAllListData(context);
    // print(dataHome);
    setState(() {});
    //  prefs.getString('token');
  }

  _getDataApi(context) async {
  
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await ProductModel.getHome().then((v) {
          _getHome(context);
          // log('dasd');
        });
      }
    } on SocketException catch (_) {
      isConnect = false;
  

      setState(() {});
    }
  }

  Widget noConnection(context) {
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
            margin: EdgeInsets.only(top: 90),
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
                  // isLoading=true;
                  isConnect = true;
                  _getDataApi(context);
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

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    Future.delayed(Duration.zero, () {
      addAllListData(context);
      _getDataApi(context);
    });

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
            txtstyle = TextStyle(color: Colors.black);
            coloricon = Colors.black;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
            txtstyle = TextStyle(color: Colors.white);
            coloricon = Colors.white;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
            txtstyle = TextStyle(color: Colors.white);
            coloricon = Colors.white;
          });
        }
      }
    });
    super.initState();
  }

  void addAllListData(context) {
    final size = MediaQuery.of(context).size;

    listViews = [];
    const int count = 9;
    if (!isConnect) {
      listViews.add(noConnection(context));
    } else {
      listViews.add(Container(
        child: SizedBox(height: 100),
      ));
      //carousel
      listViews.add(Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              onPageChanged: (i, r) {
                setState(() {
                  _current = i;
                });
              },
              height: (size.width-(size.width/2.5)),
              aspectRatio: 16 / 9,
              viewportFraction: 1.0,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: false,
              scrollDirection: Axis.horizontal,
            ),
            items: dataHome.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: EdgeInsets.all(5.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        child: Stack(
                          children: <Widget>[
                         CachedNetworkImage(
                              imageUrl: globalBaseUrl +
                                  locationBannerImage +
                                  i['banner'],
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                    // colorFilter: ColorFilter.mode(
                                    //     Colors.red, BlendMode.colorBurn)
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Spinner(
                                  icon: Icons.refresh, color: Colors.black54),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ],
                        )),
                  );
                },
              );
            }).toList(),
          ),
          Container(
            margin: EdgeInsets.only(top: (size.width-(size.width/2.5))-30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: dataHome.map((url) {
                int index = dataHome.indexOf(url);
                return Container(
                  width: 15.0,
                  height: 4.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(2)),

                    // shape: BoxShape.circle,
                    color: _current == index
                        ? Colors.white
                        : Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ));

      // kupon voucher banner card
      // listViews.add(
      //   RunningView(
      //     animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      //         parent: widget.animationController,
      //         curve:
      //             Interval((1 / count) * 3, 1.0, curve: Curves.fastOutSlowIn))),
      //     animationController: widget.animationController,
      //   ),
      // );

      // kategori
      listViews.add(
        Container(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 15),
          margin: EdgeInsets.only(bottom: 15),
          // margin: EdgeInsets.only(top:15),
          color: Colors.white,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VoucherListScreen(),
                      ));
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          width: .3, color: Colors.grey.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ]),
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.ticketAlt,
                        color: Colors.green[600],
                      ),
                      Text(
                        ' Gunakan Voucher',
                        style: TextStyle(
                            color: Colors.green[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      Text(
                          voucherCount == 0
                              ? ' (Belum tersedia)'
                              : ' (Tersedia ${voucherCount.toString()} Voucher)',
                          style: TextStyle(
                            color: Colors.grey[500],
                          )),
                    ],
                  ),
                ),
              ),

              // TitleView(
              //   // otherData:true,
              //   funcClick: () {
              //     widget.searchAlocation('semua', '');
              //   },
              //   titleTxt: '',
              //   subTxt: '',
              //   animation: Tween<double>(begin: 0.0, end: 1.0).animate(
              //       CurvedAnimation(
              //           parent: widget.animationController,
              //           curve: Interval((1 / count) * 2, 1.0,
              //               curve: Curves.fastOutSlowIn))),
              //   animationController: widget.animationController,
              // ),
              // //     MealsListView(
              //   mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
              //       CurvedAnimation(
              //           parent: widget.animationController,
              //           curve: Interval((1 / count) * 3, 1.0,
              //               curve: Curves.fastOutSlowIn))),
              //   mainScreenAnimationController: widget.animationController,
              // ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      widget.searchAlocation('semua', '');
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(right: 8),
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF42E695), Color(0xFF3BB2B8)])),
                      width: (size.width - 30 - 16) / 3,
                      // color: Colors.green,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.sortAlphaDownAlt,
                            size: 16,
                            color: Colors.white,
                          ),
                          Text(
                            ' SEMUA',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      widget.searchAlocation('grosir', '');
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(right: 8),
                      height: 40,
                      width: (size.width - 30 - 16) / 3,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFFCE38A), Color(0xFFF38181)])),
                      // color: Colors.green,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.boxes,
                            size: 16,
                            color: Colors.white,
                          ),
                          Text(
                            ' GROSIR',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      widget.searchAlocation('retail', '');
                    },
                    child: Container(
                      alignment: Alignment.center,
                      // margin: EdgeInsets.only(right:8),
                      height: 40,
                      width: (size.width - 30 - 16) / 3,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFF54EA2), Color(0xFFFF7676)])),
                      // color: Colors.green,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.storeAlt,
                            size: 16,
                            color: Colors.white,
                          ),
                          Text(
                            ' RETAIL',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //  Container(
                  //   alignment: Alignment.center,
                  //   margin: EdgeInsets.only(right:8),
                  //   height: 60,
                  //   width: (size.width-30-16)/3,
                  //   color: Colors.green,
                  //   child: Text(((size.width-30)/3).toString()),
                  // ),
                ],
              )
            ],
          ),
        ),
      );

      // flash Sale
      listViews.add(
        Container(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          // margin: EdgeInsets.only(top:15),
          color: Colors.white,
          child: Column(
            children: [
              TitleView(
                titleTxt: 'Flash Sale',
                funcClick: () {
                  widget.searchAlocation('semua', '');
                },
                subTxt: 'Lainnya',
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval((1 / count) * 2, 1.0,
                            curve: Curves.fastOutSlowIn))),
                animationController: widget.animationController,
              ),
              ItemSquareView(
                  eventSetCart: (int qty) async {
                    // widget.funcChangeCartQty(qty);
                    // print(qty);
                    widget.funcChangeCartQty(qty);
                    setState(() {});
                  },
                  mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0)
                      .animate(CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / count) * 3, 1.0,
                              curve: Curves.fastOutSlowIn))),
                  mainScreenAnimationController: widget.animationController,
                  dataCard: dataFlashSale),
            ],
          ),
        ),
      );

      //produk Terbaru
      listViews.add(
        Container(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          margin: EdgeInsets.only(top: 15),
          color: Colors.white,
          child: Column(
            children: [
              TitleView(
                titleTxt: 'Produk Terbaru',
                funcClick: () {
                  widget.searchAlocation('semua', '');
                },
                subTxt: 'Lainnya',
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval((1 / count) * 2, 1.0,
                            curve: Curves.fastOutSlowIn))),
                animationController: widget.animationController,
              ),
              ItemSquareView(
                  eventSetCart: (int qty) async {
                    // widget.funcChangeCartQty(qty);
                    // print(qty);
                    widget.funcChangeCartQty(qty);
                    setState(() {});
                  },
                  mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0)
                      .animate(CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / count) * 3, 1.0,
                              curve: Curves.fastOutSlowIn))),
                  mainScreenAnimationController: widget.animationController,
                  dataCard: dataProductBaru),
            ],
          ),
        ),
      );

      //produk Terlaris
      listViews.add(
        Container(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          margin: EdgeInsets.only(top: 15),
          color: Colors.white,
          child: Column(
            children: [
              TitleView(
                titleTxt: 'Produk Terlaris',
                funcClick: () {
                  widget.searchAlocation('semua', '');
                },
                subTxt: 'Lainnya',
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval((1 / count) * 2, 1.0,
                            curve: Curves.fastOutSlowIn))),
                animationController: widget.animationController,
              ),
              ItemSquareView(
                  eventSetCart: (int qty) async {
                    // widget.funcChangeCartQty(qty);
                    // print(qty);
                    widget.funcChangeCartQty(qty);
                    setState(() {});
                  },
                  mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0)
                      .animate(CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / count) * 3, 1.0,
                              curve: Curves.fastOutSlowIn))),
                  mainScreenAnimationController: widget.animationController,
                  dataCard: dataTerlaris),
            ],
          ),
        ),
      );

      //produk Unggulan
      listViews.add(
        Container(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          margin: EdgeInsets.only(top: 15),
          color: Colors.white,
          child: Column(
            children: [
              TitleView(
                titleTxt: 'Produk Unggulan',
                funcClick: () {
                  widget.searchAlocation('semua', '');
                },
                subTxt: 'Lainnya',
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval((1 / count) * 2, 1.0,
                            curve: Curves.fastOutSlowIn))),
                animationController: widget.animationController,
              ),
              ItemSquareView(
                  eventSetCart: (int qty) async {
                    // widget.funcChangeCartQty(qty);
                    // print(qty);
                    widget.funcChangeCartQty(qty);
                    setState(() {});
                  },
                  mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0)
                      .animate(CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / count) * 3, 1.0,
                              curve: Curves.fastOutSlowIn))),
                  mainScreenAnimationController: widget.animationController,
                  dataCard: dataUnggulan),
            ],
          ),
        ),
      );
    }
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration.zero, () {
    size = MediaQuery.of(context).size;
    // });
    addAllListData(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        color: FintnessAppTheme.background,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: <Widget>[
              getMainListViewUI(),
              getAppBarUI(),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ),
      ),
    );
  }

  void launchWhatsApp({
    @required String phone,
    @required String message,
  }) async {
    String url() {
      if (Platform.isIOS) {
        return "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
      } else {
        return "whatsapp://send?phone=$phone&text=${Uri.parse(message)}";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      // throw 'Could not launch ${url()}';
      loadNotice(context, 'Whatsapp belum terinstall...', false, 'OK', ()=> Navigator.of(context).pop());
    }
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
              // top: AppBar().preferredSize.height +
              //     MediaQuery.of(context).padding.top +
              //     24,
              top: 0,
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
                    // borderRadius: const BorderRadius.only(
                    //   // bottomLeft: Radius.circular(20.0),
                    //   // bottomRight: Radius.circular(20.0),
                    // ),
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
                        height: MediaQuery.of(context).padding.top + 10,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            // top: 11 - 8.0 * topBarOpacity,
                            bottom: 16 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 40,
                              width: size.width - 34 - 30 - 8,
                              child: TextField(
                                onSubmitted: (val) {
                                  widget.searchAlocation('semua', val);
                                },
                                controller: editingController,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    // labelText: "Cari Produk",
                                    labelStyle: TextStyle(color: Colors.grey),
                                    hintText: "Cari Produk",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    contentPadding: const EdgeInsets.all(1.0),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 2),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4.0))),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 5.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)))),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                            ),
                            SizedBox(
                                height: 25,
                                width: 25,
                                child: InkWell(
                                  onTap: () {
                                    launchWhatsApp(
                                        message: 'Hallo min....',
                                        phone: '628113191081');
                                  },
                                  child: FaIcon(
                                    FontAwesomeIcons.envelope,
                                    size: 35,
                                    color: topBarOpacity != 1.0
                                        ? Colors.blueGrey
                                        : Colors.blueGrey,
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 1,
                                right: 1,
                              ),
                              // child: Row(
                              //   children: <Widget>[
                              //     Padding(
                              //       padding: const EdgeInsets.only(left: 3),
                              //       child: Icon(
                              //         Icons.notifications,
                              //         color: coloricon,
                              //         size: 25,
                              //       ),
                              //     ),
                              //     // Text(
                              //     //   '15 May',
                              //     //   textAlign: TextAlign.left,
                              //     //   style: TextStyle(
                              //     //     fontFamily: FintnessAppTheme.fontName,
                              //     //     fontWeight: FontWeight.normal,
                              //     //     fontSize: 18,
                              //     //     letterSpacing: -0.2,
                              //     //     color: FintnessAppTheme.darkerText,
                              //     //   ),
                              //     // ),
                              //   ],
                              // ),
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
