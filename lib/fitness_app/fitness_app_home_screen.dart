import 'package:tokoterserah/fitness_app/models/tabIcon_data.dart';
import 'package:tokoterserah/fitness_app/traning/training_screen.dart';
import 'package:tokoterserah/menu/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';
import 'fintness_app_theme.dart';
import 'my_diary/my_diary_screen.dart';
import 'package:tokoterserah/design_course/home_design_course.dart';

class FitnessAppHomeScreen extends StatefulWidget {
  @override
  _FitnessAppHomeScreenState createState() => _FitnessAppHomeScreenState();
}

class _FitnessAppHomeScreenState extends State<FitnessAppHomeScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  int qtyCart = -1;

  var hello;

  Widget tabBody = Container(
    color: FintnessAppTheme.background,
  );

  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    hello = prefs.getString('dataUser');
    //  prefs.getString('token');
  }

  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    // tabIconsList[0].isSelected = true;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      final Map arguments = ModalRoute.of(context).settings.arguments as Map;

      // if (arguments != null) print('3test: '+arguments['after_login'].toString());

      animationController = AnimationController(
          duration: const Duration(milliseconds: 200), vsync: this);

      if (arguments != null
          ? (arguments['after_login'] != null ||
              arguments['after_logout'] != null)
          : false) {
        tabIconsList[2].isSelected = true;
// _getUser();

//        new Future.delayed(Duration(seconds: 0), () {
//           print(hello);
//           print('as');
//        });

        tabBody = TrainingScreen(animationController: animationController);
      } else if (arguments != null
          ? arguments['search_product'] != null
          : false) {
        arguments['search_product'] = null;
        qtyCart = arguments['qtyCart'];
        tabIconsList[1].isSelected = true;
        tabBody = HomeDesignCourse(
          search: arguments['keyword_product'],
        );
      } else {
        tabIconsList[0].isSelected = true;
        tabBody = MyDiaryScreen(
          animationController: animationController,
          searchAlocation: (String jenis, String search) {
            setState(() {
              tabBody = HomeDesignCourse(
                jenis: jenis,
                search: search,
              );
              tabIconsList.forEach((TabIconData tab) {
                tab.isSelected = false;
              });

              tabIconsList[1].isSelected = true;
            });
          },
          funcChangeCartQty: (int qty) {
            qtyCart = qty;

            setState(() {});
          },
        );
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    return Container(
      color: FintnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // appBar: AppBar(
        //     // Use Brightness.light for dark status bar
        //     // or Brightness.dark for light status bar
        //     brightness: Brightness.light),
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          changeParentCart: (int jmlh) {
            setState(() {
              qtyCart = jmlh;
            });
          },
          addQtyCart: qtyCart,
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (int index) {
            if (index == 0) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = MyDiaryScreen(
                    animationController: animationController,
                    searchAlocation: (String jenis, String search) {
                      setState(() {
                        tabBody = HomeDesignCourse(
                          jenis: jenis,
                          search: search,
                        );
                        tabIconsList.forEach((TabIconData tab) {
                          tab.isSelected = false;
                        });

                        tabIconsList[1].isSelected = true;
                      });
                    },
                    funcChangeCartQty: (int qty) {
                      qtyCart = qty;

                      setState(() {});
                    },
                  );
                });
              });
            } else if (index == 1) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = HomeDesignCourse(funcChangeCartQty: (int qty) {
                    qtyCart = qty;
                    // print(qty.toString());
                    setState(() {});
                  });
                });
              });
            } else if (index == 2) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  // tabBody = WishlistScreen(

                  //     animationController: animationController,
                  //     funcChangeCartQty: (int qty) {
                  //       qtyCart = qty;
                  //       setState(() {});
                  //     },

                  //     );
                  tabBody = TrainingScreen(
                    animationController: animationController,
                    funcChangeCartQty: (int qty) {
                      qtyCart = qty;
                      setState(() {});
                    },
                  );
                });
              });
            } else if (index == 3) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = MenuScreen(
                    animationController: animationController,
                    searchAlocation: (String jenis, String search) {
                      setState(() {
                        tabBody = HomeDesignCourse(
                          jenis: jenis,
                          search: search,
                        );
                        tabIconsList.forEach((TabIconData tab) {
                          tab.isSelected = false;
                        });

                        tabIconsList[1].isSelected = true;
                      });
                    },
                  );
                });
              });
            }
          },
        ),
      ],
    );
  }
}
