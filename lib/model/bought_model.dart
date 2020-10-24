import 'dart:convert';

import 'package:best_flutter_ui_templates/Constant/Constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String tokenFixed = '';
String userData='';

_setHome(String dataa) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('dataHome', dataa);
}

_setUser(String dataa) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('dataUser', dataa);
}
_getUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  userData = prefs.getString('dataUser');
  //  prefs.getString('token');
}

_getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  tokenFixed = prefs.getString('token');
  //  prefs.getString('token');
}

class BoughtModel {
  bool error;
  final data;

  BoughtModel({
    this.error,
    this.data,
  });

  factory BoughtModel.loopJson(Map<String, dynamic> object) {
    return BoughtModel(
      error: object['error'],
      data: object['data'],
    );
  }

  static Future<BoughtModel> getBought(String status ) async {
    await _getToken();

  

    String apiURL = globalBaseUrl  + 'api/dashboard?status='+status;


    print(apiURL);

    try {
      var apiResult = await http.get(apiURL, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + (tokenFixed != null ? tokenFixed : '')
      });

      print('data bought process status code : ' + apiResult.statusCode.toString());

      // print(json.decode(apiResult.body));

      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        var jsonObject = json.decode(apiResult.body);

        // print(jsonObject['status']);

        if (json.decode(apiResult.body)['status'] != null) {
          // token untuk kirim request habis
          return BoughtModel(
            error: true,
            data: jsonEncode({"message": msgFail['MSG_TOKEN_EXP']}),
          );
        } else {
          //data received
          String resData = jsonEncode(json.decode(apiResult.body)['data']);


          return BoughtModel(
            error: jsonObject['error'],
            data: resData,
          );
        }
      } else {
        // other failed
        return BoughtModel(
          error: true,
          data: jsonEncode({"message": msgFail['MSG_WRONG']}),
        );
      }
    } catch (e) {
      print('error catch');
      print(e.toString());
      return BoughtModel(
        error: true,
        data: jsonEncode({"message": msgFail['MSG_SYSTEM']}),
      );
    }
  }


}
