import 'dart:convert';

import 'package:tokoterserah/Constant/Constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String tokenFixed = '';

_setUser(String dataa) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('dataAlamat', dataa);
}

_getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  tokenFixed = prefs.getString('token');
  //  prefs.getString('token');
}

class AlamatModel {
  bool error;
  final data;

  AlamatModel({
    this.error,
    this.data,
  });

  factory AlamatModel.loopJson(Map<String, dynamic> object) {
    return AlamatModel(
      error: object['error'],
      data: object['data'],
    );
  }

  static Future<AlamatModel> getAlamat() async {
    await _getToken();

    String apiURL = globalBaseUrl  + "api/address";

    print(apiURL);

    try {
      var apiResult = await http.get(apiURL, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + (tokenFixed != null ? tokenFixed : '')
      });

      print('data alamat status code : ' + apiResult.statusCode.toString());
          // print(json.decode(apiResult.body));

      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        var jsonObject = json.decode(apiResult.body);


        if (json.decode(apiResult.body)['status'] != null) {
          // token untuk kirim request habis
          return AlamatModel(
            error: true,
            data: jsonEncode({"message": msgFail['MSG_TOKEN_EXP']}),
          );
        } else {
          //data received
          String resData = jsonEncode(json.decode(apiResult.body)['data']);

          return AlamatModel(
            error: jsonObject['error'],
            data: resData,
          );
        }
      } else {
        // other failed
        return AlamatModel(
          error: true,
          data: jsonEncode({"message": msgFail['MSG_WRONG']}),
        );
      }
    } catch (e) {
      print('error catch');
      print(e.toString());
      return AlamatModel(
        error: true,
        data: jsonEncode({"message": msgFail['MSG_SYSTEM']}),
      );
    }
  }

  static Future<AlamatModel> getRajaOngkir(String destination, String weight) async {
    await _getToken();

    String apiURL = globalBaseUrl  + "api/rajaongkir/cost";

    //requst destination=id_kecamatan & weight=berat keseluruhan product

    print(apiURL);

    try {
      var apiResult = await http.post(apiURL, 
      body:{
        'destination':destination,
        "weight":weight,
      },
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + (tokenFixed != null ? tokenFixed : '')
      });

      print('data raja ongkir status code : ' + apiResult.statusCode.toString());
          // print(json.decode(apiResult.body));

      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        var jsonObject = json.decode(apiResult.body);


        if (json.decode(apiResult.body) == null) {
          // token untuk kirim request habis
          return AlamatModel(
            error: true,
            data: jsonEncode({"message": msgFail['MSG_TOKEN_EXP']}),
          );
        } else {
          //data received
          String resData = jsonEncode(json.decode(apiResult.body)['rajaongkir']);

          return AlamatModel(
            error: false,
            data: resData,
          );
        }
      } else {
        // other failed
        return AlamatModel(
          error: true,
          data: jsonEncode({"message": msgFail['MSG_WRONG']}),
        );
      }
    } catch (e) {
      print('error catch');
      print(e.toString());
      return AlamatModel(
        error: true,
        data: jsonEncode({"message": msgFail['MSG_SYSTEM']}),
      );
    }
  }


  static Future<AlamatModel> akunRes() async {
    await _getToken();

    String apiURL = globalBaseUrl + globalPathAuth + "address";

    print(apiURL);

    try {
      var apiResult = await http.get(apiURL);

      print('data akun status code : ' + apiResult.statusCode.toString());

      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        var jsonObject = json.decode(apiResult.body);

        print('data akun success');

        print(jsonObject['status']);

        if (json.decode(apiResult.body)['status'] != null) {
          // token untuk kirim request habis
          return AlamatModel(
            error: true,
            data: jsonEncode({"message": msgFail['MSG_TOKEN_EXP']}),
          );
        } else {
          //data received
          String resData = jsonEncode(json.decode(apiResult.body)['data']);

          //set data user to shared prefrence
          _setUser(resData);

          return AlamatModel(
            error: jsonObject['error'],
            data: jsonEncode({"message": msgSuccess['MSG_RECEIVED']}),
          );
        }
      } else {
        // other failed
        return AlamatModel(
          error: true,
          data: jsonEncode({"message": msgFail['MSG_WRONG']}),
        );
      }
    } catch (e) {
      print('error catch');
      print(e.toString());
      return AlamatModel(
        error: true,
        data: jsonEncode({"message": msgFail['MSG_SYSTEM']}),
      );
    }
  }



  static Future<AlamatModel> checkEmail(String email) async {
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
        return AlamatModel(
          error: false,
          data: jsonEncode({"message": jsonObject['data']['message']}),
        );
      } else if (apiResult.statusCode == 404) {
        //email sudah digunakan / tidak valid
        return AlamatModel(
          error: true,
          data: jsonEncode({"message": jsonObject['data']['message']}),
        );
      } else {
        // other failed
        return AlamatModel(
          error: true,
          data: jsonEncode({"message": msgFail['MSG_WRONG']}),
        );
      }
    } catch (e) {
      print('error catch');
      print(e.toString());
      return AlamatModel(
        error: true,
        data: jsonEncode({"message": msgFail['MSG_SYSTEM']}),
      );
    }
  }
}
