import 'package:best_flutter_ui_templates/fitness_app/models/tabIcon_data.dart';
import 'package:best_flutter_ui_templates/fitness_app/traning/training_screen.dart';
import 'package:best_flutter_ui_templates/fitness_app/wishlist/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';
import 'fintness_app_theme.dart';
import 'my_diary/my_diary_screen.dart';
import 'package:best_flutter_ui_templates/design_course/home_design_course.dart';

class FitnessAppHomeScreen extends StatefulWidget {
  @override
  _FitnessAppHomeScreenState createState() => _FitnessAppHomeScreenState();
}

class _FitnessAppHomeScreenState extends State<FitnessAppHomeScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: FintnessAppTheme.background,
  );

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

      if (arguments != null ? (arguments['after_login']!=null || arguments['after_logout']!=null) : false) {
        tabIconsList[3].isSelected = true;
        tabBody = TrainingScreen(animationController: animationController);
      } else if (arguments != null ? arguments['search_product']!=null : false) {
        arguments['search_product'] = null;
        
        tabIconsList[1].isSelected = true;
        tabBody = DesignCourseHomeScreen(
          search: arguments['keyword_product'],
        );
      } else {
        tabIconsList[0].isSelected = true;
        tabBody=MyDiaryScreen(animationController: animationController,
                      searchAlocation:(String jenis,String search){
                        setState(() {
                        tabBody =DesignCourseHomeScreen(jenis: jenis,search: search,);
                         tabIconsList.forEach((TabIconData tab) {
                            tab.isSelected = false;
                          });

                          tabIconsList[1].isSelected=true;
                          
                        });
                      }
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
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (int index) {
            if (index == 0) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      MyDiaryScreen(animationController: animationController,
                      searchAlocation:(String jenis,String search){
                        setState(() {
                        tabBody =DesignCourseHomeScreen(jenis: jenis,search: search,);
                         tabIconsList.forEach((TabIconData tab) {
                            tab.isSelected = false;
                          });

                          tabIconsList[1].isSelected=true;
                          
                        });
                      }
                      );
                });
              });
            } else if (index == 1) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = DesignCourseHomeScreen();
                });
              });
            } else if (index == 2) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      WishlistScreen(animationController: animationController);
                });
              });
            } else if (index == 3) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      TrainingScreen(animationController: animationController);
                });
              });
            }
          },
        ),
      ],
    );
  }
}
