import 'dart:core';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geolpo/styles/text_styles.dart';
import 'package:geolpo/team.dart';
import 'package:geolpo/utils/parser.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'api/alert_api.dart';
import 'api/schedule_api.dart';
import 'api/subscribe_api.dart';
import 'dto/alert_dto.dart';
import 'dto/fixture_dto.dart';
import 'dto/subscribe_dto.dart';
import 'navibar.dart';
import 'widgets/league_widget.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool myTeamFlag = false;
  int sliderIndex = 0;
  List<Subscribe> subscribes = List.empty();
  List<Fixture> schedules = List.empty();

  @override
  void initState() {
    super.initState();
    _flush();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
                      Text(myTeamFlag ? '구독 수정' : '내 구독 팀', style: getMainFont()),
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
              myTeam(screenWidth, screenHeight),
              Container(
                  color: Colors.indigo,
                  width: double.infinity,
                  padding: const EdgeInsets.all(5.0),
                  height: 40.0,
                  child: Row(
                    children: [
                      Text('경기 일정', style: getMainFont()),
                    ],
                  )
              ),
              schedules.isEmpty
                  ? Container(
                      padding: const EdgeInsets.all(50.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('경기 정보를 찾을 수 없습니다.', style: getMainFont(),),
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
                                                  title: Text('알람 추가', style: getAlertDialogTitleStyle()),
                                                  contentTextStyle: getAlertDialogContentStyle(),
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
                                                        Text('${fixture.home!.krName ?? fixture.home!.name} vs ${fixture.away!.krName ?? fixture.away!.name}\n경기를 알람 설정 하시겠습니까?'),
                                                        DropdownButton(
                                                            isExpanded: true,
                                                            hint: const Text('알람 시간 설정', style: TextStyle(color: Colors.indigo)),
                                                            style: const TextStyle(color: Colors.indigo),
                                                            underline: Container(
                                                              height: 2,
                                                              color: Colors.indigoAccent,
                                                            ),
                                                            value: selectedValue,
                                                            items: getAlertTypes().map<DropdownMenuItem<AlertType>>((AlertType value) {
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
                                                                    _flush();
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

  Widget myTeam(double screenWidth, double screenHeight) {
    if (myTeamFlag) {
      List<Widget> teams = [];
      teams.add(TextButton(
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Navibar(selectedIndex: 1,)));
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
                    title: Text('팀 구독 취소하기', style: getAlertDialogTitleStyle()),
                    contentTextStyle: getAlertDialogContentStyle(),
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
                                }).then((_) {
                                  Navigator.of(context).pop();
                                  _flush();
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => TeamInfo(teamId: subscribe.team!.apiId)));
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

  void _flush() {
    getSubscribes()
        .then((_) => subscribes = _)
        .then((_) => getSchedule()
        .then((_) => schedules = _)
        .then((_) => setState(() {})));
  }

}
