import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class League {

  final int apiId;
  final String name;
  final String logo;
  final String type;

  League({required this.apiId,
  required this.name,
  required this.logo,
  required this.type,
  });

  factory League.fromJson(Map<dynamic, dynamic> json) {
    return League(
        apiId: json['apiId'],
        name: json['name'],
        logo: json['logo'],
        type: json['type']);
  }

}
