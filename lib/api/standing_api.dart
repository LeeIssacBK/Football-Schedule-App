
import 'dart:convert';
import 'package:geolpo/api/auth_api.dart';
import 'package:http/http.dart' as http;
import 'package:geolpo/api/api_filter.dart';
import 'package:geolpo/dto/standing_dto.dart';

Future<Standing> get(int teamId) async {
  final response = processResponse(await http.get(
      Uri.parse('$baseUrl/api/team/standing?teamId=$teamId'),
      headers: baseHeader));
  return Standing.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
}
