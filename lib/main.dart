import 'dart:io';
import 'package:best_flutter_ui_templates/app_theme.dart';
import 'package:best_flutter_ui_templates/fitness_app/produk_detail/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'fitness_app/fitness_app_home_screen.dart';
import 'fitness_app/produk_detail/product_detail.dart';
import 'fitness_app/produk_detail/pertanyaan_detail.dart';
import 'fitness_app/produk_detail/product_detail2.dart';
import 'fitness_app/produk_detail/ulasan_detail.dart';
import 'fitness_app/produk_detail/gambarulasan.dart';
import 'fitness_app/cart_list/cart_list.dart';
import 'fitness_app/check_out/checkout.dart';
import 'fitness_app/register/register_screen_ii.dart';
import 'fitness_app/voucher_kupon/voucher_kupon_screen.dart';
import 'fitness_app/login/login_screen.dart';
import 'fitness_app/register/register_screen_i.dart';
import 'fitness_app/produk_detail/galleryitem.dart';
import 'fitness_app/bought_proccess/bought_proccess_screen.dart';
import 'fitness_app/transaksi_detail/transaksi_detail_screen.dart';
import 'fitness_app/profil_detail/profile_detail_screen.dart';
import 'fitness_app/traning/alamat_list.dart';
import 'fitness_app/traning/input_alamat.dart';
import 'fitness_app/traning/privacy.dart';
import 'fitness_app/traning/ketentuan.dart';
import 'SplashScreen.dart';
import 'dart:async';

import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'dart:developer';
import 'dart:core';
import 'dart:convert';

import 'model/login_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription _sub;
  Uri _uri;
  String _email;
  // Future<Null> initUniLinks() async {
  //   // ... check initialUri
  //  log("get Link From URL2");
  //   // Attach a listener to the stream
  //   _sub = getUriLinksStream().listen((Uri uri) {
  //     // Use the uri and warn the user, if it is not correct
  //     print(uri);
  //     print("get Link From URL3");
  //   }, onError: (err) {
  //     // Handle exception by warning the user their action did not succeed
  //     log(err.toString());
  //   });

  //   // NOTE: Don't forget to call _sub.cancel() in dispose()
  // }

  Future<Null> initUniLinks() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      String initialLink = await getInitialLink();
      // print(initialLink ?? "Kosong");
      if (initialLink != null) {
        _uri = Uri.parse(initialLink);
        print(Uri.parse(initialLink).queryParameters['email']);
        _email = Uri.parse(initialLink).queryParameters['email'].toString();
        Future.delayed(Duration(seconds: 1), () {
          LoginModel.loginEmail(_email).then((value) {
            // emailInput.text = value.error.toString();
            if (!value.error) {
              Navigator.pop(context,jsonEncode({"load":true}));
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/home', (Route<dynamic> route) => false,
                  arguments: {"after_login": true});
            } else {}

            setState(() {});
          });
        });
      }
      // Parse the link and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
    } on PlatformException {
      // Handle exception by warning the user their action did not succeed
      // return?
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    log("get Link From URL1");
    initUniLinks();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/home': (context) => FitnessAppHomeScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/produk': (context) => ProductDetail(),
        '/produk2': (context) => ProductDetail2(),
        '/cart_list': (context) => CartList(),
        '/voucher_kupon': (context) => VoucherKuponScreen(),
        '/login': (context) => LoginScreen(),
        '/checkout': (context) => CheckOut(),
        '/register': (context) => RegisterScreenI(),
        '/register_ii': (context) => RegisterScreenII(),
        '/gambarulasan': (context) => GambarUlasan(),
        GalleryItem.routeName: (context) => GalleryItem(),
        '/pertanyaandetail': (context) => PertanyaanDetail(),
        '/proses_beli': (context) => BoughtProccessScreen(),
        '/transaksi_detail': (context) => TransaksiDetailScreen(),
        '/ulasandetail': (context) => UlasanDetail(),
        '/profile_detail': (context) => ProfileDetailScreen(),
        '/listalamat': (context) => AlamatList(),
        '/inputalamat': (context) => InputAlamat(),
        '/privacy': (context) => Privacy(),
        '/ketentuan': (context) => Ketentuan()
      },
      title: 'Toko Terserah',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: AppTheme.textTheme,
        platform: TargetPlatform.android,
      ),
      home: SplashScreen(),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
