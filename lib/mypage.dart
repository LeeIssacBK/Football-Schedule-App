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
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                  )
                )
              ),
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
                    child: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),)
                  )
                ],
              ),
            ),
            Container(
              child: TextButton(onPressed: () {  },
                child: const Text('내 정보', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0, color: Colors.indigo),)),
            ),
            Container(
              child: TextButton(onPressed: () {  },
                child: const Text('알림 설정', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0, color: Colors.indigo))),
            ),
            Container(
              child: TextButton(onPressed: () {  },
                child: const Text('오류제보', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0, color: Colors.indigo))),
            ),
            Container(
              child: TextButton(onPressed: () {  },
                child: const Text('로그아웃', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0, color: Colors.indigo))),
            ),
            const Expanded(child: SizedBox()),
            Container(
              color: Colors.grey,
              width: double.infinity,
              padding: const EdgeInsets.all(5.0),
              child: Center(child: Text('회원가입일 : ${user.userId}', style: const TextStyle(color: Colors.white))),
            ),
          ],
        ),
      )
    );
  }

}