import 'dart:convert';
import 'api/auth.dart';
import 'api/apiUser.dart';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://192.168.45.5:8090';
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