import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: non_constant_identifier_names
String BASE_URL = "http://101.50.0.89/";
String PATH_AUTH = "api/auth/";


var RES = {"error": false, "data": <Object>{}};

//message statuscode
final MSG_TIMEOUT = {
  "message": 'Connection timeout...',
};
final MSG_FAIL = {
  "MSG_TIMEOUT": 'Connection timeout...',
  "MSG_NOTFOUND": 'Data Not Found',
  "MSG_WRONG": 'Somehing wrong, check your connection...',
  "MSG_LOGIN_EXC":'Email atau Password Salah...',
  "MSG_SYSTEM":'System in Contraction...',
  "MSG_AKTIVASI":"Akun Belum Aktif, Silakan Cek Email...",
  "MSG_TOKEN_EXP":"Kode telah habis, buat lagi",
  
};

final MSG_SUKSES={
  "MSG_EMAIL":'Berhasil Masuk',
  'MSG_LOGOUT':'Berhasil Keluar',
  "MSG_RECEIVED":'Data Diterima',
};



void useCode(
  bool status,
  String opError,
) {

  var msg={"message":' MSG_FAIL[opError]'};
  RES['error'] = true;
  RES['data'] = msg;
}

void successRes(Object dataRes) {
  RES['data'] = dataRes;
}

Widget no_connection(){
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
          Text('Periksa sambungan internet kamu',style:TextStyle(color: Colors.black54))
        ],
      ),
  );
}

Widget loading_req(){
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


