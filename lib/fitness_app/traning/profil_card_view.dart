import 'dart:convert';
import 'dart:core';

import 'package:tokoterserah/Constant/Constant.dart';
import 'package:tokoterserah/Constant/MathModify.dart';
import 'package:tokoterserah/fitness_app/bought_proccess/bought_proccess_screen.dart';
import 'package:tokoterserah/fitness_app/models/meals_list_data.dart';
//import 'package:tokoterserah/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

// image load
//import 'package:progressive_image/progressive_image.dart';

//import '../../main.dart';

class ProfilCardView extends StatefulWidget {
  const ProfilCardView(
      {Key key, this.loadData,this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController mainScreenAnimationController;
  final Function loadData;
  final Animation<dynamic> mainScreenAnimation;

  @override
  _ProfilCardViewState createState() => _ProfilCardViewState();
}

class _ProfilCardViewState extends State<ProfilCardView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  List<MealsListData> mealsListData = MealsListData.tabIconsList;

  String nama, ava, bgPhoto;
  DateTime tglDaftar, tglUpdate;
  var dataUser;
  String diff;

  //callback jumlah cart
  _checkAkun() async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final resultDetail = await Navigator.pushNamed(context, '/profile_detail');
   print('hell');

   widget.loadData();
  }

  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    dataUser = prefs.getString('dataUser');
    

    print(prefs.getKeys());
    if (dataUser != null) {
      dataUser = await jsonDecode(dataUser);
      var dataUserDefault = dataUser['user'];
      nama = dataUserDefault['name'];
      ava = dataUserDefault['get_bio']['ava'];
      // print(dataUserDefault['get_bio']);
      // print('asd');
      bgPhoto = dataUserDefault['get_bio']['background'];
      tglDaftar = DateTime.parse(dataUserDefault['created_at']);
      tglUpdate = DateTime.parse(dataUserDefault['updated_at']);
    }

    //the birthday's date

    // await initializeDateFormatting('id', null).then((value) {

    // }
    // );

    setState(() {});
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    _getUser();

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
    initializeDateFormatting('id', null);
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
              _checkAkun();
            },
            child: Stack(
              children: <Widget>[
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: (bgPhoto != null
                          ? NetworkImage(
                              globalBaseUrl + locationBgPhoto + bgPhoto)
                          : AssetImage('assets/fitness_app/bg_users.jpg')),
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
                            image: (ava != null
                                ? NetworkImage(
                                    globalBaseUrl + locationAva + ava)
                                : AssetImage(
                                    'assets/fitness_app/user-default.png')),
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
                                (nama != null ? nama : 'Anonim'),
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
                                        ' ' +
                                            (tglDaftar != null
                                                ? new DateFormat(
                                                        "d MMM yyyy", 'id')
                                                    .format(tglUpdate)
                                                : 'Belum diatur'),
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
                                        ' ' +
                                            (tglUpdate != null
                                                ? diffForhumans(tglUpdate)
                                                : 'Belum diatur'),
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
                0,
                  colProgress,
                  'Belum Bayar',
                  FaIcon(
                    FontAwesomeIcons.wallet,
                    color: Colors.grey,
                    size: 18,
                  ),
                  false),
              cardIconProgress(
                1,
                  colProgress,
                  'Dikemas',
                  FaIcon(
                    FontAwesomeIcons.gift,
                    color: Colors.grey,
                    size: 18,
                  ),
                  true),
              cardIconProgress(
                2,
                  colProgress,
                  'Dikirim',
                  FaIcon(
                    FontAwesomeIcons.shippingFast,
                    color: Colors.grey,
                    size: 18,
                  ),
                  false),
              cardIconProgress(
                3,
                  colProgress,
                  'Selesai',
                  FaIcon(
                    FontAwesomeIcons.solidHandshake,
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
    int index,
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

    List setDataCount=['belum_bayar','dikemas_diambil','dikirim','selesai'];


    if (dataUser!=null?dataUser['count_status'][setDataCount[index]]>0:false) {
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => BoughtProccessScreen(index: index,)),);
      },
      child: Stack(
        children: layer,
      ),
    );
  }
}
