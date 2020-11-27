import 'package:tokoterserah/design_course/models/category.dart';
import 'package:flutter/material.dart';

class PopularCourseListView extends StatefulWidget {
  const PopularCourseListView({Key key, this.callBack}) : super(key: key);

  final Function callBack;
  @override
  _PopularCourseListViewState createState() => _PopularCourseListViewState();
}

class _PopularCourseListViewState extends State<PopularCourseListView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return GridView(
              padding: const EdgeInsets.all(1),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: List<Widget>.generate(
                4,
                (int index) {
                  final int count = 20;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animationController,
                      curve: Interval((1 / count) * 1, 1.0,
                          curve: Curves.fastOutSlowIn),
                    ),
                  );
                  animationController.forward();
                  return CategoryView(
                    callback: () {
                      widget.callBack();
                    },
                    category: Category.popularCourseList[1],
                    animation: animation,
                    animationController: animationController,
                  );
                },
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0,
                childAspectRatio: 0.5,
              ),
            );
          }
        },
      ),
    );
  }
}

class CategoryView extends StatelessWidget {
  const CategoryView(
      {Key key,
      this.category,
      this.animationController,
      this.animation,
      this.callback})
      : super(key: key);

  final VoidCallback callback;
  final Category category;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                callback();
              },
              child: SizedBox(
                width: sizeu.width / 3,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 1, left: 1, right: 5, bottom: 1),
                      child: InkWell(
                        onTap: () {
                          // Navigate to the second screen using a named route.
                          Navigator.pushNamed(context, '/produk');
                        },
                        child: Column(
                          children: [
                            //rubah gambar
                            Container(
                              height: sizeu.width / 2,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(0),
                                  bottomLeft: Radius.circular(0),
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                ),
                              ),
                            ),

                            //konten
                            Container(
                              padding: EdgeInsets.fromLTRB(5, 8, 5, 8),
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(0),
                                  topRight: Radius.circular(0),
                                  bottomRight: Radius.circular(8.0),
                                  bottomLeft: Radius.circular(8.0),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      strutStyle: StrutStyle(fontSize: 12.0),
                                      text: TextSpan(
                                          style: TextStyle(color: Colors.black),
                                          text:
                                              'A very long texta as as asas :)'),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 5),
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Rp 15.000.000,-',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                    ),
                                  ),
                                  starJadi(3.5, '1.000'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          top: 5, left: 5, right: 5, bottom: 16),
                      alignment: Alignment.topLeft,
                      child: Card(
                        color: Colors.green[100],
                        child: Container(
                            margin: EdgeInsets.all(3),
                            child: Text(
                              'Grosir',
                              style: TextStyle(
                                color: Colors.green[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            )),
                      ),
                    ),
                    // Positioned(
                    //   top: 0,
                    //   left: 0,
                    //   child: Container(
                    //     width: 84,
                    //     height: 84,
                    //     decoration: BoxDecoration(
                    //       color: FintnessAppTheme.nearlyWhite.withOpacity(0.2),
                    //       shape: BoxShape.circle,
                    //     ),
                    //   ),
                    // ),
                    // Positioned(
                    //   top: 0,
                    //   left: 8,
                    //   child: SizedBox(
                    //     width: 80,
                    //     height: 80,
                    //     // child: Image.asset(mealsListData.imagePath),
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Icon iconStar() {
    return Icon(
      Icons.star,
      color: Colors.green,
      size: 12,
    );
  }

  Icon iconStarSetengah() {
    return Icon(
      Icons.star_half,
      color: Colors.green,
      size: 12,
    );
  }

  Icon iconStarKosong() {
    return Icon(
      Icons.star_border,
      color: Colors.lightGreen,
      size: 12,
    );
  }

  Container starJadi(double jmlStar, String jlmVote) {
    List dataRown = <Widget>[];

    List.generate(5, (index) {
      dataRown.add(
        Container(
            child: (index + 1) <= jmlStar
                ? iconStar()
                : (index < jmlStar ? iconStarSetengah() : iconStarKosong())),
      );
    });

    dataRown.add(Text(' ($jlmVote)',
        style: TextStyle(fontSize: 12, color: Colors.grey)));

    return Container(
        padding: EdgeInsets.only(top: 3), child: Row(children: dataRown));
  }
}
