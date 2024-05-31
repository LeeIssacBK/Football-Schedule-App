import 'dart:convert';
import 'package:http/http.dart' as http;

import '../dto/fixture_dto.dart';
import '../global.dart';

Future<List<Fixture>> getSchedule() async {
  final response = await http.get(Uri.parse('$baseUrl/api/fixture/subscribe'), headers: baseHeader);
  if (response.statusCode == 200) {
    return List<Fixture>.from(json.decode(utf8.decode(response.bodyBytes)).map((_) => Fixture.fromJson(_)));
  }
  return List.empty();
}