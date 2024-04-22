import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Country {
  final String? code;
  final String? name;
  final String krName;
  final String flag;

  Country({
    required this.code,
    required this.name,
    required this.krName,
    required this.flag,
  });

  factory Country.fromJson(Map<dynamic, dynamic> json) {
    return Country(
        code: json['code'],
        name: json['name'],
        krName: json['krName'],
        flag: json['flag']);
  }
}
