import 'dart:convert';

import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:geolpo/api/api_filter.dart';
import 'package:geolpo/dto/api_user_dto.dart';
import 'package:geolpo/dto/auth_dto.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

const String baseUrl = 'http://172.30.1.73:8090';
// const String baseUrl = 'http://13.209.12.8:8090';
late Auth? auth;
late ApiUser? user;
Map<String, String> baseHeader = {};
String exceptionMessage = '로그인 중 문제가 발생하였습니다.\n다시 시도해 주세요.';

Future<void> kakaoLogin() async {
  bool isInstalled = await isKakaoTalkInstalled();
  OAuthToken kakaoOauth = isInstalled
      ? await UserApi.instance.loginWithKakaoTalk()
      : await UserApi.instance.loginWithKakaoAccount();
  final authResponse = await http.get(Uri.parse('$baseUrl/oauth/kakao?token=${kakaoOauth.accessToken}'));
  if (authResponse.statusCode == 200) {
    baseHeader['Authorization'] = 'Bearer ${Auth.fromJson(json.decode(authResponse.body)).accessToken}';
    validateUser();
  } else {
    throw Exception('auth response invalid');
  }
}

Future<void> naverLogin() async {
  final NaverLoginResult naverOauth = await FlutterNaverLogin.logIn();
  if (NaverLoginStatus.loggedIn == naverOauth.status) {
    Map<String, String> requestHeader = baseHeader;
    requestHeader['Content-Type'] = 'application/json';
    final authResponse = await http.post(Uri.parse('$baseUrl/oauth/naver'),
        headers: requestHeader,
        body: jsonEncode(
            {
              'id' : naverOauth.account.id,
              'name' : naverOauth.account.name,
              'nickname' : naverOauth.account.nickname,
              'email' : naverOauth.account.email,
              'profileImage' : naverOauth.account.profileImage,
            }
        )
    );
    if (authResponse.statusCode == 200) {
      baseHeader['Authorization'] = 'Bearer ${Auth.fromJson(json.decode(authResponse.body)).accessToken}';
      validateUser();
    } else {
      throw Exception('naver login status invalid');
    }
  }
}

void validateUser() async {
  final userInfoResponse = await http.get(Uri.parse('$baseUrl/oauth/me'), headers: baseHeader);
  user = ApiUser.fromJson(json.decode(utf8.decode(userInfoResponse.bodyBytes)));
  if ('ENABLED' != user!.status) {
    exceptionMessage = '탈퇴 3일 후 재가입 가능합니다.';
    throw Exception('user status invalid');
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

