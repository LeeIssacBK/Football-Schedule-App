import 'dart:convert';
import 'package:http/http.dart' as http;

import '../dto/alert_dto.dart';
import 'api_filter.dart';
import 'auth_api.dart';


Future<List<Alert>> getAlerts() async {
  final response = processResponse(await http.get(Uri.parse('$baseUrl/api/alert'), headers: baseHeader));
  return List<Alert>.from(json
      .decode(utf8.decode(response.bodyBytes))
      .map((_) => Alert.fromJson(_)));
}

Future<void> saveAlert(int apiId, AlertType? alertType) async {
  Map<String, String> requestHeader = baseHeader;
  requestHeader['Content-Type'] = 'application/json';
  alertType = alertType ?? getAlertTypes().first;
  processResponse(await http.post(Uri.parse('$baseUrl/api/alert'),
      body: jsonEncode(AlertRequest(fixtureId: apiId, alertType: alertType.type)),
      headers: baseHeader));
}

Future<void> updateAlert(int apiId, AlertType? alertType) async {
  Map<String, String> requestHeader = baseHeader;
  requestHeader['Content-Type'] = 'application/json';
  processResponse(await http.put(Uri.parse('$baseUrl/api/alert'),
      body: jsonEncode(AlertRequest(fixtureId: apiId, alertType: alertType?.type)),
      headers: baseHeader));
}

Future<void> deleteAlert(int apiId) async {
  Map<String, String> requestHeader = baseHeader;
  requestHeader['Content-Type'] = 'application/json';
  processResponse(await http.delete(Uri.parse('$baseUrl/api/alert'),
      body: jsonEncode(AlertRequest(fixtureId: apiId, alertType: null)),
      headers: baseHeader));
}