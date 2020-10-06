// import 'dart:convert';
// import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// ignore: non_constant_identifier_names
// String globalBaseUrl = "http://101.50.0.89/";
String globalBaseUrl = "http://10.60.100.178:8000/";

String globalPathAuth = "api/auth/";

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


Widget noConnection(){
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top:120),
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
          Text('Koneksi Terputus',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
          Text('Periksa sambungan internet kamu',style:TextStyle(color: Colors.black54)),
          Container(
            margin:EdgeInsets.only(top:15),
            child: RaisedButton(
              onPressed: (){
                
              },
              color: Colors.orange[800],
              child: Text('Coba Lagi',style:TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
  );
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


