import 'dart:convert';

import 'package:best_flutter_ui_templates/Constant/Constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String tokenFixed = '';

_setToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('token', token);
}

_getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  tokenFixed = prefs.getString('token');
  //  prefs.getString('token');
}

class UserModel {
  bool error;
  final data;

  UserModel({
    this.error,
    this.data,
  });

  factory UserModel.loopJson(Map<String, dynamic> object) {
    return UserModel(
      error: object['error'],
      data: object['data'],
    );
  }

  static Future<UserModel> akunRes() async {
    _getToken();

    String apiURL = BASE_URL + PATH_AUTH + "user";

    print(apiURL);

    try {
      var apiResult = await http.get(apiURL, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + (tokenFixed != null ? tokenFixed : '')
      });

      print('data akun status code : ' + apiResult.statusCode.toString());

      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        var jsonObject = json.decode(apiResult.body);

        print('data akun success');
        print(json.decode(apiResult.body));
        print(jsonObject['status']);

        if (json.decode(apiResult.body)['status']!=null) {
          // token untuk kirim request habis
          return UserModel(
            error: true,
            data: jsonEncode({"message":MSG_FAIL['MSG_TOKEN_EXP']}),
          );
        } else {
          //data received
          return UserModel(
            error: jsonObject['error'],
            data: jsonEncode(json.decode(apiResult.body)['data']),
          );
        }
      } else {
        // other failed
        return UserModel(
          error: true,
          data: jsonEncode({"message":MSG_FAIL['MSG_WRONG']}),
        );
      }
    } catch (e) {
      print('error catch');
      print(e.toString());
      return UserModel(
        error: true,
        data: jsonEncode({"message":MSG_FAIL['MSG_SYSTEM']}),
      );
    }
  }
}
