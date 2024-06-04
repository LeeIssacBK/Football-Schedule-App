import 'dart:convert';

import 'package:geolpo/api/api_filter.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import '../dto/api_user_dto.dart';
import '../dto/auth_dto.dart';

const String baseUrl = 'http://192.168.45.236:8090'; //집
// const String baseUrl = 'http://172.30.1.76:8090'; //집
late Auth? auth;
late ApiUser? user;
Map<String, String> baseHeader = {};


Future<void> kakaoLogin() async {
  try {
    bool isInstalled = await isKakaoTalkInstalled();
    OAuthToken kakaoOauth = isInstalled
        ? await UserApi.instance.loginWithKakaoTalk()
        : await UserApi.instance.loginWithKakaoAccount();
    final authResponse = await http.get(Uri.parse('$baseUrl/oauth/kakao?token=${kakaoOauth.accessToken}'));
    if (authResponse.statusCode == 200) {
      auth = Auth.fromJson(json.decode(authResponse.body));
    }
    baseHeader['Authorization'] = 'Bearer ${auth!.accessToken}';
    final userInfoResponse = await http.get(Uri.parse('$baseUrl/oauth/me'), headers: baseHeader);
    user = ApiUser.fromJson(json.decode(utf8.decode(userInfoResponse.bodyBytes)));
  } catch (e) {
    rethrow;
  }
}

void reissueToken() async {
  baseHeader['RefreshToken'] = auth!.refreshToken;
  final response = processResponse(await http.post(Uri.parse('$baseUrl/oauth/reissue'), headers: baseHeader));
  auth = Auth.fromJson(json.decode(response.body));
}

Future<void> deleteToken() async {
  baseHeader['RefreshToken'] = auth!.refreshToken;
  processResponse(await http.delete(Uri.parse('$baseUrl/oauth/logout'), headers: baseHeader));
}
