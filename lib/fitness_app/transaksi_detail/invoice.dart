import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:tokoterserah/Constant/Constant.dart';

class Invoice extends StatefulWidget {
  const Invoice({Key key, this.code}) : super(key: key);

  final String code;
  @override
  _InvoiceState createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  String _token;

  bool isLoading = true;

  PDFDocument document;

  _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('token');

    print(_token);
  }

  loadDocument() async {
    document = await PDFDocument.fromURL(
      widget.code, 
    );

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    // TODO: implement initState
    _getToken();
    Future.delayed(Duration(milliseconds: 50), () {
      loadDocument();
    });
    print(widget.code);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.grey[200],
        title: const Text(
          'Invoice',
          style: TextStyle(color: Colors.black),
        ),
      ),
        body: isLoading ? reqLoad() :
        PDFViewer(
          document: document,
          zoomSteps: 1,
        ),
    );
  }
}
