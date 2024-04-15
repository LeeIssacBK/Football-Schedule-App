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
                  kakaoLogin(context);
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

  Future<void> kakaoLogin(BuildContext context) async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      OAuthToken token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      final response = await http.get(Uri.parse('$baseUrl/oauth/kakao?token=${token.accessToken}'));
      if (response.statusCode == 200) {
        auth = Auth.fromJson(json.decode(response.body));
        baseHeader['Authorization'] = 'Bearer ${auth.accessToken}';
        final me = await http.get(Uri.parse('$baseUrl/oauth/me'), headers: baseHeader);
        user = ApiUser.fromJson(json.decode(utf8.decode(me.bodyBytes)));
      }
    } catch (e) {
      print('error ::: ${e}');
    }

    Navigator.push(
        context, MaterialPageRoute(builder: (_) => Home()));
  }

}
