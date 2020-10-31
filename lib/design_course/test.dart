import 'package:best_flutter_ui_templates/Constant/Constant.dart';
import 'package:best_flutter_ui_templates/fitness_app/bought_proccess/bought_proccess_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

  params() {
    String paramss = '';

    paramss = paramss + '?pengiriman_id=' + widget.pengirimanId;
    paramss = paramss + '&penagihan_id=' + widget.penagihanId;
    paramss = paramss + '&ongkir=' + widget.ongkir;
    paramss = paramss + '&discount_price=' + widget.discountPrice;
    paramss = paramss + '&cart_ids=' + widget.cartIds;
    paramss = paramss + '&total=' + widget.total;
    paramss = paramss + '&snap_token=' + widget.snapToken;

    paramss = paramss + '&weight=' + widget.weight;
    paramss = paramss + '&note=' + widget.note;
    paramss = paramss + '&durasi_pengiriman=' + widget.durasiPengiriman;
    paramss = paramss + '&promo_code=' + widget.promoCode;
    paramss = paramss + '&opsi=' + widget.opsi;
    paramss = paramss + '&kode_kurir=' + widget.kodeKurir;
    paramss = paramss + '&layanan_kurir=' + widget.layananKurir;
    paramss = paramss + '&token=' + widget.token;

    return paramss;
  }

  @override
  void initState() {
    _getToken();
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      print(url);
      if (url.indexOf('checkout/midtrans/success') > -1) {
        
        _toProsesDashboard();
      }
    });
    super.initState();
  }

  _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    tokenFixed = prefs.getString('token');
    //  prefs.getString('token');
  }

  _toProsesDashboard() async {
    flutterWebviewPlugin.hide();
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BoughtProccessScreen(
                index: 0,
              )),
    );
    flutterWebviewPlugin.show();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: globalBaseUrl + 'api/checkout/midtrans/snap-webview' + params(),
      appBar: new AppBar(
        backgroundColor: Colors.grey[200],
        brightness: Brightness.light,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
