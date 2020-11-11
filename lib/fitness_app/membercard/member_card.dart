import 'dart:developer';

import 'package:best_flutter_ui_templates/Constant/Constant.dart';
import 'package:best_flutter_ui_templates/fitness_app/bought_proccess/bought_proccess_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  String tokenFixed = '';
  final flutterWebviewPlugin = new FlutterWebviewPlugin();


  @override
  void initState() {

    flutterWebviewPlugin.onUrlChanged.listen((String url) {
    
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: globalBaseUrl + 'api/profile/membercard?token=' + widget.token,
      appBar: new AppBar(
        backgroundColor: Colors.grey[200],
        brightness: Brightness.light,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // leading: Text(''),
        title: const Text(
          'Kartu Member',
          style: TextStyle(color: Colors.black),
        ),
        // actions: [
        //   IconButton(
        //       icon: FaIcon(FontAwesomeIcons.history, color: Colors.black),
        //       onPressed: () {
        //         _toProsesDashboard();
        //       }),

        //   // Icon(Icons.add),
        // ],
      ),
      initialChild: Container(
        child: const Center(
          child: Text('Waiting.....'),
        ),
      ),
    );
  }
}
