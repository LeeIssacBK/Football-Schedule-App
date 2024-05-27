class ApiUser {
  final int id;
  final String userId;
  final String name;
  final String? profileImage;

  ApiUser({required this.id, required this.userId, required this.name, required this.profileImage});

  factory ApiUser.fromJson(Map<dynamic, dynamic> json) {
    return ApiUser(
        id: json['id'],
        userId: json['userId'],
        name: json['name'],
        profileImage: json['profileImage']
    );
  }
}