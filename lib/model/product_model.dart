import 'dart:convert';

import 'package:tokoterserah/Constant/Constant.dart';
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

class ProductModel {
  bool error;
  final data;

  ProductModel({
    this.error,
    this.data,
  });

  factory ProductModel.loopJson(Map<String, dynamic> object) {
    return ProductModel(
      error: object['error'],
      data: object['data'],
    );
  }

  static Future<ProductModel> getHome() async {
    await _getToken();

    String apiURL = globalBaseUrl + globalPathProduct + 'home';

    print(apiURL);

    try {
      var apiResult = await http.get(apiURL, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + (tokenFixed != null ? tokenFixed : '')
      });

      print('data home status code : ' + apiResult.statusCode.toString());

      print(json.decode(apiResult.body));

      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        var jsonObject = json.decode(apiResult.body);

        print('data home success');

        // print(jsonObject['status']);

        if (json.decode(apiResult.body)['status'] != null) {
          // token untuk kirim request habis
          return ProductModel(
            error: true,
            data: jsonEncode({"message": msgFail['MSG_TOKEN_EXP']}),
          );
        } else {
          //data received
          String resData = jsonEncode(json.decode(apiResult.body)['data']);

          //set data user to shared prefrence
          _setHome(resData);

          return ProductModel(
            error: jsonObject['error'],
            data: jsonEncode({"message": msgSuccess['MSG_RECEIVED']}),
          );
        }
      } else {
        // other failed
        return ProductModel(
          error: true,
          data: jsonEncode({"message": msgFail['MSG_WRONG']}),
        );
      }
    } catch (e) {
      print('error catch');
      print(e.toString());
      return ProductModel(
        error: true,
        data: jsonEncode({"message": msgFail['MSG_SYSTEM']}),
      );
    }
  }

  static Future<ProductModel> getVoucher(String q) async {
    await _getToken();

    String apiURL = globalBaseUrl + globalPathProduct + 'voucher_list?q=' + q;

    print(apiURL);

    try {
      var apiResult = await http.get(apiURL, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + (tokenFixed != null ? tokenFixed : '')
      });

      print('data voucher status code : ' + apiResult.statusCode.toString());

      // print(json.decode(apiResult.body));

      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        var jsonObject = json.decode(apiResult.body);

        print('data voucher success');

        // print(jsonObject['status']);

        Map<String, dynamic> resData = json.decode(apiResult.body)['data'];

        return ProductModel(
          error: jsonObject['error'],
          data: resData,
        );
      } else {
        // other failed
        return ProductModel(
          error: true,
          data: jsonEncode({"message": msgFail['MSG_WRONG']}),
        );
      }
    } catch (e) {
      print('error catch');
      print(e.toString());
      return ProductModel(
        error: true,
        data: jsonEncode({"message": msgFail['MSG_SYSTEM']}),
      );
    }
  }

  static Future<ProductModel> getProduct(String id) async {
    await _getToken();

    String apiURL = globalBaseUrl + globalPathProduct + 'detail/' + id;

    print(apiURL);

    try {
      var apiResult = await http.get(apiURL, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + (tokenFixed != null ? tokenFixed : '')
      });

      print('data product detail ' +
          id +
          ' status code : ' +
          apiResult.statusCode.toString());

      // print(json.decode(apiResult.body));

      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        var jsonObject = json.decode(apiResult.body);

        print('product detail success');

        // print(jsonObject['status']);

        if (json.decode(apiResult.body)['status'] != null) {
          // token untuk kirim request habis
          return ProductModel(
            error: true,
            data: jsonEncode({"message": msgFail['MSG_TOKEN_EXP']}),
          );
        } else {
          //data received
          String resData = jsonEncode(json.decode(apiResult.body)['data']);

          return ProductModel(
            error: jsonObject['error'],
            data: resData,
          );
        }
      } else {
        // other failed
        return ProductModel(
          error: true,
          data: jsonEncode({"message": msgFail['MSG_WRONG']}),
        );
      }
    } catch (e) {
      print('error catch');
      print(e.toString());
      return ProductModel(
        error: true,
        data: jsonEncode({"message": msgFail['MSG_SYSTEM']}),
      );
    }
  }

  static Future<ProductModel> addToCart(String id, int qty) async {
    await _getToken();

    String apiURL = globalBaseUrl + globalPathCart + 'add_cart';

    print(apiURL);

    try {
      var apiResult = await http.post(apiURL, body: {
        "id": id,
        "qty": qty
      }, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + (tokenFixed != null ? tokenFixed : '')
      });

      print('data product ' +
          id +
          ' add cart status code : ' +
          apiResult.statusCode.toString());

      // print(json.decode(apiResult.body));

      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        var jsonObject = json.decode(apiResult.body);

        print('product detail success');

        // print(jsonObject['status']);

        if (json.decode(apiResult.body)['status'] != null) {
          // token untuk kirim request habis
          return ProductModel(
            error: true,
            data: jsonEncode({"message": msgFail['MSG_TOKEN_EXP']}),
          );
        } else {
          //data received
          String resData = jsonEncode(json.decode(apiResult.body)['data']);

          return ProductModel(
            error: jsonObject['error'],
            data: resData,
          );
        }
      } else {
        // other failed
        return ProductModel(
          error: true,
          data: jsonEncode({"message": msgFail['MSG_WRONG']}),
        );
      }
    } catch (e) {
      print('error catch');
      print(e.toString());
      return ProductModel(
        error: true,
        data: jsonEncode({"message": msgFail['MSG_SYSTEM']}),
      );
    }
  }
}
