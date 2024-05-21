import 'package:json_annotation/json_annotation.dart';

import 'fixture.dart';

@JsonSerializable()
class Alert {

  final String? alertType;
  final bool? isSend;
  final Fixture fixture;

  Alert({
    required this.alertType,
    required this.isSend,
    required this.fixture
  });

  factory Alert.fromJson(Map<dynamic, dynamic> json) {
    return Alert(
      alertType: json['alertType'],
      isSend: json['isSend'],
      fixture: Fixture.fromJson(json['fixture'])
    );
  }

}

enum AlertType {
  BEFORE_30MINUTES,
  BEFORE_1HOURS,
  BEFORE_3HOURS,
  BEFORE_6HOURS,
  BEFORE_1DAYS
}