import 'dart:convert';
import 'package:flutter/material.dart';

import 'dto/auth_dto.dart';
import 'dto/api_user_dto.dart';
import 'package:http/http.dart' as http;

import 'dto/alert_dto.dart';
import 'dto/league_dto.dart';
import 'dto/subscribe_dto.dart';

const String baseUrl = 'http://192.168.45.236:8090'; //집
// const String baseUrl = 'http://192.168.219.140:8090';  //원장커피
// const String baseUrl = 'http://192.168.0.18:8090';  //bake29
// const String baseUrl = 'http://172.30.1.21:8090';  //사랑이집
late Auth? auth;
late ApiUser? user;
Map<String, String> baseHeader = {};

void reissueToken() async {
  baseHeader['RefreshToken'] = auth!.refreshToken;
  final response = await http.post(Uri.parse('$baseUrl/oauth/reissue'), headers: baseHeader);
  if (response.statusCode == 200) {
    auth = Auth.fromJson(json.decode(response.body));
  }
  throw Exception(response.body);
}

Future<void> deleteToken() async {
  baseHeader['RefreshToken'] = auth!.refreshToken;
  await http.delete(Uri.parse('$baseUrl/oauth/logout'), headers: baseHeader);
}

String getKoreanRound(String round) {
  return '${round.replaceAll(RegExp(r'[^0-9]'), '')} 라운드';
}

String getKoreanWeekDay(DateTime date) {
  switch (date.weekday) {
    case 1 :
      return '월';
    case 2 :
      return '화';
    case 3 :
      return '수';
    case 4 :
      return '목';
    case 5 :
      return '금';
    case 6 :
      return '토';
    case 7 :
      return '일';
  }
  throw Exception('not found weekday : ${date.weekday}');
}

Widget getLeagueTile(League? league) {
  return FilledButton(onPressed: () {},
      style: FilledButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: league!.type == 'LEAGUE' ? Colors.deepOrangeAccent : Colors.blue,
        minimumSize: const Size(10, 20),
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0)
      ),
      child: Text(league.name, style: const TextStyle(color: Colors.white, fontSize: 9))
  );
}
