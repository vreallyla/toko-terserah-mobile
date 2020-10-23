import 'dart:convert';

import 'package:best_flutter_ui_templates/Constant/Constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String tokenFixed = '';

_setHome(String dataa) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('dataHome', dataa);
}

_getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  tokenFixed = prefs.getString('token');
  //  prefs.getString('token');
}

class KeranjangModel {
  bool error;
  final data;

  KeranjangModel({
    this.error,
    this.data,
  });

  factory KeranjangModel.loopJson(Map<String, dynamic> object) {
    return KeranjangModel(
      error: object['error'],
      data: object['data'],
    );
  }

  static Future<KeranjangModel> getCart(List ids ) async {
    await _getToken();

    String idSeparator= ids.join(',');

    String apiURL = globalBaseUrl  + 'api/cart?id='+idSeparator;


    print(apiURL);

    try {
      var apiResult = await http.get(apiURL, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + (tokenFixed != null ? tokenFixed : '')
      });

      print('data cart checkout status code : ' + apiResult.statusCode.toString());

      // print(json.decode(apiResult.body));

      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        var jsonObject = json.decode(apiResult.body);

        print('data home success');

        // print(jsonObject['status']);

        if (json.decode(apiResult.body)['status'] != null) {
          // token untuk kirim request habis
          return KeranjangModel(
            error: true,
            data: jsonEncode({"message": msgFail['MSG_TOKEN_EXP']}),
          );
        } else {
          //data received
          String resData = jsonEncode(json.decode(apiResult.body)['data']);


          return KeranjangModel(
            error: jsonObject['error'],
            data: resData,
          );
        }
      } else {
        // other failed
        return KeranjangModel(
          error: true,
          data: jsonEncode({"message": msgFail['MSG_WRONG']}),
        );
      }
    } catch (e) {
      print('error catch');
      print(e.toString());
      return KeranjangModel(
        error: true,
        data: jsonEncode({"message": msgFail['MSG_SYSTEM']}),
      );
    }
  }


  static Future<KeranjangModel> addCart(String id, String qty ) async {
    await _getToken();


    String apiURL = globalBaseUrl  + globalPathCart+'add_cart';


    print(apiURL);

    try {
      var apiResult = await http.post(apiURL, 
      body:{
        "id":id,
        "qty":qty,
      },
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + (tokenFixed != null ? tokenFixed : '')
      });

      print('add to cart status code : ' + apiResult.statusCode.toString());

      // print(json.decode(apiResult.body));

      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        var jsonObject = json.decode(apiResult.body);

        print('data home success');

        // print(jsonObject['status']);

        if (json.decode(apiResult.body)['status'] != null) {
          // token untuk kirim request habis
          return KeranjangModel(
            error: true,
            data: jsonEncode({"message": msgFail['MSG_TOKEN_EXP']}),
          );
        } else {
          //data received
          String resData = jsonEncode(json.decode(apiResult.body)['data']);


          return KeranjangModel(
            error: jsonObject['error'],
            data: resData,
          );
        }
      } else {
        // other failed
        return KeranjangModel(
          error: true,
          data: jsonEncode({"message": msgFail['MSG_WRONG']}),
        );
      }
    } catch (e) {
      print('error catch');
      print(e.toString());
      return KeranjangModel(
        error: true,
        data: jsonEncode({"message": msgFail['MSG_SYSTEM']}),
      );
    }
  }

}
