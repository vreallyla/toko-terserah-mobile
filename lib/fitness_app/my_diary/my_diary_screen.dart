// import 'package:best_flutter_ui_templates/fitness_app/ui_view/body_measurement.dart';
// import 'package:best_flutter_ui_templates/fitness_app/ui_view/glass_view.dart';
// import 'package:best_flutter_ui_templates/fitness_app/ui_view/mediterranesn_diet_view.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:best_flutter_ui_templates/Constant/Constant.dart';
import 'package:best_flutter_ui_templates/fitness_app/ui_view/title_view.dart';
import 'package:best_flutter_ui_templates/fitness_app/fintness_app_theme.dart';
import 'package:best_flutter_ui_templates/fitness_app/my_diary/meals_list_view.dart';
import 'package:best_flutter_ui_templates/fitness_app/my_diary/item_square_view.dart';
import 'package:best_flutter_ui_templates/model/product_model.dart';

// import 'package:best_flutter_ui_templates/fitness_app/my_diary/water_view.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:best_flutter_ui_templates/fitness_app/ui_view/running_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:floating_search_bar/floating_search_bar.dart';

class MyDiaryScreen extends StatefulWidget {
  const MyDiaryScreen({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;
  @override
  _MyDiaryScreenState createState() => _MyDiaryScreenState();
}

class _MyDiaryScreenState extends State<MyDiaryScreen>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;
  TextEditingController editingController = TextEditingController();

  var size;
  double sizeHeight = 0;
  var dataHome=[];

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  TextStyle txtstyle = TextStyle(color: Colors.white);
  Color coloricon = Colors.white;

  _getHome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // dataHome = json.decode(prefs.getString('dataHome'));

    log(prefs.getString('dataHome').toString());
    dataHome= json.decode(prefs.getString('dataHome'))['banner'];
    addAllListData();
    print(dataHome);
    setState(() {
      
    });
    //  prefs.getString('token');
  }

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

    ProductModel.getHome().then((v) {
      _getHome();
      log('dasd');
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

  void addAllListData() {
    listViews=[];
    const int count = 9;

    listViews.add(CarouselSlider(
      options: CarouselOptions(
        height: 300.0,
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
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 1.0),
                // decoration: BoxDecoration(color: Colors.blueGrey),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(globalBaseUrl+locationBannerImage+i['banner']
                              ),
                    fit: BoxFit.cover,
                  ),
                ),
                // child: Text(
                //   'text '+i['banner'].toString(),
                //   style: TextStyle(fontSize: 16.0),
                // )
                );
          },
        );
      }).toList(),
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

    // kategori option
    // listViews.add(
    //   TitleView(
    //     titleTxt: 'Kategori',
    //     animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //         parent: widget.animationController,
    //         curve:
    //             Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
    //     animationController: widget.animationController,
    //   ),
    // );

    // listViews.add(
    //   MealsListView(
    //     mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
    //         CurvedAnimation(
    //             parent: widget.animationController,
    //             curve: Interval((1 / count) * 3, 1.0,
    //                 curve: Curves.fastOutSlowIn))),
    //     mainScreenAnimationController: widget.animationController,
    //   ),
    // );
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
              subTxt: 'Lainnya',
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController,
                      curve: Interval((1 / count) * 2, 1.0,
                          curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
            ),
            ItemSquareView(
              mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController,
                      curve: Interval((1 / count) * 3, 1.0,
                          curve: Curves.fastOutSlowIn))),
              mainScreenAnimationController: widget.animationController,
            ),
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
              subTxt: 'Lainnya',
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController,
                      curve: Interval((1 / count) * 2, 1.0,
                          curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
            ),
            ItemSquareView(
              mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController,
                      curve: Interval((1 / count) * 3, 1.0,
                          curve: Curves.fastOutSlowIn))),
              mainScreenAnimationController: widget.animationController,
            ),
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
              subTxt: 'Lainnya',
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController,
                      curve: Interval((1 / count) * 2, 1.0,
                          curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
            ),
            ItemSquareView(
              mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController,
                      curve: Interval((1 / count) * 3, 1.0,
                          curve: Curves.fastOutSlowIn))),
              mainScreenAnimationController: widget.animationController,
            ),
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
              subTxt: 'Lainnya',
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController,
                      curve: Interval((1 / count) * 2, 1.0,
                          curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
            ),
            ItemSquareView(
              mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController,
                      curve: Interval((1 / count) * 3, 1.0,
                          curve: Curves.fastOutSlowIn))),
              mainScreenAnimationController: widget.animationController,
            ),
          ],
        ),
      ),
    );

// listViews.add(
    //   GlassView(
    //       animation: Tween<double>(begin: 0.0, end: 1.0).animate(
    //           CurvedAnimation(
    //               parent: widget.animationController,
    //               curve: Interval((1 / count) * 8, 1.0,
    //                   curve: Curves.fastOutSlowIn))),
    //       animationController: widget.animationController),
    // );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      size = context.size;
    });

    return Container(
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            //                  Padding(
                            //   padding: const EdgeInsets.all(16.0),
                            //   child: TextField(
                            //     onChanged: (value) {

                            //     },
                            //     controller: editingController,
                            //     decoration: InputDecoration(
                            //         labelText: "Search",
                            //         hintText: "Search",
                            //         prefixIcon: Icon(Icons.search),
                            //         border: OutlineInputBorder(
                            //             borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                            //   ),
                            // ),
                            // Expanded(

                            //   child: Padding(
                            //     padding: const EdgeInsets.all(8.0),

                            //     // child: Text(
                            //     //   'Beranda',
                            //     //   textAlign: TextAlign.left,
                            //     //   style: TextStyle(
                            //     //     fontFamily: FintnessAppTheme.fontName,
                            //     //     fontWeight: FontWeight.w700,
                            //     //     fontSize: 22 + 6 - 6 * topBarOpacity,
                            //     //     letterSpacing: 1.2,
                            //     //     color: FintnessAppTheme.darkerText,
                            //     //   ),
                            //     // ),
                            //   ),
                            // ),
                            //                       FloatingSearchBar.builder(
                            //   itemCount: 10,
                            //   itemBuilder: (BuildContext context, int index) {
                            //     return ListTile(
                            //       leading: Text(index.toString()),
                            //     );
                            //   },
                            //   trailing: CircleAvatar(
                            //     child: Text("D"),
                            //   ),
                            //   drawer: Drawer(
                            //     child: Container(),
                            //   ),
                            //   onChanged: (String value) {},
                            //   onTap: () {},
                            //   decoration: InputDecoration.collapsed(
                            //     hintText: "Search...",
                            //   ),
                            // // ),
                            SizedBox(
                              height: 40,
                              width: 320,
                              child: TextField(
                                onChanged: (value) {},
                                controller: editingController,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelText: "Cari Produk",
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
                                            color: Colors.grey, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0))),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 5.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)))),
                              ),
                            ),
                            //),
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
                            // SizedBox(
                            //   height: 38,
                            //   width: 38,
                            //   child: InkWell(
                            //     highlightColor: Colors.transparent,
                            //     borderRadius: const BorderRadius.all(
                            //         Radius.circular(32.0)),
                            //     onTap: () {},
                            //     child: Center(
                            //       child: Icon(
                            //         Icons.keyboard_arrow_right,
                            //         color: FintnessAppTheme.grey,
                            //       ),
                            //     ),
                            //   ),
                            // ),
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
