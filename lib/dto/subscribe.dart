import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

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

class League {
  final int apiId;
  final String name;
  final String logo;
  final String type;

  League(
      {required this.name,
      required this.logo,
      required this.type,
      required this.apiId});

  factory League.fromJson(Map<dynamic, dynamic> json) {
    return League(
        apiId: json['apiId'],
        name: json['name'],
        logo: json['logo'],
        type: json['type']);
  }
}

class Team {
  final int apiId;
  final String name;
  final String? krName;
  final String? code;
  final int founded;
  final bool national;
  final String logo;
  final String? stadium;
  final String? address;
  final String? city;
  final int capacity;
  final String? stadiumImage;

  Team({
    required this.apiId,
    required this.name,
    required this.krName,
    required this.code,
    required this.founded,
    required this.national,
    required this.logo,
    required this.stadium,
    required this.address,
    required this.city,
    required this.capacity,
    required this.stadiumImage,
  });

  factory Team.fromJson(Map<dynamic, dynamic> json) {
    return Team(
      apiId: json['apiId'],
      name: json['name'],
      krName: json['krName'],
      code: json['code'],
      founded: json['founded'],
      national: json['national'],
      logo: json['logo'],
      stadium: json['stadium'],
      address: json['address'],
      city: json['city'],
      capacity: json['capacity'],
      stadiumImage: json['stadiumImage'],
    );
  }
}

enum SubscribeType {
  TEAM, PLAYER
}