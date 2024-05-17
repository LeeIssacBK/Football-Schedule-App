import 'dart:async';
import 'dart:core';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geolpo/search.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dto/fixture.dart';
import 'dto/subscribe.dart';
import 'global.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'navibar.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool myTeamFlag = false;
  int sliderIndex = 0;
  List<Subscribe> subscribes = List.empty();
  List<Fixture> schedules = List.empty();
  double screenHeight = 0;
  double screenWidth = 0;

  @override
  void initState() {
    getSubscribes().then((_) =>
        getSchedule().then((_) =>
            setState(() {})));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  color: Colors.indigo,
                  width: double.infinity,
                  padding: const EdgeInsets.all(5.0),
                  height: 40.0,
                  child: Row(
                    children: [
                      Text(myTeamFlag ? '구독 팀 수정' : '내 구독 팀',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold)),
                      const Expanded(child: SizedBox()),
                      IconButton(
                        icon: myTeamFlag ? const Icon(Icons.exit_to_app, color: Colors.white) : const Icon(Icons.edit, color: Colors.white),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          myTeamFlag = !myTeamFlag;
                          setState(() {});
                        }
                      ),
                    ],
                  )
              ),
              myTeam(),
              Container(
                  color: Colors.indigo,
                  width: double.infinity,
                  padding: const EdgeInsets.all(5.0),
                  height: 40.0,
                  child: const Row(
                    children: [
                      Text('경기 일정',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold)),
                    ],
                  )),
              schedules.isEmpty
                  ? Container(
                      padding: const EdgeInsets.all(50.0),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '경기 정보를 찾을 수 없습니다.',
                            style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                        children: schedules.map((fixture) {
                          return Container(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: screenWidth * 0.4,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        fixture.league!.name,
                                        style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${fixture.home!.name} vs ${fixture.away!.name}',
                                        style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        DateFormat('y. M. d ${getKoreanWeekDay(fixture.date)} HH:mm')
                                            .format(fixture.date),
                                        style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.indigo),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.44,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Image.network(fixture.home!.logo, height: 50,),
                                      ),
                                      const Text('vs'),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Image.network(fixture.away!.logo, height: 50,),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.1,
                                  child: IconButton(
                                    onPressed: (){
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('알람 추가',
                                                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.indigo),
                                              ),
                                              contentTextStyle: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 15.0),
                                              content: Container(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(5.0),
                                                          child: Image.network(fixture.league!.logo, height: 30,),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.all(5.0),
                                                          child: Text('${fixture.league!.name} ${getKoreanRound(fixture.round)}'),
                                                        )
                                                      ],
                                                    ),
                                                    Text('${fixture.home!.name} vs ${fixture.away!.name} 경기를 알람 설정 하시겠습니까?'),
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(5.0),
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                          saveAlert(fixture.apiId).then((flag) => {
                                                            if (flag) {
                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                content: Text('알람 등록이 완료되었습니다!',
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(color: Colors.white),
                                                                ),
                                                                backgroundColor: Colors.teal,
                                                                duration: Duration(milliseconds: 1000),
                                                              ))
                                                            } else {
                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                content: Text('알람 등록이 실패하였습니다. 다시 시도해주세요.',
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(color: Colors.white),
                                                                ),
                                                                backgroundColor: Colors.redAccent,
                                                                duration: Duration(milliseconds: 1000),
                                                              ))
                                                            }
                                                          });
                                                        },
                                                        child: const Text('예'),
                                                      )
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(5.0),
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: const Text('아니오'),
                                                      )
                                                    )
                                                  ],
                                                )
                                              ],
                                            );
                                          });
                                    }, icon: fixture.isAlert ?
                                        const Icon(Icons.alarm_on, color: Colors.teal,) : const Icon(Icons.add_alarm)
                                  ),
                                )
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                  )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getSubscribes() async {
    final response = await http.get(
        Uri.parse('$baseUrl/api/subscribe/?type=TEAM'),
        headers: baseHeader);
    if (response.statusCode == 200) {
      dynamic body = jsonDecode(response.body);
      if (body is List && body.isNotEmpty) {
        subscribes = List<Subscribe>.from(
            json.decode(response.body).map((_) => Subscribe.fromJson(_)));
      }
    }
  }

  Future<bool> deleteSubscribe(int teamId) async {
    Map<String, String> requestHeader = baseHeader;
    requestHeader['Content-Type'] = 'application/json';
    final response = await http.delete(Uri.parse('$baseUrl/api/subscribe'),
        body: jsonEncode(SubscribeRequest(type: SubscribeType.TEAM.name, apiId: teamId).toJson()),
        headers: requestHeader);
    return response.statusCode == 200;
  }

  Future<void> getSchedule() async {
    final response = await http.get(Uri.parse('$baseUrl/api/fixture/subscribe'),
        headers: baseHeader);
    if (response.statusCode == 200) {
      schedules = List<Fixture>.from(
          json.decode(response.body).map((_) => Fixture.fromJson(_)));
    }
  }

  Future<bool> saveAlert(int apiId) async {
    final response = await http.post(Uri.parse('$baseUrl/api/alert?fixtureId=$apiId'),
        headers: baseHeader);
    return response.statusCode == 200;
  }

  Widget myTeam() {
    if (myTeamFlag) {
      List<Widget> teams = [];
      teams.add(TextButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => Navibar(selectedIndex: 1,)));
        },
        child: Row(children: [
          SizedBox(width: screenWidth * 0.5, child: const Text('팀 추가', style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold))),
          const Expanded(child: SizedBox()),
          SizedBox(width: screenWidth * 0.1, child: const Icon(Icons.add))
        ]),
      ));
      teams.addAll(subscribes.map((subscribe) {
        return TextButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('팀 구독 취소하기', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.indigo),),
                    contentTextStyle: const TextStyle(color: Colors.indigo),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${subscribe.team!.name} 팀의 구독을 취소하시겠습니까?'),
                      ],
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ElevatedButton(
                              onPressed: () {
                                deleteSubscribe(subscribe.team!.apiId).then((flag) => {
                                  if (flag) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('팀 구독이 취소 되었습니다!',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: Colors.teal,
                                          duration: Duration(milliseconds: 1000),
                                        )
                                    )
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('구독 취소 실패! 다시 시도해 주세요.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: Colors.redAccent,
                                          duration: Duration(milliseconds: 1000),
                                        )
                                    )
                                  }
                                }).then((_){
                                  Navigator.of(context).pop();
                                  _refresh();
                                });
                              },
                              child: const Text('예'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('아니오'),
                            ),
                          )
                        ],
                      )
                    ],
                  );
                });
          },
          child: Row(children: [
            SizedBox(width: screenWidth * 0.1, child: Padding(padding: const EdgeInsets.all(5.0), child: Image.network(subscribe.team!.logo),)),
            SizedBox(width: screenWidth * 0.4, child: Text(subscribe.team!.name, style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold))),
            const Expanded(child: SizedBox()),
            SizedBox(width: screenWidth * 0.1, child: const Icon(Icons.remove))
          ],),
        );
      }).toList());
      return Container(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: teams
        ),
      );
    }
    if (subscribes.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(50.0),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '구독된 팀이 없습니다.',
              style: TextStyle(
                color: Colors.indigo,
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
    if (subscribes.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            slider(screenHeight / 3.8),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: indicator(subscribes),
              ),
            ),
          ],
        ),
      );
    }
    throw Exception('undefined container');
  }

  Widget slider(height) {
    List<Column> images = subscribes.map((subscribe) {
      return Column(
        children: [
          IconButton(
            onPressed: () {

            },
            icon: Image.network(subscribe.team!.logo)
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(subscribe.team!.name,
                style: const TextStyle(
                    color: Colors.indigo,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      );
    }).toList();
    return CarouselSlider(
        items: images,
        options: CarouselOptions(
            height: height,
            autoPlay: images.length > 1,
            viewportFraction: 1,
            enlargeCenterPage: false,
            initialPage: sliderIndex,
            onPageChanged: (index, reason) => setState(() {
              sliderIndex = index;
            })
        )
    );
  }

  Widget indicator(List<Subscribe>? subscribes) => Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      alignment: Alignment.bottomCenter,
      child: AnimatedSmoothIndicator(
        activeIndex: sliderIndex,
        count: subscribes!.length,
        effect: JumpingDotEffect(
            dotHeight: 6,
            dotWidth: 6,
            activeDotColor: Colors.grey,
            dotColor: Colors.grey.withOpacity(0.6)),
      )
  );

  void _refresh() {
    getSchedule().then((_) =>
        getSubscribes().then((_) =>
            setState((){})));
  }

}
