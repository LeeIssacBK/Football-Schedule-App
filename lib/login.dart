import 'package:flutter/material.dart';
import 'home.dart';

class Login extends StatelessWidget {
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
}
