import 'dart:convert';

import 'package:http/http.dart' as http;

class LoginModel {
  String id;
  String name;
  String job;
  String created;

  LoginModel({this.id, this.name, this.job, this.created});

  factory LoginModel.fromJson(Map<String, dynamic> object) => LoginModel(
        id: object['id'],
        name: object['name'],
        job: object['job'],
        created: object['createdAt'],
      );

  static Future<LoginModel> connectToAPI(String name, String job) async {
    String apiURL = "https://reqres.in/api/users";

    var apiResult = await http.post(apiURL, body: {"name": name, "job": job});

    var jsonObject = json.decode(apiResult.body);

    return LoginModel.fromJson(jsonObject);
  }
}
