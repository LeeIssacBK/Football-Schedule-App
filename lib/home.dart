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
  void initState() {
    super.initState();
    checkSubscribe()
        .then((_) => getSchedule())
        .then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '홈'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.find_replace),
            label: '검색'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '마이페이지'
          ),
        ],
        selectedItemColor: Colors.lightGreen,
      ),
      backgroundColor: Colors.black12,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              teamImageUrl == null ? CircularProgressIndicator() : Image.network(teamImageUrl!),
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
                            Text('${fixture.date}', style: TextStyle(color: Colors.white, fontSize: 20.0),),
                          ],
                        )
                      ],
                    );
                  }).toList() : [CircularProgressIndicator()]
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkSubscribe() async {
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

  Future<void> getSchedule() async {
    final response = await http.get(
        Uri.parse('$baseUrl/api/fixture?teamId=${subscribe?.team!.apiId}'),
        headers: baseHeader);
    if (response.statusCode == 200) {
      fixtures = List<Fixture>.from(json.decode(response.body).map((_) => Fixture.fromJson(_)));
    }
  }

}