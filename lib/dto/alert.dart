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
  final String? alertType;

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

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AlertType && runtimeType == other.runtimeType && type == other.type;

  @override
  int get hashCode => type.hashCode;
}

List<AlertType> getAlertTypes() {
  return [
    AlertType(name: '30분 전', type: 'BEFORE_30MINUTES'),
    AlertType(name: '1시간 전', type: 'BEFORE_1HOURS'),
    AlertType(name: '3시간 전', type: 'BEFORE_3HOURS'),
    AlertType(name: '6시간 전', type: 'BEFORE_6HOURS'),
    AlertType(name: '하루 전', type: 'BEFORE_1DAYS'),
  ];
}

AlertType getStrToType(String? str) {
  for (AlertType alertType in getAlertTypes()) {
    if (alertType.type == str) {
      return alertType;
    }
  }
  throw Exception('AlertType with type $str not found');
}