import 'dart:convert';

import 'package:best_flutter_ui_templates/Constant/Constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String tokenFixed = '';

_setUser(String dataa) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('dataUser', dataa);
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
    await _getToken();

    String apiURL = globalBaseUrl + globalPathAuth + "user";

    print(apiURL);

    try {
      var apiResult = await http.get(apiURL, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + (tokenFixed != null ? tokenFixed : '')
      });

      print('data akun status code : ' + apiResult.statusCode.toString());

      print(json.decode(apiResult.body));

      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        var jsonObject = json.decode(apiResult.body);

        print('data akun success');

        print(jsonObject['status']);

        if (json.decode(apiResult.body)['status'] != null) {
          // token untuk kirim request habis
          return UserModel(
            error: true,
            data: jsonEncode({"message": msgFail['MSG_TOKEN_EXP']}),
          );
        } else {
          //data received
          String resData = jsonEncode(json.decode(apiResult.body)['data']);

          //set data user to shared prefrence
          _setUser(resData);

          return UserModel(
            error: jsonObject['error'],
            data: jsonEncode({"message": msgSuccess['MSG_RECEIVED']}),
          );
        }
      } else {
        // other failed
        return UserModel(
          error: true,
          data: jsonEncode({"message": msgFail['MSG_WRONG']}),
        );
      }
    } catch (e) {
      print('error catch');
      print(e.toString());
      return UserModel(
        error: true,
        data: jsonEncode({"message": msgFail['MSG_SYSTEM']}),
      );
    }
  }

  static Future<UserModel> checkEmail(String email) async {
    String apiURL = globalBaseUrl + globalPathAuth + "check_email";

    // print(apiURL);

    try {
      var apiResult = await http.get(Uri.encodeFull(apiURL + '?email=' + email),
          headers: {"Accept": "application/json"});

      print('check email status code : ' + apiResult.statusCode.toString());
      var jsonObject = json.decode(apiResult.body);

      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        print('check email sukses success');

        print(jsonObject['message']);
        // email dapat digunakan
        return UserModel(
          error: false,
          data: jsonEncode({"message": jsonObject['data']['message']}),
        );
      } else if (apiResult.statusCode == 404) {
        //email sudah digunakan / tidak valid
        return UserModel(
          error: true,
          data: jsonEncode({"message": jsonObject['data']['message']}),
        );
      } else {
        // other failed
        return UserModel(
          error: true,
          data: jsonEncode({"message": msgFail['MSG_WRONG']}),
        );
      }
    } catch (e) {
      print('error catch');
      print(e.toString());
      return UserModel(
        error: true,
        data: jsonEncode({"message": msgFail['MSG_SYSTEM']}),
      );
    }
  }
}
