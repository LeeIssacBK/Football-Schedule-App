
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class QnaDto {

  final int id;
  final String title;
  final String subtitle;
  final String content;

  QnaDto({required this.id, required this.title, required this.subtitle, required this.content});

  factory QnaDto.fromJson(Map<dynamic, dynamic> json) {
    return QnaDto(id: json['id'], title: json['title'], subtitle: json['subtitle'], content: json['content']);
  }

}