import 'package:best_flutter_ui_templates/fitness_app/models/meals_list_data.dart';
//import 'package:best_flutter_ui_templates/main.dart';
import 'package:flutter/material.dart';

//import '../../main.dart';

class ItemSquareView extends StatefulWidget {
  const ItemSquareView(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController mainScreenAnimationController;
  final Animation<dynamic> mainScreenAnimation;

  @override
  _ItemSquareViewState createState() => _ItemSquareViewState();
}

class _ItemSquareViewState extends State<ItemSquareView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  List<MealsListData> mealsListData = MealsListData.tabIconsList;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
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
    final sizeu = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 20 * (1.0 - widget.mainScreenAnimation.value), 0.0),
            child: Container(
              height: sizeu.width / 3 + (sizeu.width / 3 / 3) + 150,
              width: double.infinity,
              child: ListView.builder(
                padding:
                    const EdgeInsets.only(top: 0, bottom: 0, right: 0, left: 0),
                itemCount: 6,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final int count =
                      mealsListData.length > 10 ? 10 : mealsListData.length;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn)));
                  animationController.forward();

                  return MealsView(
                    mealsListData: mealsListData[0],
                    animation: animation,
                    animationController: animationController,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class MealsView extends StatelessWidget {
  const MealsView(
      {Key key, this.mealsListData, this.animationController, this.animation})
      : super(key: key);

  final MealsListData mealsListData;
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
                0 * (1.0 - animation.value), 0.0, 0.0),
            child: SizedBox(
              width: sizeu.width / 3,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 32, left: 1, right: 5, bottom: 16),
                    child: InkWell(
                      onTap: () {
                        // Navigate to the second screen using a named route.
                        Navigator.pushNamed(context, '/produk');
                      },
                      child: Column(
                        children: [
                          //rubah gambar
                          Container(
                            height: sizeu.width / 3,
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
                                  child: Text(
                                    'Judulnya apa Judulnya apa Judulnya apa',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    maxLines: 2,
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
                        top: 35, left: 5, right: 5, bottom: 16),
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
