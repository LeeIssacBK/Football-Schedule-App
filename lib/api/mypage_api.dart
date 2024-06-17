import 'dart:convert';
import 'package:geolpo/api/api_filter.dart';
import 'package:geolpo/api/auth_api.dart';
import 'package:geolpo/dto/myinfo_dto.dart';
import 'package:http/http.dart' as http;

Future<MyInfoDto> getMyInfo() async {
  final response = processResponse(await http.get(
      Uri.parse('$baseUrl/api/mypage/myinfo'),
      headers: baseHeader));
  return MyInfoDto.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
}

Future<void> withDrawUser() async {
  processResponse(await http.delete(
      Uri.parse('$baseUrl/api/mypage/withdraw'),
      headers: baseHeader));
}