import 'dart:convert';
import 'api/auth.dart';
import 'api/apiUser.dart';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://192.168.45.150:8090'; //집
// const String baseUrl = 'http://192.168.219.140:8090';  //원장커피
// const String baseUrl = 'http://192.168.0.18:8090';  //bake29
// const String baseUrl = 'http://172.30.1.21:8090';  //사랑이집
late Auth auth;
late ApiUser user;
Map<String, String> baseHeader = {};

void reissueToken() async {
  baseHeader['RefreshToken'] = auth.refreshToken;
  final response = await http.post(Uri.parse('$baseUrl/oauth/reissue'), headers: baseHeader);
  if (response.statusCode == 200) {
    auth = Auth.fromJson(json.decode(response.body));
  } else {
    throw Exception(response.body);
  }
}