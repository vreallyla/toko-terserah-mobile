import 'dart:convert';

import 'package:best_flutter_ui_templates/Constant/Constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String tokenFixed = '';

_setWishlist(String dataa) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('dataWishlist', dataa);
}

_getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  tokenFixed = prefs.getString('token');
  //  prefs.getString('token');
}

class WishlistModel {
  bool error;
  final data;

  WishlistModel({
    this.error,
    this.data,
  });

  factory WishlistModel.loopJson(Map<String, dynamic> object) {
    return WishlistModel(
      error: object['error'],
      data: object['data'],
    );
  }

  static Future<WishlistModel> getWish(String q) async {
    await _getToken();

    String apiURL = globalBaseUrl +  "api/wish"+(q.length>0 ? '?q='+ q : '');

    print(apiURL);

    try {
      var apiResult = await http.get(apiURL, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + (tokenFixed != null ? tokenFixed : '')
      });

      print('data wishlist status code : ' + apiResult.statusCode.toString());

      // print(json.decode(apiResult.body));

      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        var jsonObject = json.decode(apiResult.body);

        print('data wishlist success');

        // print(jsonObject['status']);

        if (json.decode(apiResult.body)['status'] != null) {
          // token untuk kirim request habis
          return WishlistModel(
            error: true,
            data: jsonEncode({"message": msgFail['MSG_TOKEN_EXP']}),
          );
        } else {
          //data received
          String resData = jsonEncode(json.decode(apiResult.body)['data']);

          //set data user to shared prefrence
          _setWishlist(resData);

          return WishlistModel(
            error: jsonObject['error'],
            data: jsonEncode({"message": msgSuccess['MSG_RECEIVED']}),
          );
        }
      } else {
        // other failed
        return WishlistModel(
          error: true,
          data: jsonEncode({"message": msgFail['MSG_WRONG']}),
        );
      }
    } catch (e) {
      print('error catch');
      print(e.toString());
      return WishlistModel(
        error: true,
        data: jsonEncode({"message": msgFail['MSG_SYSTEM']}),
      );
    }
  }

  static Future<WishlistModel> deleteWish(String id) async {
    await _getToken();

    String apiURL = globalBaseUrl + globalPathWish + "delete/" + id;

    print(apiURL);

    try {
      var apiResult = await http.post(apiURL, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + (tokenFixed != null ? tokenFixed : '')
      });

      print('data wishlist status code : ' + apiResult.statusCode.toString());

      // print(json.decode(apiResult.body));

      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        var jsonObject = json.decode(apiResult.body);

        print('data wishlist success');

        // print(jsonObject['status']);

        if (json.decode(apiResult.body)['status'] != null) {
          // token untuk kirim request habis
          return WishlistModel(
            error: true,
            data: jsonEncode({"message": msgFail['MSG_TOKEN_EXP']}),
          );
        } else {
          //data received
          String resData = jsonEncode(json.decode(apiResult.body)['data']);
          print(resData);
          //set data user to shared prefrence
          _setWishlist(resData);

          return WishlistModel(
            error: jsonObject['error'],
            data: jsonEncode({"message": msgSuccess['MSG_RECEIVED']}),
          );
        }
      } else {
        // other failed
        return WishlistModel(
          error: true,
          data: jsonEncode({"message": msgFail['MSG_WRONG']}),
        );
      }
    } catch (e) {
      print('error catch');
      print(e.toString());
      return WishlistModel(
        error: true,
        data: jsonEncode({"message": msgFail['MSG_SYSTEM']}),
      );
    }
  }

}
