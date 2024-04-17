import 'package:json_annotation/json_annotation.dart';

import 'subscribe.dart';

@JsonSerializable()
class Fixture {
  final String round;
  final String status;
  final String? referee;
  final DateTime date;
  final League? league;
  final Team? home;
  final Team? away;
  final int? homeGoal;
  final int? awayGoal;
  final String matchResult;

  Fixture(
      {required this.round,
      required this.status,
      required this.referee,
      required this.date,
      required this.league,
      required this.home,
      required this.away,
      required this.homeGoal,
      required this.awayGoal,
      required this.matchResult});

  factory Fixture.fromJson(Map<dynamic, dynamic> json) {
    return Fixture(
      round: json['round'],
      status: json['status'],
      referee: json['referee'],
      date: DateTime.parse(json['date']),
      league: json['league'] != null ? League.fromJson(json['league']) : null,
      home: json['home'] != null ? Team.fromJson(json['home']) : null,
      away: json['away'] != null ? Team.fromJson(json['away']) : null,
      homeGoal: json['homeGoal'],
      awayGoal: json['awayGoal'],
      matchResult: json['matchResult'],
    );
  }
}
