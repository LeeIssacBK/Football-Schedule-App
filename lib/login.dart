import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:http/http.dart' as http;
import 'api/auth.dart';
import 'api/apiUser.dart';
import 'global.dart';
import 'home.dart';

class Login extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        backgroundColor: Colors.black12,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: SizedBox()),
              IconButton(
                onPressed: () {
                  kakaoLogin().then((_) => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => Home())));
                },
                icon: Image(
                    image: AssetImage('image/kakao_login_medium_narrow.png')),
              ),
              Expanded(child: SizedBox()),
              Center(
                child: Text("© Copyright 2024, 이병규",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                    )),
              )
            ],
          ),
        ),
      );
    });
  }

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
      print(auth.accessToken);
      baseHeader['Authorization'] = 'Bearer ${auth.accessToken}';
      final userInfoResponse = await http.get(Uri.parse('$baseUrl/oauth/me'), headers: baseHeader);
      user = ApiUser.fromJson(json.decode(utf8.decode(userInfoResponse.bodyBytes)));
    } catch (e) {
      rethrow;
    }
  }

}
