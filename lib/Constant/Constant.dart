// import 'dart:convert';
// import 'dart:io';

import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// ignore: non_constant_identifier_names
// String globalBaseUrl = "http://101.50.0.89/";
String globalBaseUrl = "https://tokoterserah.com/";
String globalPathAuth = "api/auth/";
String globalPathWish = 'api/wish/';
String globalPathProduct = 'api/product/';
String globalPathCart = 'api/cart/';

String locationAva = 'storage/users/ava/';
String locationBgPhoto = 'storage/users/background/';
String locationProductImage = 'storage/produk/thumb/';
String locationBannerImage = "storage/banner/";

// String locationProductImage="storage/produk/thumb/";

//asset
String locationOccupation = 'assets/occupancy/';

int lenBarcode = 6;

final msgFail = {
  "MSG_TIMEOUT": 'Connection timeout...',
  
  "MSG_NOTFOUND": 'Data Not Found',
  "MSG_WRONG": 'Somehing wrong, check your connection...',
  "MSG_LOGIN_EXC": 'Email atau Password Salah...',
  "MSG_SYSTEM": 'System in Contraction...',
  "MSG_AKTIVASI": "Akun Belum Aktif, Silakan Cek Email...",
  "MSG_TOKEN_EXP": "Kode telah habis, buat lagi",
};

final msgSuccess = {
  "MSG_EMAIL": 'Berhasil Masuk',
  "MSG_REGISTER": 'Register berhasil',
  'MSG_LOGOUT': 'Berhasil Keluar',
  "MSG_RECEIVED": 'Data Diterima',
};

void dateParseJson() {}

void loadNotice(context, String pesan,bool warning,String textBtn, Function() btnEvent) {
  Timer _timer;

  showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        _timer = Timer(Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });

        return new AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          content: Builder(
            builder: (context) {
              // Get available height and width of the build area of this widget. Make a choice depending on the size.
              // var height = MediaQuery.of(context).size.height;
              // var width = MediaQuery.of(context).size.width;

              return Container(
                height: 120,
                // width: 200,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        pesan,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: RaisedButton(
                        onPressed: () => btnEvent(),
                        color: warning ? Colors.red : Colors.green,
                        child: Text(
                          textBtn,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        );
      }).then((val) {
    if (_timer.isActive) {
      _timer.cancel();
    }
  });
}

void loadNoticeLock(context, String pesan,bool warning,String textBtn, Function() btnEvent) {
  Timer _timer;

  showDialog(
    barrierDismissible: false,
      context: context,
      builder: (BuildContext builderContext) {
        _timer = Timer(Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });

        return new AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          content: Builder(
            builder: (context) {
              // Get available height and width of the build area of this widget. Make a choice depending on the size.
              // var height = MediaQuery.of(context).size.height;
              // var width = MediaQuery.of(context).size.width;

              return Container(
                height: 120,
                // width: 200,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        pesan,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: RaisedButton(
                        onPressed: () => btnEvent(),
                        color: warning ? Colors.red : Colors.green,
                        child: Text(
                          textBtn,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        );
      }).then((val) {
    if (_timer.isActive) {
      _timer.cancel();
    }
  });
}


Widget reqLoad() {
  return Container(
    alignment: Alignment.center,
    child: Container(
      alignment: Alignment.center,
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/fitness_app/global_loader.gif'),
          fit: BoxFit.fitHeight,
        ),
      ),
      padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
    ),
  );
}

Widget dataKosong() {
  return Container(
    alignment: Alignment.center,
    child: Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 150, bottom: 15),
          alignment: Alignment.center,
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/fitness_app/data_empty.png'),
              fit: BoxFit.fitHeight,
            ),
          ),
          padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
        ),
        Text(
          'Data Kosong',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        Text(
          'Data tidak ditemukan...',
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black54),
        )
      ],
    ),
  );
}

 Widget pesanFullScreen(Function eventBtn, String notice, String subnotice,String txtBtn) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 70),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 160,
            width: 160,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fitness_app/not_found.gif'),
                fit: BoxFit.fitHeight,
              ),
            ),
            padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
          ),
          Text(
            notice,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Text(subnotice,
              style: TextStyle(color: Colors.black54)),
          Container(
            margin: EdgeInsets.only(top: 15),
            child: RaisedButton(
              onPressed: () {
                eventBtn();
              },
              color: Colors.green,
              child: Text(txtBtn, style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
