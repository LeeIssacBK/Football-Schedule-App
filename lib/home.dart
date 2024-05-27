import 'dart:convert';
import 'dart:core';
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'dto/alert.dart';
import 'dto/fixture.dart';
import 'dto/subscribe.dart';
import 'global.dart';
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
  final List<AlertType> alertTypes = getAlertTypes();

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
                      Text(myTeamFlag ? '구독 수정' : '내 구독 팀',
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
                                      getLeagueTile(fixture.league),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5.0),
                                        child: Text(
                                          '${fixture.home!.krName ?? fixture.home!.name} vs ${fixture.away!.krName ?? fixture.away!.name}',
                                          style: const TextStyle(fontSize: 12.0),
                                        ),
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
                                  child: fixture.isAlert ? IconButton(
                                    icon: const Icon(Icons.alarm_on, color: Colors.teal),
                                    onPressed: () {
                                      Duration difference = fixture.date.difference(DateTime.timestamp().toLocal());
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(
                                          '경기시작까지 '
                                          '${difference.inDays}일 '
                                          '${difference.inHours % 24}시간 '
                                          '${difference.inMinutes % 60}분 남았습니다.',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.teal,
                                        duration: const Duration(milliseconds: 3000),
                                      ));
                                    },
                                  ) :
                                  IconButton(
                                    onPressed: (){
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            AlertType? selectedValue;
                                            return StatefulBuilder(
                                              builder: (BuildContext context, StateSetter setState) {
                                                return AlertDialog(
                                                  title: const Text('알람 추가', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.indigo),),
                                                  contentTextStyle: const TextStyle(color: Colors.indigo, fontSize: 15.0),
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
                                                              child: Image.network(
                                                                fixture.league!.logo,
                                                                height: 30,),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.all(5.0),
                                                              child: Text(
                                                                  '${fixture.league!.name} ${getKoreanRound(fixture.round)}'),
                                                            )
                                                          ],
                                                        ),
                                                        Text('${fixture.home!.krName ?? fixture.home!.name} vs ${fixture.away!.krName ?? fixture.away!.name} 경기를 알람 설정 하시겠습니까?'),
                                                        DropdownButton(
                                                            isExpanded: true,
                                                            hint: const Text('알람 시간 설정', style: TextStyle(color: Colors.indigo)),
                                                            style: const TextStyle(color: Colors.indigo),
                                                            underline: Container(
                                                              height: 2,
                                                              color: Colors.indigoAccent,
                                                            ),
                                                            value: selectedValue,
                                                            items: alertTypes.map<DropdownMenuItem<AlertType>>((AlertType value) {
                                                              return DropdownMenuItem<AlertType>(
                                                                value: value,
                                                                child: Text(value.name),
                                                              );
                                                            }).toList(),
                                                            onChanged: (AlertType? newValue) {
                                                              setState(() {
                                                                selectedValue = newValue;
                                                              });
                                                            }),
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
                                                                try {
                                                                  saveAlert(fixture.apiId, selectedValue).then((_) => {
                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                        const SnackBar(
                                                                          content: Text('알람이 등록되었습니다.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
                                                                          backgroundColor: Colors.teal,
                                                                          duration: Duration(milliseconds: 3000),))
                                                                  }).then((_) {
                                                                    _refresh();
                                                                  });
                                                                } catch(e) {
                                                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                    content: Text('알람 등록이 실패하였습니다. 다시 시도해주세요.', textAlign: TextAlign.center,
                                                                      style: TextStyle(color: Colors.white),),
                                                                    backgroundColor: Colors.redAccent,
                                                                    duration: Duration(milliseconds: 3000),));
                                                                }
                                                                Navigator.of(context).pop();
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
                                              }
                                            );
                                          });
                                    }, icon: const Icon(Icons.add_alarm)
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
      dynamic body = jsonDecode(utf8.decode(response.bodyBytes));
      if (body is List && body.isNotEmpty) {
        subscribes = List<Subscribe>.from(body.map((_) => Subscribe.fromJson(_)));
      }
    }
  }

  Future<bool> deleteSubscribe(int teamId) async {
    Map<String, String> requestHeader = baseHeader;
    requestHeader['Content-Type'] = 'application/json';
    final response = await http.delete(Uri.parse('$baseUrl/api/subscribe'),
        body: jsonEncode(SubscribeRequest(type: SubscribeType.TEAM.name, apiId: teamId)),
        headers: requestHeader);
    return response.statusCode == 200;
  }

  Future<void> getSchedule() async {
    final response = await http.get(Uri.parse('$baseUrl/api/fixture/subscribe'),
        headers: baseHeader);
    if (response.statusCode == 200) {
      schedules = List<Fixture>.from(
          json.decode(utf8.decode(response.bodyBytes)).map((_) => Fixture.fromJson(_)));
    }
  }

  Future<void> saveAlert(int apiId, AlertType? alertType) async {
    Map<String, String> requestHeader = baseHeader;
    requestHeader['Content-Type'] = 'application/json';
    alertType = alertType ?? alertTypes.first;
    final response = await http.post(Uri.parse('$baseUrl/api/alert'),
        body: jsonEncode(AlertRequest(fixtureId: apiId, alertType: alertType.type)),
        headers: baseHeader);
    if (response.statusCode != 200) {
      throw Exception('$response.statusCode error');
    }
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
                    contentTextStyle: const TextStyle(color: Colors.indigo, fontSize: 15.0),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('이미 추가된 경기 알람은 취소되지 않습니다.\n'
                             '${subscribe.team!.krName ?? subscribe.team!.name} 의 구독을 취소하시겠습니까?'),
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
                                          duration: Duration(milliseconds: 3000),
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
            SizedBox(width: screenWidth * 0.4, child: Text(subscribe.team!.krName ?? subscribe.team!.name, style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold))),
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
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: const Text('팀 상세', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.indigo),),
                        contentTextStyle: const TextStyle(fontSize: 15.0, color: Colors.indigo),
                        content: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('리그\n'),
                                Text(subscribe.league != null ? subscribe.league!.name : ''),
                              ],
                            ),
                            Row(
                              children: [
                                Text('팀명\n'),
                                Text(subscribe.team!.krName ?? subscribe.team!.name),
                              ],
                            ),
                            Row(
                              children: [
                                Text('연고\n'),
                                Text(subscribe.team!.city ?? ''),
                              ],
                            ),
                            Row(
                              children: [
                                Text('홈 구장\n'),
                                Text(subscribe.team!.stadium ?? ''),
                              ],
                            ),
                            Row(
                              children: [
                                Text('최근 5경기\n'),
                              ],
                            ),
                            Row(
                              children: [
                                Text('감독\n'),
                              ],
                            ),
                            Row(
                              children: [
                                Text('선수 명단\n'),
                              ],
                            ),
                          ],
                        ),
                      actions: [
                        Center(
                          child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('확인'),
                              )
                          ),
                        )
                      ],
                    );
                  }
              );
            },
            icon: Image.network(subscribe.team!.logo)
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(subscribe.team!.krName ?? subscribe.team!.name,
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
