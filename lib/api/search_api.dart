import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolpo/api/auth_api.dart';
import 'package:geolpo/dto/country_dto.dart';
import 'package:geolpo/dto/league_dto.dart';
import 'package:geolpo/dto/subscribe_dto.dart';
import 'package:geolpo/dto/team_dto.dart';
import 'package:geolpo/enums/continent_type.dart';
import 'package:geolpo/enums/subscribe_type.dart';

Future<List<Country>> getCountries(Continent continent) async {
  final response = await http.get(
      Uri.parse(
          '$baseUrl/api/country?continent=${Continent.enumToStr(continent)}'),
      headers: baseHeader);
  if (response.statusCode == 200) {
    return List<Country>.from(json
        .decode(utf8.decode(response.bodyBytes))
        .map((_) => Country.fromJson(_)));
  } else {
    return List.empty();
  }
}

Future<List<League>> getLeagues(String countryCode) async {
  final response = await http.get(
      Uri.parse('$baseUrl/api/league?countryCode=$countryCode'),
      headers: baseHeader);
  if (response.statusCode == 200) {
    return List<League>.from(json
        .decode(utf8.decode(response.bodyBytes))
        .map((_) => League.fromJson(_)));
  }
  return List.empty();
}

Future<List<Team>> getTeams(int leagueId) async {
  final response = await http.get(
      Uri.parse('$baseUrl/api/team?leagueId=$leagueId'),
      headers: baseHeader);
  if (response.statusCode == 200) {
    dynamic data = json.decode(utf8.decode(response.bodyBytes));
    return List<Team>.from(data.map((_) => Team.fromJson(_)));
  }
  return List.empty();
}

Future<bool> subscribeTeam(int teamId) async {
  Map<String, String> requestHeader = baseHeader;
  requestHeader['Content-Type'] = 'application/json';
  final response = await http.post(Uri.parse('$baseUrl/api/subscribe/'),
      body: jsonEncode(
          SubscribeRequest(type: SubscribeType.TEAM.name, apiId: teamId)),
      headers: requestHeader);
  return response.statusCode == 200;
}
