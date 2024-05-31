import 'package:json_annotation/json_annotation.dart';

import '../enums/continent_type.dart';

@JsonSerializable()
class Country {
  final String? code;
  final String? name;
  final String krName;
  final String flag;
  final Continent continent;

  Country({
    required this.code,
    required this.name,
    required this.krName,
    required this.flag,
    required this.continent,
  });

  factory Country.fromJson(Map<dynamic, dynamic> json) {
    return Country(
        code: json['code'],
        name: json['name'],
        krName: json['krName'],
        flag: json['flag'],
        continent: Continent.strToEnum(json['continent']),
    );
  }
}
