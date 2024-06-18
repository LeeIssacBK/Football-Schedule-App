import 'package:flutter/material.dart';
import 'package:geolpo/support.dart';
import 'package:geolpo/myinfo.dart';
import 'package:geolpo/styles/text_styles.dart';
import 'package:geolpo/widgets/global_widget.dart';
import 'package:intl/intl.dart';

import 'api/auth_api.dart';
import 'login.dart';

class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            getGlobalLine('마이페이지', getMainFont()),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                  )
                )
              ),
              padding: const EdgeInsets.all(30.0),
              margin: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: Image.network(user!.profileImage ?? '').image,
                    backgroundColor: Colors.white,
                    radius: 80.0,
                  ),
                ],
              ),
            ),
            TextButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyInfo()));
            },
              child: Text('내 정보', style: getMyPageFont())), //가입수단(카카오, 네이버), 가입일자, 구독팀 수, 누적 알람 수
            TextButton(onPressed: () {},
                child: Text('Q & A', style: getMyPageFont())),  //이용방법
            TextButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Support()));
            },
                child: Text('문의', style: getMyPageFont())),  //
            TextButton(onPressed: () => deleteToken().then((_) => logout()),
              child: Text('로그아웃', style: getMyPageFont()))
          ],
        ),
      )
    );
  }

  void logout() {
    auth = null;
    user = null;
    baseHeader = {};
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
  }

}