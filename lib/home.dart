import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolpo/dto/fixture.dart';
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
  late Subscribe? subscribe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: SizedBox()),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(onPressed: () {
                    setState(() {
                      checkSubscribe();
                    });
                  }, child: Text('구독정보 확인하기')),
                  SizedBox(width: 20.0,),
                  FilledButton(onPressed: () {
                    setState(() {
                      getSchedule();
                    });
                  }, child: Text('경기 일정 확인하기')),
                ]
            ),
            teamImageUrl == null ? Image.asset('assets/saedaegal.gif') : Image.network(teamImageUrl!),
            Text(
              '${user.name}님 반갑습니다!', style: TextStyle(color: Colors.white, fontSize: 20.0),),
            SizedBox(height: 10,),
            Text(
              message, style: TextStyle(color: Colors.white),),
            SizedBox(height: 10,),
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
      dynamic body = jsonDecode(response.body);
      if (body is List && body.isNotEmpty) {
        subscribe = Subscribe.fromJson(body.first);
        teamImageUrl = subscribe?.team!.logo;
      }
    } else {
      message = '구독 정보가 없습니다.';
    }
  }

  void getSchedule() async {
    final response = await http.get(Uri.parse('$baseUrl/api/fixture?teamId=${subscribe?.team!.apiId}'), headers: baseHeader);
    print(response);
    if (response.statusCode == 200) {
      List<Fixture> fixtures = List<Fixture>.from(json.decode(response.body).map((model) => Fixture.fromJson(model)));
      fixtures.forEach((v) {
        print('round : ${v.round} | status : ${v.status} | match : ${v.home?.name} vs ${v.away?.name} | date : ${v.date}');
      });
    }
  }

}