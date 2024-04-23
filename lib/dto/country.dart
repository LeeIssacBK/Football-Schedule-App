import 'package:json_annotation/json_annotation.dart';

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

enum Continent {
  asia, europe, southAmerica, northAmerica, africa, oceania;

  static Continent strToEnum(String str) {
    switch (str) {
      case 'ASIA':
        return Continent.asia;
      case 'EUROPE':
        return Continent.europe;
      case 'SOUTH_AMERICA':
        return Continent.southAmerica;
      case 'NORTH_AMERICA':
        return Continent.northAmerica;
      case 'AFRICA':
        return Continent.africa;
      case 'OCEANIA':
        return Continent.oceania;
    }
    throw Exception('not found continent');
  }

}
