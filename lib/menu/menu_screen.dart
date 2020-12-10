import 'dart:async';
import 'dart:convert';
// import 'dart:developer';
import 'dart:io';

// import 'package:tokoterserah/model/user_model.dart';
import 'package:tokoterserah/Constant/Constant.dart';
import 'package:tokoterserah/fitness_app/fintness_app_theme.dart';
import 'package:tokoterserah/fitness_app/register/register_screen_i.dart';
import 'package:tokoterserah/model/keranjang_model.dart';
import 'package:tokoterserah/model/wishlist_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key key, this.animationController, this.searchAlocation})
      : super(key: key);

  final AnimationController animationController;
  final Function(String jenis, String cari, String other) searchAlocation;

  // final AnimationController animationController;
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
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

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    // Future.delayed(Duration(seconds: 0), () {
    // getDataApi();
    Future.delayed(Duration.zero, () {
      double height = MediaQuery.of(context).size.height;

      addAllListData(height);
    });
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

  void addAllListData(height) {
    listViews = [];
    const int count = 9;

    // dataWish.add({"nama": "agus"});
    // dataWish.add({"nama": "adib"});

    // cari textfield
    listViews.add(Container(
      height: height - 140,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              card(
                'semua',
                'Semua',
                FaIcon(
                  FontAwesomeIcons.layerGroup,
                  color: Colors.white,
                ),
                null,
              ),
              card(
                'grosir',
                'Grosir',
                FaIcon(
                  FontAwesomeIcons.boxes,
                  color: Colors.white,
                ),
                null,
              ),
              card(
                'retail',
                'Retail',
                FaIcon(
                  FontAwesomeIcons.shoppingBag,
                  color: Colors.white,
                ),
                null,
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                card(
                  'semua',
                  'Store',
                  FaIcon(
                    FontAwesomeIcons.store,
                    color: Colors.white,
                  ),
                  'store',
                ),
                card(
                  'grosir',
                  'Customer Service',
                  FaIcon(
                    FontAwesomeIcons.whatsapp,
                    color: Colors.white,
                  ),
                  'cs',
                ),
                card(
                  'retail',
                  'Voucher',
                  FaIcon(
                    FontAwesomeIcons.gift,
                    color: Colors.white,
                  ),
                  'voucher',
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: card(
                    'retail',
                    'FAQ',
                    FaIcon(
                      FontAwesomeIcons.question,
                      color: Colors.white,
                    ),
                    'faq',
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(),
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget card(String jenis, String title, FaIcon icon, String other) {
    return Expanded(
      flex: 1,
      child: InkWell(

        onTap: () => widget.searchAlocation(jenis, '', other),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            alignment: Alignment.center,
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(30)),
            child: icon,
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            child: Text(
              title,
              textAlign: TextAlign.center,
            ),
          )
        ]),
      ),
    );
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
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Menu',
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
