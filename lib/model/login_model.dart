import 'dart:convert';
//import 'dart:developer';

import 'package:tokoterserah/Constant/Constant.dart';
import 'package:tokoterserah/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String tokenFixed = '';
String userData = '';

_setToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('token', token);
}

_destroyToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String tokenFixed = prefs.getString('token');

  if (tokenFixed != null) {
    await prefs.remove("token");
    await prefs.remove("dataUser");
  }
}

_getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  tokenFixed = prefs.getString('token');
  //  prefs.getString('token');
}

class LoginModel {
  bool error;
  String data;

  LoginModel({
    this.error,
    this.data,
  });

  factory LoginModel.loopJson(Map<String, dynamic> object) {
    return LoginModel(
      error: object['error'],
      data: object['data'],
    );
  }

  static Future<LoginModel> loginManual(String email, String pass) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + globalPathAuth + "login";
    print(apiURL);

    var apiResult = await http.post(apiURL,
        body: {"email": email, "password": pass},
        headers: {"Accept": "application/json"});

    print('login status code : ' + apiResult.statusCode.toString());

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        var jsonObject = json.decode(apiResult.body);

        await UserModel.akunRes();

        print('post login success');

        _setToken(jsonObject['token']);
        return LoginModel(
          error: false,
          data: msgSuccess['MSG_EMAIL'].toString(),
        );
      } else if (apiResult.statusCode == 404) {
        return LoginModel(
          error: true,
          data: msgFail['MSG_LOGIN_EXC'].toString(),
        );
      } else if (apiResult.statusCode == 400) {
        return LoginModel(
          error: true,
          data: msgFail['MSG_AKTIVASI'].toString(),
        );
      } else {
        return LoginModel(
          error: true,
          data: 'Email atau password salah...',
        );
      }
    } catch (e) {
      print('error catch');
      print(e);
      return LoginModel(
        error: true,
        data: msgFail['MSG_SYSTEM'],
      );
    }
  }

  static Future<LoginModel> loginEmail(String email) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + globalPathAuth + "login_email";

    var apiResult = await http.post(apiURL,
        body: {"email": email}, headers: {"Accept": "application/json"});

    print('login email status code : ' + apiResult.statusCode.toString());

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        var jsonObject = json.decode(apiResult.body);

        await UserModel.akunRes();

        print('post login success');

        _setToken(jsonObject['data']['token']);
        print(jsonObject['data']['token']);
        return LoginModel(
          error: false,
          data: msgSuccess['MSG_EMAIL'].toString(),
        );
      } else if (apiResult.statusCode == 404) {
        return LoginModel(
          error: true,
          data: msgFail['MSG_LOGIN_EXC'].toString(),
        );
      } else if (apiResult.statusCode == 400) {
        return LoginModel(
          error: true,
          data: msgFail['MSG_AKTIVASI'].toString(),
        );
      } else {
        return LoginModel(
          error: true,
          data: 'Email atau password salah...',
        );
      }
    } catch (e) {
      print('error catch');
      print(e);
      return LoginModel(
        error: true,
        data: msgFail['MSG_SYSTEM'],
      );
    }
  }

  static Future<LoginModel> getTokenLogin() async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + globalPathAuth + "get_kode";
    print(apiURL);
    // return LoginModel(
    //   error:false,
    //   data:"\$2y\$10\$NwwJAcKJxAlMKIvWzGQzQeaehv9VPNwPC4wlWdl.XgbM1am0vbBGi"
    // );

    var apiResult =
        await http.get(apiURL, headers: {"Accept": "application/json"});

    print('getTokenLogin status code : ' + apiResult.statusCode.toString());

    try {
      var jsonObject = json.decode(apiResult.body);
      // print(jsonObject);

      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        await UserModel.akunRes();

        print('post login success');

        print(jsonObject['token']);
        return LoginModel(
          error: false,
          data: jsonObject['token'],
        );
      } else {
        print(jsonObject);
        return LoginModel(
          error: true,
          data: jsonObject['message'],
        );
      }
    } catch (e) {
      print('error catch');
      print(e);
      return LoginModel(
        error: true,
        data: msgFail['MSG_SYSTEM'],
      );
    }
  }

  static Future<LoginModel> loginGoogle(String token,Map res) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + globalPathAuth + "sosialite";
    print(apiURL);

    var apiResult =
        await http.post(apiURL, 
        body:res,
        headers: {"Accept": "application/json",'token':token});

    print('sosialite status code : ' + apiResult.statusCode.toString());

    try {
      var jsonObject = json.decode(apiResult.body);
      // print(jsonObject);

      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        await UserModel.akunRes();
        _setToken(jsonObject['token']);

        print('sosialite success');

        return LoginModel(
          error: false,
          data: jsonObject['token'],
        );
      } else {
        return LoginModel(
          error: true,
          data: jsonObject['message'],
        );
      }
    } catch (e) {
      print('error catch');
      print(e);
      return LoginModel(
        error: true,
        data: msgFail['MSG_SYSTEM'],
      );
    }
  }

  static Future<LoginModel> logout() async {
    try {
      await _getToken();

      // String apiURL = globalBaseUrl + globalPathAuth +"logout";

      // var apiResult = await http.post(apiURL, headers: {
      //   "Accept": "application/json",
      //   "Authorization": "Bearer " + ( tokenFixed !=null? tokenFixed : '')
      // });

      // print('logout status code : ' + apiResult.statusCode.toString());

      // if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
      //   final ress=json.decode(apiResult.body);
      //   print(ress);

      _destroyToken();

      return LoginModel(
        error: false,
        data: msgSuccess['MSG_LOGOUT'].toString(),
      );
      // } else if (apiResult.statusCode == 404) {
      //   return LoginModel(
      //     error: true,
      //     data: msgFail['MSG_LOGIN_EXC'].toString(),
      //   );
      // } else {
      //   return LoginModel(
      //     error: true,
      //     data: msgFail['MSG_WRONG'],
      //   );
      // }
    } catch (e) {
      print('error catch');
      print(e.toString());
      return LoginModel(
        error: true,
        data: msgFail['MSG_SYSTEM'],
      );
    }
  }
}
