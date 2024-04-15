import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'global.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: SizedBox()),
            Text(
              '${user.name}님 반갑습니다!', style: TextStyle(color: Colors.white),),
            SizedBox(height: 10,),
            Text(
              'access token ::: ${auth.accessToken}', style: TextStyle(color: Colors.white),),
            SizedBox(height: 10,),
            Text(
              'refresh token ::: ${auth.refreshToken}', style: TextStyle(color: Colors.white),),
            SizedBox(height: 10,),
            FilledButton(onPressed: () {
              setState(() {
                reissueToken();
              });
            }, child: Text('토큰 갱신하기')),
            Expanded(child: SizedBox()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: IconButton(
                    onPressed: () {}, icon: Icon(Icons.home))),
                Expanded(child: IconButton(
                    onPressed: () {}, icon: Icon(Icons.find_replace))),
                Expanded(child: IconButton(
                    onPressed: () {}, icon: Icon(Icons.face))),
              ],
            )
          ],
        ),
      ),
    );
  }
}