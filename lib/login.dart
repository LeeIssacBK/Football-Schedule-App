import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home.dart';

class Login extends StatelessWidget {

  final String url = 'https://kauth.kakao.com/oauth/authorize?client_id=be34591b9514798eec7010a400ecca1a&redirect_uri=http://localhost:8090/oauth/kakao&response_type=code';

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.black12,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: SizedBox()),
                IconButton(
                  onPressed: () {
                    kakaoLogin();
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => Home()));
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
      }
    );
  }

  Future<void> kakaoLogin() async {
    final response = await http.get(Uri.parse(url));
  }

}
