import 'dart:convert';

import 'package:best_flutter_ui_templates/Constant/Constant.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

String tokenFixed = '';
String apiURL;

setToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('token', token);
}

getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  tokenFixed = prefs.getString('token');
  //  prefs.getString('token');
}

class RegisterModel {
  bool error;
  String data;

  RegisterModel({
    this.error,
    this.data,
  });

  factory RegisterModel.loopJson(Map<String, dynamic> object) {
    return RegisterModel(
      error: object['error'],
      data: object['data'],
    );
  }

  static Future<RegisterModel> register(
    String name,
    String email,
    String password,
    String gender,
    String dob,
  ) async {
    try {
      // await _getToken();

      apiURL = globalBaseUrl + globalPathAuth + "register";
      String passwordConf = password;
      String username;

      if (name.length > 0) {
        var inSpace = name.split(' ');
        username = inSpace[0];

        for (var i = 1; i < inSpace.length; i++) {
          if (inSpace.length > 0) {
            username = username + inSpace[i].substring(0, 1);
          }
        }
        print(DateTime.parse(dob));
        username = username +
            '_' +
            DateFormat('ddMM').format(DateTime.parse(dob)).toString();
      }
      var apiResult = await http.post(apiURL, body: jsonEncode({
        "name": name,
        "email": email,
        "username": username,
        "dob": dob,
        "gender": gender,
        "password": password,
        'password_confirmation': passwordConf,
      }), headers: {
        "Accept": "application/json",
        'Content-type': 'application/json'
        // "Authorization": "Bearer " + (tokenFixed != null ? tokenFixed : '')
      });
      

      print('register status code : ' + apiResult.statusCode.toString());
      final ress = json.decode(apiResult.body);
      // print(ress);

     

      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
      
        
        await setToken(ress['verifyToken']);

        return RegisterModel(
          error: false,
          data: msgSuccess['MSG_REGISTER'].toString(),
        );

      } else if (apiResult.statusCode == 400) {
        // print(ress['data']);
        return RegisterModel(
          error: true,
          // data: json.encode(ress['data']),
          data: jsonEncode({"message":json.encode({"password":msgFail['MSG_WRONG']})}),
        );
      } else {
        return RegisterModel(
          error: true,
          data: jsonEncode({"message":{"password":msgFail['MSG_WRONG']}}),
        );
      }
    } catch (e) {
      print('error catch');
      print(e.toString());

      return RegisterModel(
        error: true,
        data: msgFail['MSG_SYSTEM'],
      );
    }
  }
}
