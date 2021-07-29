import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;

  String _authStatus = 'Unknown';
  String linkTo = '/home';

  AnimationController animationController;
  Animation<double> animation;

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    // Navigator.of(context).pushReplacementNamed(PAY_TM);

    Navigator.of(context).pushReplacementNamed(linkTo);
  }

  @override
  void initState() {
    super.initState();
    // Can't show a dialog in initState, delaying initialization
    WidgetsBinding.instance.addPostFrameCallback((_) => initPlugin());
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 3),
    );
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  Future<void> initPlugin() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final TrackingStatus status =
          await AppTrackingTransparency.trackingAuthorizationStatus;
      setState(() => _authStatus = '$status');
      if (status == TrackingStatus.notDetermined 
      &&
          status != TrackingStatus.notSupported
          ) {

            setState(() {
              linkTo='/tracking_transparent';
            });
          }
    } on PlatformException {
      setState(() => _authStatus = 'PlatformException was thrown');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/fitness_app/splash-bg.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              // new Column(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   mainAxisSize: MainAxisSize.min,
              //   children: <Widget>[
              //     Padding(
              //       padding: EdgeInsets.only(bottom: 30.0),
              //       child: Text("PT. PENTA SURYA PRATAMA",style: TextStyle(
              //         color: Colors.white
              //       ),),
              //     )
              //   ],
              // ),
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Image.asset(
                    "assets/fitness_app/splash-logo-black.png",
                    width: animation.value * 280,
                    height: animation.value * 280,
                    fit: BoxFit.fitHeight,
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
