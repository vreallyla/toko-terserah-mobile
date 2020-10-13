import 'dart:io';
import 'package:best_flutter_ui_templates/app_theme.dart';
import 'package:best_flutter_ui_templates/fitness_app/produk_detail/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'fitness_app/fitness_app_home_screen.dart';
import 'fitness_app/produk_detail/product_detail.dart';
import 'fitness_app/produk_detail/pertanyaan_detail.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  //  final AnimationController animationController;
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
        '/': (context) => FitnessAppHomeScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/produk': (context) => ProductDetail(),
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
      },
      title: 'Test Apps',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        textTheme: AppTheme.textTheme,
        platform: TargetPlatform.android,
      ),
      //home: FitnessAppHomeScreen(),
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
