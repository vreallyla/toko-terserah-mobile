import 'dart:developer';

import 'package:tokoterserah/Constant/Constant.dart';
import 'package:tokoterserah/fitness_app/bought_proccess/bought_proccess_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'package:shared_preferences/shared_preferences.dart';

class WebviewMenu extends StatefulWidget {
  const WebviewMenu({
    Key key,
    this.name,
    this.url,
    
  }) : super(key: key);

  final String name;
  final String url;

  @override
  _WebviewMenuState createState() => _WebviewMenuState();


}

class _WebviewMenuState extends State<WebviewMenu>
    with SingleTickerProviderStateMixin {

  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
   
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.url,
       appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.grey[200],
        title:  Text(
          widget.name,
          style: TextStyle(color: Colors.black),
        ),
      ),
      initialChild: Container(
        child: const Center(
          child: Text('Waiting.....'),
        ),
      ),
    );
  }
}
