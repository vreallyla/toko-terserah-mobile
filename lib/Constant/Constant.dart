import 'dart:convert';

// ignore: non_constant_identifier_names
String BASE_URL = "http://192.168.43.64:8000/";
final Map<String, Object> RES = {"error": false, "data": {}};

//message statuscode
final MSG_TIMEOUT = {
  "message": 'Connection timeout...',
};
final MSG_FAIL = {
  "MSG_TIMEOUT": 'Connection timeout...',
  "MSG_NOTFOUND": 'Data Not Found',
  "MSG_WRONG": 'Somehing wrong, check your connection...',
};

void useCode(
  bool status,
  String opError,
) {
  RES['error'] = true;
  RES['data'] = {"message": MSG_FAIL[opError]};
}

void successRes(Object dataRes) {
  RES['data'] = dataRes;
}
