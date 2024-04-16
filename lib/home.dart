import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'dto/subscribe.dart';
import 'global.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String message = '';
  String? teamImageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: SizedBox()),
            teamImageUrl == null ? Image.asset('assets/saedaegal.gif') : Image.network(teamImageUrl!),
            Text(
              '${user.name}님 반갑습니다!', style: TextStyle(color: Colors.white),),
            SizedBox(height: 10,),
            Text(
              message, style: TextStyle(color: Colors.white),),
            SizedBox(height: 10,),
            FilledButton(onPressed: () {
              setState(() {
                checkSubscribe();
              });
            }, child: Text('구독정보 확인하기')),
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

  void checkSubscribe() async {
    final response = await http.get(Uri.parse('$baseUrl/api/subscribe/?type=TEAM'), headers: baseHeader);
    if (response.statusCode == 200) {
      message = response.body;
      dynamic body = jsonDecode(response.body);
      print(body);
      if (body is List && body.isNotEmpty) {
        Subscribe subscribe = Subscribe.fromJson(body.first);
        teamImageUrl = subscribe.team!.logo;
      }
    } else {
      message = '구독 정보가 없습니다.';
    }
  }

}