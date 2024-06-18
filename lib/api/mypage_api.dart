import 'dart:convert';
import 'package:geolpo/api/api_filter.dart';
import 'package:geolpo/api/auth_api.dart';
import 'package:geolpo/dto/myinfo_dto.dart';
import 'package:geolpo/dto/qna_dto.dart';
import 'package:geolpo/dto/support_dto.dart';
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

Future<bool> submitSupport(SupportDto support) async {
  Map<String, String> requestHeader = baseHeader;
  requestHeader['Content-Type'] = 'application/json';
  final response = processResponse(await http.post(Uri.parse('$baseUrl/api/support'),
      body: jsonEncode(support.toJson()),
      headers: requestHeader));
  return response.statusCode == 200;
}

Future<List<QnaDto>> getQnA() async {
  final response = processResponse(await http.get(Uri.parse('$baseUrl/api/qna'), headers: baseHeader));
  return List<QnaDto>.from(json.decode(utf8.decode(response.bodyBytes)).map((_) => QnaDto.fromJson(_)));
}
