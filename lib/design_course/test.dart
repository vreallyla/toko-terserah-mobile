import 'dart:developer';

import 'package:tokoterserah/Constant/Constant.dart';
import 'package:tokoterserah/fitness_app/bought_proccess/bought_proccess_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestWebView extends StatefulWidget {
  const TestWebView({
    Key key,
    this.pengirimanId,
    this.penagihanId,
    this.token,
    this.cartIds,
    this.discountPrice,
    this.ongkir,
    this.total,
    this.snapToken,
    this.weight,
    this.note,
    this.durasiPengiriman,
    this.promoCode,
    this.opsi,
    this.kodeKurir,
    this.layananKurir,
    this.namaKurir,
    this.packing,
  }) : super(key: key);

  final String pengirimanId;
  final String penagihanId;
  final String cartIds;
  final String discountPrice;
  final String ongkir;
  final String total;
  final String snapToken;
  final String weight;
  final String note;
  final String durasiPengiriman;
  final String promoCode;
  final String opsi;
  final String kodeKurir;
  final String layananKurir;
  final String token;
  final String namaKurir;
  final String packing;
  @override
  _TestWebViewState createState() => _TestWebViewState();

  // "pengirimanId": 1,
  // "penagihanId": 1,
  // "cart_ids": "56,58,59",
  // "discount_price": null,
  // "ongkir": 10000,
  // "total": 50000,

  // "snap_token": "2bd25f92-a0a3-4c7b-92cf-67ff49e273c7",
  // "weight": "0.75",
  // "note": "gak pake lama",
  // "durasi_pengiriman": "2-3",
  // "promo_code": null,
  // "opsi": "logistik",
  // "kode_kurir": "jne",
  // "layanan_kurir": "CTC"
}

class _TestWebViewState extends State<TestWebView>
    with SingleTickerProviderStateMixin {
  String tokenFixed = '';
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  String paramsa = '';

  params() {
    String paramss = '';

    paramss = paramss + '?pengiriman_id=' + widget.pengirimanId;
    paramss = paramss + '&penagihan_id=' + widget.penagihanId;
    paramss = paramss + '&ongkir=' + widget.ongkir;
    paramss = paramss + '&discount_price=' + widget.discountPrice;
    paramss = paramss + '&cart_ids=' + widget.cartIds;
    paramss = paramss + '&total=' + widget.total;
    paramss = paramss + '&snap_token=' + widget.snapToken;
    // log(widget.weight);
    paramss = paramss + '&weight=' + widget.weight;
    paramss = paramss + '&note=' + widget.note;
    paramss = paramss + '&durasi_pengiriman=' + widget.durasiPengiriman;
    paramss = paramss + '&promo_code=' + widget.promoCode;
    paramss = paramss + '&opsi=' + widget.opsi;
    paramss = paramss + '&kode_kurir=' + widget.kodeKurir;
    paramss = paramss + '&layanan_kurir=' + widget.layananKurir;
    paramss = paramss + '&token=' + widget.token;
    paramss = paramss + '&nama_kurir=' + widget.namaKurir;
    paramss = paramss + '&packing=' + widget.packing;

    setState(() {
      paramsa = paramss;
    });
  }

  // ignore: prefer_collection_literals
  final Set<JavascriptChannel> jsChannels = [
    JavascriptChannel(
        name: 'Print',
        onMessageReceived: (JavascriptMessage message) {
          print(message.message);
        }),
  ].toSet();

  @override
  void initState() {
    params();
    // log(globalBaseUrl + 'api/checkout/midtrans/snap-webview' + paramsa);

    _getToken();
    flutterWebviewPlugin.onUrlChanged.listen((String url) async {
      // log(url);
      if (url.indexOf('checkout/midtrans/success') > -1) {
        _toProsesDashboard();
      } else if (url.startsWith("gojek")) { 
        //open Gojek App
        await flutterWebviewPlugin.stopLoading();
        await flutterWebviewPlugin.goBack();
        if (await canLaunch(url)) {
          await launch(url);
          return;
        }
        print("couldn't launch deeplink $url");
      }
    });

    // print( params());

    super.initState();
  }

  _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    tokenFixed = prefs.getString('token');
    //  prefs.getString('token');
  }

  _toProsesDashboard() {
    flutterWebviewPlugin.close();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => BoughtProccessScreen(
                  index: 0,
                  backCart: true,
                )));
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => BoughtProccessScreen(
    //             index: 0,
    //             backCart:true,
    //           )),
    // );
    // flutterWebviewPlugin.show();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: Uri.encodeFull(
          globalBaseUrl + 'api/checkout/midtrans/snap-webview' + paramsa),
      javascriptChannels: jsChannels,
      // url: 'https://google.com',
      withLocalStorage: true,

      appBar: new AppBar(
        backgroundColor: Colors.grey[200],
        brightness: Brightness.light,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // leading: Text(''),
        title: const Text(
          'Pembayaran',
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
