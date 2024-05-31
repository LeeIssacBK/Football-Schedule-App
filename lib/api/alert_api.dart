import 'dart:convert';
import 'package:http/http.dart' as http;

import '../dto/alert_dto.dart';
import '../global.dart';

Future<void> saveAlert(int apiId, AlertType? alertType) async {
  Map<String, String> requestHeader = baseHeader;
  requestHeader['Content-Type'] = 'application/json';
  alertType = alertType ?? getAlertTypes().first;
  final response = await http.post(Uri.parse('$baseUrl/api/alert'),
      body: jsonEncode(AlertRequest(fixtureId: apiId, alertType: alertType.type)),
      headers: baseHeader);
  if (response.statusCode != 200) {
    throw Exception('$response.statusCode error');
  }
}