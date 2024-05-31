import 'dart:convert';

import 'package:http/http.dart' as http;

import '../dto/subscribe_dto.dart';
import '../enums/subscribe_type.dart';
import 'api_filter.dart';
import 'auth_api.dart';

Future<List<Subscribe>> getSubscribes() async {
  final response = processResponse(await http.get(
      Uri.parse('$baseUrl/api/subscribe/?type=TEAM'),
      headers: baseHeader));
  dynamic body = jsonDecode(utf8.decode(response.bodyBytes));
  return List<Subscribe>.from(body.map((_) => Subscribe.fromJson(_)));
}

Future<bool> deleteSubscribe(int teamId) async {
  Map<String, String> requestHeader = baseHeader;
  requestHeader['Content-Type'] = 'application/json';
  final response = await http.delete(Uri.parse('$baseUrl/api/subscribe'),
      body: jsonEncode(SubscribeRequest(type: SubscribeType.TEAM.name, apiId: teamId)),
      headers: requestHeader);
  return response.statusCode == 200;
}