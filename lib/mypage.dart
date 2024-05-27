import 'package:flutter/material.dart';

import 'global.dart';

class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _SearchState();
}

class _SearchState extends State<MyPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: Image.network(user.profileImage ?? '').image,
                    backgroundColor: Colors.white,
                    radius: 60.0,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.indigo),)
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5.0),
              margin: const EdgeInsets.all(5.0),
              child: const Text('내 정보', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.indigo),),
            ),
            Container(
              padding: const EdgeInsets.all(5.0),
              margin: const EdgeInsets.all(5.0),
              child: const Text('알림 설정', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.indigo)),
            ),
            Container(
              padding: const EdgeInsets.all(5.0),
              margin: const EdgeInsets.all(5.0),
              child: const Text('오류제보', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.indigo)),
            ),
            Container(
              padding: const EdgeInsets.all(5.0),
              margin: const EdgeInsets.all(5.0),
              child: const Text('로그아웃', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.indigo)),
            ),
          ],
        ),
      )
    );
  }

}