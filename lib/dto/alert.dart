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

class AlertRequest {
  final int fixtureId;
  final String alertType;

  AlertRequest({required this.alertType, required this.fixtureId});

  Map<String, dynamic> toJson() {
    return {
      'fixtureId': fixtureId,
      'alertType': alertType,
    };
  }
}

class AlertType {
  final String name;
  final String type;

  AlertType({required this.name, required this.type});
}