import 'package:flutter/material.dart';

import '../fintness_app_theme.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;
  @override
  _TrainingScreenState createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

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

  void addAllListData() {
    listViews.add(Container(
      height: 160,
      decoration: BoxDecoration(
        // borderRadius: const BorderRadius.only(
        //   bottomRight: Radius.circular(20),
        //   bottomLeft: Radius.circular(20),
        //   topLeft: Radius.circular(0),
        //   topRight: Radius.circular(0),
        // ),
        color: Colors.green[700],
      ),
      padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
      margin: EdgeInsets.only(bottom: 30),
      child: Column(children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: 15),
          child: Text(
            'Mari bergabung dengan kami dan temukan kemudahannya...',
            style: TextStyle(color: Colors.white, fontSize: 15),
            textAlign: TextAlign.justify,
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(right: 5),
                  child: RaisedButton(
                    padding: EdgeInsets.all(10),
                    onPressed: () {
                       Navigator.pushNamed(context, '/login');
                    },
                    color: Colors.white,
                    child: Text(
                      'Masuk',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ),
                )),
            Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(left: 5),
                  child: RaisedButton(
                    padding: EdgeInsets.all(10),
                    onPressed: () {},
                    color: Colors.green,
                    child: Text(
                      'Daftar',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                )),
          ],
        )
      ]),
    ));

    listViews.add(Container(
      height: 70,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
      child: Row(
        children: <Widget>[
          Icon(Icons.phone, color: Colors.grey),
          Container(
              padding: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Hubungi Kami',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                  Text('Hubungi langsung tim kami',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      )),
                ],
              ))
        ],
      ),
    ));

    listViews.add(Container(
      height: 70,
      decoration: borderTop(),
      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
      child: Row(
        children: <Widget>[
          Icon(Icons.library_books, color: Colors.grey),
          Container(
              padding: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Syarat & Ketentuan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ))
        ],
      ),
    ));

    listViews.add(Container(
      height: 70,
      decoration: borderTop(),
      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
      child: Row(
        children: <Widget>[
          Icon(Icons.lock_outline, color: Colors.grey),
          Container(
              padding: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Kebijakan Privasi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ))
        ],
      ),
    ));

    // listViews.add(
    //   TitleView(
    //     titleTxt: 'Your program',
    //     subTxt: 'Details',
    //     animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //         parent: widget.animationController,
    //         curve:
    //             Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
    //     animationController: widget.animationController,
    //   ),
    // );
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
                      bottomLeft: Radius.circular(32.0),
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
                                  'Data Akun',
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
