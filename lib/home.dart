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

  String? teamImageUrl;
  Subscribe? subscribe;
  List<Fixture>? fixtures;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${user.name}님 반갑습니다!',
                style: TextStyle(color: Colors.white, fontSize: 20.0),),
              teamImageUrl == null ? Image.asset('assets/saedaegal.gif') : Image
                  .network(teamImageUrl!),
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
              SizedBox(height: 10,),
              Row(
                children: [
                  Text('다음 경기', style: TextStyle(color: Colors.white, fontSize: 20.0),),
                ],
              ),
              Column(
                children: fixtures != null && fixtures!.isNotEmpty ?
                  fixtures!.map((fixture) {
                    return Row(
                      children: [
                        Image.network(subscribe?.team!.apiId == fixture.home!.apiId ?
                        fixture.away!.logo : fixture.home!.logo, width: 130.0,),
                        Column(
                          children: [
                            Text('${fixture.round}', style: TextStyle(color: Colors.white, fontSize: 20.0),),
                            Text('data', style: TextStyle(color: Colors.white, fontSize: 20.0),),
                          ],
                        )
                      ],
                    );
                  }).toList() : [CircularProgressIndicator()]
              ),
              SizedBox(height: 10,),
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
      ),
    );
  }

  void checkSubscribe() async {
    final response = await http.get(
        Uri.parse('$baseUrl/api/subscribe/?type=TEAM'), headers: baseHeader);
    if (response.statusCode == 200) {
      dynamic body = jsonDecode(response.body);
      if (body is List && body.isNotEmpty) {
        subscribe = Subscribe.fromJson(body.first);
        teamImageUrl = subscribe?.team!.logo;
      }
    }
  }

  void getSchedule() async {
    final response = await http.get(
        Uri.parse('$baseUrl/api/fixture?teamId=${subscribe?.team!.apiId}'),
        headers: baseHeader);
    print(response);
    if (response.statusCode == 200) {
      fixtures = List<Fixture>.from(json.decode(response.body).map((_) => Fixture.fromJson(_)));
      // fixtures.forEach((v) {
      //   print('round : ${v.round} | status : ${v.status} | match : ${v.home
      //       ?.name} vs ${v.away?.name} | date : ${v.date}');
      // });
    }
  }

}