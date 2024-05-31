class Team {
  final int apiId;
  final String name;
  final String? krName;
  final String? code;
  final int founded;
  final bool national;
  final String logo;
  final String? stadium;
  final String? address;
  final String? city;
  final int capacity;
  final String? stadiumImage;

  Team({
    required this.apiId,
    required this.name,
    required this.krName,
    required this.code,
    required this.founded,
    required this.national,
    required this.logo,
    required this.stadium,
    required this.address,
    required this.city,
    required this.capacity,
    required this.stadiumImage,
  });

  factory Team.fromJson(Map<dynamic, dynamic> json) {
    return Team(
      apiId: json['apiId'],
      name: json['name'],
      krName: json['krName'],
      code: json['code'],
      founded: json['founded'],
      national: json['national'],
      logo: json['logo'],
      stadium: json['stadium'],
      address: json['address'],
      city: json['city'],
      capacity: json['capacity'],
      stadiumImage: json['stadiumImage'],
    );
  }
}