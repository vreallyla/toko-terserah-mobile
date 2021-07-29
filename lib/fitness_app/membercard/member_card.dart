import 'dart:convert';

import 'package:tokoterserah/Constant/Constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberCard extends StatefulWidget {
  const MemberCard({
    Key key,
    this.token,
  }) : super(key: key);

  final String token;

  @override
  _MemberCardState createState() => _MemberCardState();
}

class _MemberCardState extends State<MemberCard>
    with SingleTickerProviderStateMixin {
  String tokenFixed = '', user_code, _token, _nama, split_code;
  int user_id = 1, zero_leading = 18;

  var dataUser;

  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  _getData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('token');
      dataUser = prefs.getString('dataUser');

      dataUser = jsonDecode(dataUser);

      print(dataUser['user']);

      setState(() {
        _nama = dataUser['user']['name'];
        user_id = dataUser['user']['id'];
      });

      user_code = user_id
          .toString()
          .padLeft(zero_leading - user_id.toString().length, '0');

          split_code = user_code.replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)} ");
    } catch (e) {
      print(e);
    }
  }

  _launchMap(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    _getData();
    print(user_id
        .toString()
        .padLeft(zero_leading - user_id.toString().length, '0'));

    flutterWebviewPlugin.onUrlChanged.listen((String url) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                    Navigator.of(context).pop();
                 
                },
              ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2.8,
              color: Colors.green,
              child: Center(
                  child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.height / 2.5,
                    height: MediaQuery.of(context).size.height / 4.3,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                              AssetImage('assets/fitness_app/member_card.jpg'),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            '${split_code}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20,),
                    child: Text(_nama.toUpperCase(), style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Colors.white
                    ),),
                  ),
                ],
              )),
            ),
            Container(
              margin: EdgeInsets.only(top: 40,left: 20,right: 20),
             
              child: BarCodeImage(
                params: Code39BarCodeParams(
                  "${user_code}",
                  lineWidth:
                      1.2, // width for a single black/white bar (default: 2.0)
                  barHeight:
                      60.0, // height for the entire widget (default: 100.0)
                  withText:
                      false, // Render with text label or not (default: false)
                      
                ),
                onError: (error) {
                  // Error handler
                  print('error = $error');
                },
              ),
            ),
            Container( margin: EdgeInsets.only(top:20),
              child: Text(user_code, style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800
              ),),)
          ],
        ),
      ),
    );
    // return WebviewScaffold(
    //   url: globalBaseUrl + 'api/profile/membercard?token=' + widget.token,
    //   appBar: new AppBar(
    //     backgroundColor: Colors.grey[200],
    //     brightness: Brightness.light,
    //     leading: IconButton(
    //       icon: Icon(Icons.arrow_back_ios, color: Colors.black),
    //       onPressed: () => Navigator.of(context).pop(),
    //     ),
    //     // leading: Text(''),
    //     title: const Text(
    //       'Kartu Member',
    //       style: TextStyle(color: Colors.black),
    //     ),
    //     // actions: [
    //     //   IconButton(
    //     //       icon: FaIcon(FontAwesomeIcons.history, color: Colors.black),
    //     //       onPressed: () {
    //     //         _toProsesDashboard();
    //     //       }),

    //     //   // Icon(Icons.add),
    //     // ],
    //   ),
    //   initialChild: Container(
    //     child: const Center(
    //       child: Text('Waiting.....'),
    //     ),
    //   ),
    // );
  }
}
