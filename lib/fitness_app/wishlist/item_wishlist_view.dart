import 'package:best_flutter_ui_templates/fitness_app/models/meals_list_data.dart';
//import 'package:best_flutter_ui_templates/main.dart';
import 'package:flutter/material.dart';

//import '../../main.dart';

class ItemWishlistView extends StatefulWidget {
  const ItemWishlistView(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation,this.countWishlist, this.dataWishlist})
      : super(key: key);

  final AnimationController mainScreenAnimationController;
  final Animation<dynamic> mainScreenAnimation;
  final int countWishlist;
  final List dataWishlist;

  @override
  _ItemWishlistViewState createState() => _ItemWishlistViewState();
}

class _ItemWishlistViewState extends State<ItemWishlistView>
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

    // print(widget.dataWishlist[0]['nama']);
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
              height: sizeu.height - 270,
              width: double.infinity,
              child: ListView.builder(
                padding:
                    const EdgeInsets.only(top: 0, bottom: 0, right: 0, left: 0),
                itemCount: widget.countWishlist,
                scrollDirection: Axis.vertical,
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
                        top: 0, left: 10, right: 10, bottom: 15),
                    child: InkWell(
                      onTap: () {
                        // Navigate to the second screen using a named route.
                        Navigator.pushNamed(context, '/produk');
                      },
                      child:
                          //rubah gambar
                          Container(
                        height: sizeu.width / 2 -
                            sizeu.width / 15 +
                            sizeu.width / 3 / 3,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                          boxShadow: [
                            //background color of box
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 0.5, // soften the shadow
                              spreadRadius: .5, //extend the shadow
                              offset: Offset(
                                .5, // Move to right 10  horizontally
                                .5, // Move to bottom 10 Vertically
                              ),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: sizeu.width / 4,
                                    width: sizeu.width / 4,
                                    decoration: BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: const BorderRadius.only(
                                        bottomRight: Radius.circular(8.0),
                                        bottomLeft: Radius.circular(8.0),
                                        topLeft: Radius.circular(8.0),
                                        topRight: Radius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height:
                                        sizeu.width / 4 + sizeu.width / 3 / 3,
                                    padding: EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.topLeft,
                                          width: sizeu.width -
                                              50 -
                                              sizeu.width / 4 -
                                              10,
                                          child: Text(
                                            'Ini Nama Barangnya tinggal diisi disini gak apa-apa kok :)',
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        Card(
                                          color: Colors.green[100],
                                          child: Container(
                                              margin: EdgeInsets.all(2),
                                              child: Text(
                                                'Grosir',
                                                style: TextStyle(
                                                  color: Colors.green[800],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                              )),
                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          width: sizeu.width -
                                              50 -
                                              sizeu.width / 4 -
                                              10,
                                          child: Text(
                                            'Rp 40.000,-',
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Card(
                                              color: Colors.red[100],
                                              child: Container(
                                                  margin: EdgeInsets.all(2),
                                                  child: Text(
                                                    '-10%',
                                                    style: TextStyle(
                                                      color: Colors.red[800],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  )),
                                            ),
                                            Text(
                                              'Rp50.000,00',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        ),
                                        starJadi(
                                            4,
                                            '1.000',
                                            sizeu.width -
                                                50 -
                                                sizeu.width / 4 -
                                                10),
                                      ],
                                    ),
                                  ),
                                ]),
                            Container(
                              height: sizeu.width / 2 -
                                  sizeu.width / 15 -
                                  30 -
                                  sizeu.width / 4,
                              // color: Colors.red,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    color: Colors.white,
                                      width: sizeu.width - 50 - 80,
                                      child: RaisedButton(
                                        onPressed: (){},
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: Text('Masukkan Keranjang',style: TextStyle(color: Colors.white),),
                                        color: Colors.green,
                                      )),
                                      Container(
                                      width: 80,
                                      padding: EdgeInsets.only(left: 5),
                                      color: Colors.white,
                                      child: RaisedButton(
                                        onPressed: (){},
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(color: Colors.black12),
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        color: Colors.red[400],
                                        child: Icon(Icons.delete, color: Colors.white,),
                                      )),
                                  
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
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
      size: 13,
    );
  }

  Icon iconStarSetengah() {
    return Icon(
      Icons.star_half,
      color: Colors.green,
      size: 13,
    );
  }

  Icon iconStarKosong() {
    return Icon(
      Icons.star_border,
      color: Colors.lightGreen,
      size: 13,
    );
  }

  Container starJadi(double jmlStar, String jlmVote, double wit) {
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
        style: TextStyle(fontSize: 13, color: Colors.grey)));

    return Container(width: wit, child: Row(children: dataRown));
  }
}
