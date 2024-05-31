import 'package:geolpo/dto/team_dto.dart';
import 'package:json_annotation/json_annotation.dart';

import 'league_dto.dart';

@JsonSerializable()
class Subscribe {
  final String type;
  final League? league;
  final Team? team;
  final bool isDelete;

  Subscribe(
      {required this.type,
      required this.league,
      required this.team,
      required this.isDelete});

  factory Subscribe.fromJson(Map<dynamic, dynamic> json) {
    League? league = json['league'] != null ? League.fromJson(json['league']) : null;
    Team? team = json['team'] != null ? Team.fromJson(json['team']) : null;
    return Subscribe(
        type: json['type'],
        league: league,
        team: team,
        isDelete: json['delete']);
  }
}

class SubscribeRequest {
  final String type;
  final int apiId;

  SubscribeRequest({required this.type, required this.apiId});

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'apiId': apiId,
    };
  }
}