class Auth {
  final String accessToken;
  final String refreshToken;

  Auth({required this.accessToken, required this.refreshToken});

  factory Auth.fromJson(Map<dynamic, dynamic> json) {
    return Auth(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken']
    );
  }
}