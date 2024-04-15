class ApiUser {
  final int id;
  final String userId;
  final String name;

  ApiUser({required this.id, required this.userId, required this.name});

  factory ApiUser.fromJson(Map<dynamic, dynamic> json) {
    return ApiUser(
        id: json['id'],
        userId: json['userId'],
        name: json['name']
    );
  }
}