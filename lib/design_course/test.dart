import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TestWebView extends StatefulWidget {
  @override
  _TestWebViewState createState() => _TestWebViewState();
}

class _TestWebViewState extends State<TestWebView> {
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: 'https://tokoterserah.com/api/midtrans/snap-webview?snap_token=2bd25f92-a0a3-4c7b-92cf-67ff49e273c7',
      appBar: new AppBar(
         backgroundColor: Colors.grey[200],
        brightness: Brightness.light,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Pembayaran', style: TextStyle(color: Colors.black),),
      ),
      initialChild: Container(
        child: const Center(
          child: Text('Waiting.....'),
        ),
      ),
    );
  }
}
