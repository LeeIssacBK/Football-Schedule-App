import 'package:flutter/material.dart';
import 'package:geolpo/dto/fixture.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:core';
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
  Fixture? nextFixture;

  @override
  void initState() {
    checkSubscribe()
        .then((_) => getSchedule())
        .then((_) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
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
        selectedItemColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Colors.white12,
                width: double.infinity,
                padding: const EdgeInsets.all(15.0),
                child: teamImageUrl == null ? const CircularProgressIndicator() :
                Image.network(teamImageUrl!, width: 200.0, height: 200.0),
              ),
              Container(
                color: Colors.blueGrey,
                width: double.infinity,
                padding: const EdgeInsets.all(5.0),
                child: const Text('다음 경기', style: TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold))
              ),
              Container(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: nextFixture != null ? [
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                      child: Image.network(isHome(nextFixture!.home!) ? nextFixture!.away!.logo : nextFixture!.home!.logo, width: 100.0,),
                    ),
                    Column(
                      children: [
                        Text('${nextFixture!.round.replaceAll(RegExp(r'[^0-9]'), '')} 라운드 (${isHome(nextFixture!.home!) ? '홈' : '원정'})', style: const TextStyle(fontSize: 15.0),),
                        Text(DateFormat('y. M. d, EEE HH:mm').format(nextFixture!.date), style: const TextStyle(fontSize: 15.0)),
                        Text(isHome(nextFixture!.home!) ? nextFixture!.away!.name : nextFixture!.home!.name, style: const TextStyle(fontSize: 15.0),),
                        Text(nextFixture!.status == 'FT' ? '${nextFixture!.homeGoal}'' : ''${nextFixture!.awayGoal} (${matchResult(nextFixture!)})' : '경기 전', style: const TextStyle(fontSize: 15.0),),
                      ],
                    ),
                  ] : [const CircularProgressIndicator()]
                ),
              ),
              Container(
                color: Colors.blueGrey,
                width: double.infinity,
                padding: const EdgeInsets.all(5.0),
                child: const Text('경기 일정', style: TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold))
              ),
              Column(
                children: fixtures != null && fixtures!.isNotEmpty ?
                  fixtures!.map((fixture) {
                    return Container(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                            child: Image.network(isHome(fixture.home!) ?
                            fixture.away!.logo : fixture.home!.logo, width: 100.0,),
                          ),
                          Column(
                            children: [
                              Text('${fixture.round.replaceAll(RegExp(r'[^0-9]'), '')} 라운드 (${isHome(fixture.home!) ? '홈' : '원정'})', style: const TextStyle(fontSize: 15.0),),
                              Text(DateFormat('y. M. d, EEE HH:mm').format(fixture.date), style: const TextStyle(fontSize: 15.0),),
                              Text(isHome(fixture.home!) ? fixture.away!.name : fixture.home!.name, style: const TextStyle(fontSize: 15.0),),
                              Text(fixture.status == 'FT' ? '${fixture.homeGoal}'' : ''${fixture.awayGoal} (${matchResult(fixture)})' : '경기 전', style: const TextStyle(fontSize: 15.0),),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList() : [const CircularProgressIndicator()]
              ),
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
      for (Fixture fixture in fixtures!) {
        if (fixture.status == 'NS') {
          nextFixture = fixture;
          break;
        }
      }
    }
  }

  bool isHome(Team team) {
    return subscribe?.team!.apiId == team.apiId;
  }

  String matchResult(Fixture fixture) {
    bool flag = isHome(fixture.home!);
    if (flag) {
      if (fixture.matchResult.contains('HOME')) {
        return '승';
      }
      if (fixture.matchResult.contains('AWAY')) {
        return '패';
      }
    } else {
      if (fixture.matchResult.contains('HOME')) {
        return '패';
      }
      if (fixture.matchResult.contains('AWAY')) {
        return '승';
      }
    }
    return '무승부';
  }

}