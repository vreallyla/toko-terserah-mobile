import 'dart:convert';
import 'dart:developer';

import 'package:best_flutter_ui_templates/Constant/Constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String tokenFixed = '';

_getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  tokenFixed = prefs.getString('token');
  //  prefs.getString('token');
}

class MidtransModel {
  bool error;
  final data;

  MidtransModel({
    this.error,
    this.data,
  });

  factory MidtransModel.loopJson(Map<String, dynamic> object) {
    return MidtransModel(
      error: object['error'],
      data: object['data'],
    );
  }

  static Future<MidtransModel> getSnap(Map<String,dynamic> obj) async {
    await _getToken();

    String paramss='';

    paramss=paramss+'?pengiriman_id='+obj['pengiriman_id'];
    paramss=paramss+'&penagihan_id='+obj['penagihan_id'];
    paramss=paramss+'&ongkir='+obj['ongkir'];
    paramss=paramss+'&discount_price='+obj['discount_price'];
    paramss=paramss+'&cart_ids='+obj['cart_ids'];
    paramss=paramss+'&total='+obj['total'];
    paramss=paramss+'&weight='+obj['weight'];
    
 
    String apiURL = globalBaseUrl  + "api/checkout/midtrans/snap"+paramss;
    print(apiURL);
   

    try {
      var apiResult = await http.get(apiURL, 
      
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + (tokenFixed != null ? tokenFixed : '')
      });


      print('snap midtrans status code : ' + apiResult.statusCode.toString());

      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {


        if (!(apiResult.body is String)) {
          // token untuk kirim request habis
          return MidtransModel(
            error: true,
            data: jsonEncode({"message": msgFail['MSG_TOKEN_EXP']}),
          );
        } else {
          //data received
          String resData = jsonEncode(json.decode(apiResult.body));

          return MidtransModel(
            error: false,
            data: jsonDecode(resData)['data'] ,
          );
        }
      } else {
        // other failed
        return MidtransModel(
          error: true,
          data: jsonEncode({"message": msgFail['MSG_WRONG']}),
        );
      }
    } catch (e) {
      print('error catch');
      print(e.toString());
      return MidtransModel(
        error: true,
        data: jsonEncode({"message": msgFail['MSG_SYSTEM']}),
      );
    }
  }

  static Future<MidtransModel> cekUniCode(String unicode) async {
    await _getToken();

  
 
    String apiURL = globalBaseUrl  + "api/checkout/midtrans/check/"+unicode;
    print(apiURL);

    try {
      var apiResult = await http.get(apiURL, 
      
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + (tokenFixed != null ? tokenFixed : '')
      });


      print('cek unicode midtrans status code : ' + apiResult.statusCode.toString());

      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {


        if (!(apiResult.body is String)) {
          // token untuk kirim request habis
          return MidtransModel(
            error: true,
            data: jsonEncode({"message": msgFail['MSG_TOKEN_EXP']}),
          );
        } else {
          //data received
          String resData = jsonEncode(json.decode(apiResult.body));

          return MidtransModel(
            error: false,
            data: jsonDecode(resData)['data'] ,
          );
        }
      } else {
        // other failed
        return MidtransModel(
          error: true,
          data: jsonEncode({"message": msgFail['MSG_WRONG']}),
        );
      }
    } catch (e) {
      print('error catch');
      print(e.toString());
      return MidtransModel(
        error: true,
        data: jsonEncode({"message": msgFail['MSG_SYSTEM']}),
      );
    }
  }


}
