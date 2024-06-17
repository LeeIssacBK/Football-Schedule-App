import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolpo/api/api_filter.dart';
import 'package:geolpo/dto/api_user_dto.dart';
import 'package:geolpo/dto/auth_dto.dart';
import 'package:geolpo/main.dart';
import 'package:geolpo/styles/text_styles.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';


const String baseUrl = 'http://192.168.45.142:8090';
// const String baseUrl = 'http://3.36.31.202:8090';
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
    showDialog(context: navigatorKey.currentState!.context, builder: (BuildContext context) {
      return AlertDialog(
        content: Text('로그인 중 문제가 발생하였습니다.\n다시 시도해 주세요.', style: getAlertDialogContentStyle()),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('확인', style: getButtonTextColor())),
            ),
          ),
        ],
      );
    });
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

