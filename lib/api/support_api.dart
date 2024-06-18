
import 'dart:convert';

import 'package:geolpo/api/api_filter.dart';
import 'package:geolpo/api/auth_api.dart';
import 'package:geolpo/dto/support_dto.dart';
import 'package:http/http.dart' as http;

Future<bool> submitSupport(SupportDto support) async {
  Map<String, String> requestHeader = baseHeader;
  requestHeader['Content-Type'] = 'application/json';
  final response = processResponse(await http.post(Uri.parse('$baseUrl/api/support'),
      body: jsonEncode(support.toJson()),
      headers: requestHeader));
  return response.statusCode == 200;
}
