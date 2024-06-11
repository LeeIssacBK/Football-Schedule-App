import 'dart:convert';

import 'package:geolpo/dto/fixture_dto.dart';
import 'package:http/http.dart' as http;

import 'api_filter.dart';
import 'auth_api.dart';

Future<List<Fixture>> getSchedule() async {
  final response = processResponse(await http.get(Uri.parse('$baseUrl/api/fixture/subscribe'), headers: baseHeader));
  return List<Fixture>.from(json.decode(utf8.decode(response.bodyBytes)).map((_) => Fixture.fromJson(_)));
}
