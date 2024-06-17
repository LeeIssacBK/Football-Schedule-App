class MyInfoDto {
  final String socialType;
  final int subscribeTeamCount;
  final int totalAlertsCount;

  MyInfoDto({
    required this.socialType,
    required this.subscribeTeamCount,
    required this.totalAlertsCount
  });

  factory MyInfoDto.fromJson(Map<dynamic, dynamic> json) {
    return MyInfoDto(
        socialType: json['socialType'],
        subscribeTeamCount: json['subscribeTeamCount'],
        totalAlertsCount: json['totalAlertsCount']
    );
  }
}