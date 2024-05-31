import 'package:flutter/material.dart';
import 'package:geolpo/navibar.dart';

import 'api/auth_api.dart';

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

}
