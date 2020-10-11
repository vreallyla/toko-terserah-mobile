// import 'dart:convert';
// import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// ignore: non_constant_identifier_names
// String globalBaseUrl = "http://101.50.0.89/";
String globalBaseUrl = "http://101.50.0.89/";
String globalPathAuth = "api/auth/";



String locationAva='storage/users/ava/';
String locationBgPhoto='storage/users/background/';
String locationProductImage='storage/produk/thumb/';

//asset
String locationOccupation='assets/occupancy/';

int lenBarcode=6;


final msgFail = {
  "MSG_TIMEOUT": 'Connection timeout...',
  "MSG_NOTFOUND": 'Data Not Found',
  "MSG_WRONG": 'Somehing wrong, check your connection...',
  "MSG_LOGIN_EXC":'Email atau Password Salah...',
  "MSG_SYSTEM":'System in Contraction...',
  "MSG_AKTIVASI":"Akun Belum Aktif, Silakan Cek Email...",
  "MSG_TOKEN_EXP":"Kode telah habis, buat lagi",
  
};

final msgSuccess={
  "MSG_EMAIL":'Berhasil Masuk',
  "MSG_REGISTER":'Register berhasil',
  'MSG_LOGOUT':'Berhasil Keluar',
  "MSG_RECEIVED":'Data Diterima',
};

void dateParseJson(){
  
}



Widget reqLoad(){
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

Widget dataKosong(){
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
              'Data Tidak Ditemukan',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            ),
            Text(
              'Silakan cari data yang tersedia...',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54),
            )
          ],
        ),
      );
}


