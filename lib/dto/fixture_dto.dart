import 'package:geolpo/dto/team_dto.dart';
import 'package:json_annotation/json_annotation.dart';

import 'league_dto.dart';
import 'subscribe_dto.dart';

@JsonSerializable()
class Fixture {
  final int apiId;
  final String round;
  ///Not Started : NS, TBD
  ///Finished : FT, AET, PEN
  final String status;
  final String? referee;
  final DateTime date;
  final League? league;
  final Team? home;
  final Team? away;
  final int? homeGoal;
  final int? awayGoal;
  final String matchResult;
  final bool isAlert;

  Fixture(
      {
      required this.apiId,
      required this.round,
      required this.status,
      required this.referee,
      required this.date,
      required this.league,
      required this.home,
      required this.away,
      required this.homeGoal,
      required this.awayGoal,
      required this.matchResult,
      required this.isAlert
      });

  factory Fixture.fromJson(Map<dynamic, dynamic> json) {
    return Fixture(
      apiId: json['apiId'],
      round: json['round'],
      status: json['status'],
      referee: json['referee'],
      date: DateTime.parse(json['date']).add(const Duration(hours: 9)),
      league: json['league'] != null ? League.fromJson(json['league']) : null,
      home: json['home'] != null ? Team.fromJson(json['home']) : null,
      away: json['away'] != null ? Team.fromJson(json['away']) : null,
      homeGoal: json['homeGoal'],
      awayGoal: json['awayGoal'],
      matchResult: json['matchResult'],
      isAlert: json['alert'],
    );
  }
}
