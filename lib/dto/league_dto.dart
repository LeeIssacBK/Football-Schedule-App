class League {
  final int apiId;
  final String name;
  final String logo;
  final String type;

  League(
      {required this.name,
        required this.logo,
        required this.type,
        required this.apiId});

  factory League.fromJson(Map<dynamic, dynamic> json) {
    return League(
        apiId: json['apiId'],
        name: json['name'],
        logo: json['logo'],
        type: json['type']);
  }
}