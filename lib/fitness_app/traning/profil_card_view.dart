import 'package:best_flutter_ui_templates/fitness_app/models/meals_list_data.dart';
//import 'package:best_flutter_ui_templates/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//import '../../main.dart';

class ProfilCardView extends StatefulWidget {
  const ProfilCardView(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController mainScreenAnimationController;
  final Animation<dynamic> mainScreenAnimation;

  @override
  _ProfilCardViewState createState() => _ProfilCardViewState();
}

class _ProfilCardViewState extends State<ProfilCardView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  List<MealsListData> mealsListData = MealsListData.tabIconsList;

  String nama,ava,bgPhoto,tglDaftar,tglUpdate;

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
    double colProgress = (sizeu.width - 20) / 4;

    return Container(
      height: 200,
      decoration: BoxDecoration(
        // borderRadius: const BorderRadius.only(
        //   bottomRight: Radius.circular(20),
        //   bottomLeft: Radius.circular(20),
        //   topLeft: Radius.circular(0),
        //   topRight: Radius.circular(0),
        // ),
        color: Colors.white,
      ),
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/profile_detail');
            },
            child: Stack(
              children: <Widget>[
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/fitness_app/bg_users.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
                ),
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      gradient: LinearGradient(
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.2),
                            Colors.black.withOpacity(.6),
                          ],
                          stops: [
                            0.0,
                            1.0
                          ])),
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
                ),
                Container(
                  height: 140,
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                                AssetImage('assets/fitness_app/user-default.png'),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(
                            color: Colors.green[200],
                            width: 3.0,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(50),
                            bottomLeft: Radius.circular(50),
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: sizeu.width - 70 - 10 - 40,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Text(
                                'Fahmi Rizky Maulidy',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(0, .0),
                                      blurRadius: 3.0,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                                maxLines: 2,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                                  margin: EdgeInsets.only(bottom: 5),
                                  // width: 118,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    color: Colors.black54,
                                  ),
                                  child: Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.solidCalendarCheck,
                                        size: 13,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        ' 20 Sep 2020',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                        maxLines: 3,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                                  margin: EdgeInsets.only(bottom: 5, left: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    color: Colors.black54,
                                  ),
                                  child: Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.solidClock,
                                        size: 13,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        ' 12 minggu lalu',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                        maxLines: 3,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 0.5, color: Colors.black26),
              ),
              color: Colors.white,
            ),
            child: Row(children: [
              cardIconProgress(
                  colProgress,
                  'Belum Bayar',
                  FaIcon(
                    FontAwesomeIcons.wallet,
                    color: Colors.grey,
                    size: 18,
                  ),
                  false),
              cardIconProgress(
                  colProgress,
                  'Dikemas',
                  FaIcon(
                    FontAwesomeIcons.gift,
                    color: Colors.grey,
                    size: 18,
                  ),
                  true),
              cardIconProgress(
                  colProgress,
                  'Dikirim',
                  FaIcon(
                    FontAwesomeIcons.shippingFast,
                    color: Colors.grey,
                    size: 18,
                  ),
                  false),
              cardIconProgress(
                  colProgress,
                  'Beri Ranting',
                  FaIcon(
                    FontAwesomeIcons.solidStar,
                    color: Colors.grey,
                    size: 18,
                  ),
                  true),
            ]),
          ),
        ],
      ),
    );
  }

  Widget cardIconProgress(
      double colProgress, String judul, Widget iconn, bool dataAvail) {
    List layer = <Widget>[];

    layer.add(
      Container(
        width: colProgress,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconn,
            Container(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                judul,
                style: TextStyle(
                  fontSize: 11.5,
                  color: Colors.black54,
                ),
              ),
            )
          ],
        ),
      ),
    );

    if (dataAvail) {
      layer.add(Container(
          margin: EdgeInsets.only(left: colProgress - (colProgress / 2.15)),
          width: 11,
          height: 11,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green.withOpacity(.9),
          )));
    }
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/proses_beli');
      },
      child: Stack(
        children: layer,
      ),
    );
  }
}
