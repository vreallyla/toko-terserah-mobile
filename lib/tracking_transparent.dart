import 'package:flutter/material.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/services.dart';
import 'package:tokoterserah/app_theme.dart';

class TrackingTransparent extends StatefulWidget {
  @override
  _TrackingTransparentState createState() => _TrackingTransparentState();
}

class _TrackingTransparentState extends State<TrackingTransparent> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    Future<void> initPlugin() async {
      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        final TrackingStatus status =
            await AppTrackingTransparency.trackingAuthorizationStatus;

        // If the system can show an authorization request dialog
        if (status == TrackingStatus.notDetermined) {
          // Show a custom explainer dialog before the system dialog

          // Wait for dialog popping animation
          await Future.delayed(const Duration(milliseconds: 200));
          // Request system's tracking authorization dialog
          final TrackingStatus status =
              await AppTrackingTransparency.requestTrackingAuthorization();
        }
      } on PlatformException {
        print('error tracking transparent');
      }

      final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
      print("UUID: $uuid");
          await Future.delayed(const Duration(milliseconds: 200));

              await AppTrackingTransparency.requestTrackingAuthorization();

      print(await AppTrackingTransparency.trackingAuthorizationStatus);
      Navigator.of(context).pushReplacementNamed('/home');
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
            width: width,
            height: height,
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          "assets/fitness_app/splash-logo-black.png",
                          width: width / 1.8,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                        child: Text(
                          'Selamat Datang Pengunjung',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 20),
                        width: width - 44,
                        child: Text(
                          'Kedatangan anda membuat semangat kami makin bekerja. Ketika melanjutkan aplikasi kami harap anda mengijinkan akses "Tracker Activity" dan untuk data yang kami akses dapat dilihat di "Kebijakan Privasi"',
                          textAlign: TextAlign.center,
                          
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                  width: width - 44,
                  child: RaisedButton(
                    onPressed: () => initPlugin(),
                    color: Colors.green,
                    child: Text(
                      'LANJUTKAN',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 40,
                  width: width - 44,
                  child: RaisedButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/privacy'),
                    color: Colors.white70,
                    child: Text(
                      'KEBIJAKAN PRIVASI',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
