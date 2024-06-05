

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Standing {

  int rank;
  int points;
  int goalsDiff;
  String? group;
  String form;
  String status;
  String? description;
  Game all;
  Game home;
  Game away;

  Standing({
    required this.rank,
    required this.points,
    required this.goalsDiff,
    required this.group,
    required this.form,
    required this.status,
    required this.description,
    required this.all,
    required this.home,
    required this.away,
  });

  factory Standing.fromJson(Map<dynamic, dynamic> json) {
    return Standing(
      rank: json['_rank'],
      points: json['points'],
      goalsDiff: json['goalsDiff'],
      group: json['_group'],
      form: json['form'],
      status: json['_status'],
      description: json['description'],
      all: Game.fromJson(json['_all']),
      home: Game.fromJson(json['home']),
      away: Game.fromJson(json['away']),
    );
  }
  
}

class Game {

  int played;
  int win;
  int draw;
  int lose;
  Goal goals;

  Game({
    required this.played,
    required this.win,
    required this.draw,
    required this.lose,
    required this.goals,
  });

  factory Game.fromJson(Map<dynamic, dynamic> json) {
    return Game(
      played: json['played'],
      win: json['win'],
      draw: json['draw'],
      lose: json['lose'],
      goals: Goal.fromJson(json['goals']),
    );
  }

}

class Goal {
  int for_;
  int against;

  Goal({required this.for_, required this.against});

  factory Goal.fromJson(Map<dynamic, dynamic> json) {
    return Goal(
      for_: json['_for'],
      against: json['against'],
    );
  }

}