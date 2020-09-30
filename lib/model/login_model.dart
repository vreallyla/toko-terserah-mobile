import 'dart:convert';

import 'package:best_flutter_ui_templates/Constant/Constant.dart';
import 'package:http/http.dart' as http;
// import 'package:localstorage/localstorage.dart';

class LoginModel {
  bool error;
  var data;

  LoginModel({
    this.error,
    this.data,
  });

  factory LoginModel.createLoginModel(Map<String, dynamic> object) {
    return LoginModel(
      error: object['error'],
      data: object['data'],
    );
  }

  static Future<LoginModel> connectToAPI(String email, String pass) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = BASE_URL + "api/auth/login";

    var apiResult = await http.post(apiURL,
        body: {"email": email, "password": pass},
        headers: {"Accept": "application/json"});
    // print(jsonDecode(apiResult.body));

    // return LoginModel.createLoginModel(
    //     {"error": apiResult.statusCode, "data": {}});

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        var jsonObject = json.decode(apiResult.body);
        // Object res = LoginModel.createLoginModel(jsonObject);

        print('post login success');
        print(jsonObject['token']);
        return LoginModel(
          error: false,
          data: jsonObject,
        );
      } else if (apiResult.statusCode == 401) {
        print('error 401');
        useCode(true, "MSG_WRONG");

        return LoginModel.createLoginModel(RES);
      }
    } catch (e) {
      print('error catch');
      print(e);
      return null;
    }
  }
}
