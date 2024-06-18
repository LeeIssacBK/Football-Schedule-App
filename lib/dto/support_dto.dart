

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class SupportDto {
  final String type;
  final String title;
  final String content;

  SupportDto({required this.type, required this.title, required this.content});

  factory SupportDto.fromJson(Map<dynamic, dynamic> json) {
    return SupportDto(
      type: json['type'],
      title: json['title'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      'content': content,
    };
  }

}