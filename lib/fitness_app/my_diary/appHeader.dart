import 'package:tokoterserah/fitness_app/fintness_app_theme.dart';
import 'package:tokoterserah/fitness_app/models/meals_list_data.dart';
//import 'package:tokoterserah/main.dart';
import 'package:flutter/material.dart';

//import '../../main.dart';

class AppHeader extends StatefulWidget {
  const AppHeader({Key key, this.animationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController animationController;
  final Animation<dynamic> mainScreenAnimation;

  @override
  _AppHeaderState createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> topBarAnimation;
  final ScrollController scrollController = ScrollController();
  TextStyle txtstyle = TextStyle(color: Colors.white);
  double topBarOpacity = 0.0;
  Color coloricon = Colors.white;
  TextEditingController editingController = TextEditingController();
  List<MealsListData> mealsListData = MealsListData.tabIconsList;

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

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

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
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
                            SizedBox(
                              height: 40,
                              width: 300,
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
                                            Radius.circular(25.0))),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 5.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25.0)))),
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
                              //       padding: const EdgeInsets.only(right: 1),
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
