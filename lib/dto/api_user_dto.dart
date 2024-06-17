class ApiUser {
  final String status;
  final String userId;
  final String name;
  final String? profileImage;
  final DateTime createdAt;

  ApiUser({required this.status, required this.userId, required this.name, required this.profileImage, required this.createdAt});

  factory ApiUser.fromJson(Map<dynamic, dynamic> json) {
    return ApiUser(
        status: json['status'],
        userId: json['userId'],
        name: json['name'],
        profileImage: json['profileImage'],
        createdAt: DateTime.parse(json['createdAt'])
    );
  }
}