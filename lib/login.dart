import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolpo/navibar.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import 'api/apiUser.dart';
import 'api/auth.dart';
import 'global.dart';

class Login extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        backgroundColor: Colors.indigo,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(child: SizedBox()),
              IconButton(
                onPressed: () {
                  kakaoLogin().then((_) => Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => Navibar(selectedIndex: 0,))));
                },
                icon: const Image(
                    image: AssetImage('image/kakao_login_medium_narrow.png')),
              ),
              const Expanded(child: SizedBox()),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text("© Copyright 2024, 이병규",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                      )),
                ),
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
