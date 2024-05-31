import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:geolpo/utils/parser.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'api/alert_api.dart';
import 'api/auth_api.dart';
import 'api/subscribe_api.dart';
import 'dto/alert_dto.dart';
import 'dto/subscribe_dto.dart';
import 'widgets/league_widget.dart';

class Alarm extends StatefulWidget {
  @override
  State<Alarm> createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {

  List<Alert> alerts = List.empty();
  List<Subscribe> subscribes = List.empty();
  final List<AlertType> alertTypes = getAlertTypes();

  @override
  void initState() {
    _flush();
    super.initState();
  }

  void _flush() {
    getAlerts()
        .then((_) => alerts = _)
        .then((_) => getSubscribes())
        .then((_) => subscribes = _)
        .then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
                  child: const Row(
                    children: [
                      Text('내 알람',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold)),
                    ],
                  )
              ),
              getList(screenWidth)
            ],
          ),
        ),
      ),
    );
  }

  Widget getList(double screenWidth) {
    if (alerts.isEmpty) {
      return Container(
        padding: const EdgeInsets.fromLTRB(0, 100.0, 0, 100.0),
        child: const Column(
          children: [
            Text(
              '등록된 알람이 없습니다.',
              style: TextStyle(
                color: Colors.indigo,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
    return getAlarm(screenWidth);
  }

  Widget getAlarm(double screenWidth) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        final item = alerts[index];
        return Dismissible(
          key: Key(item.fixture.apiId.toString()),
          background: Container(
              color: Colors.redAccent,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Icon(Icons.delete_forever, color: Colors.white)
                  ),
                ],
              )),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            deleteAlert(item.fixture.apiId);
            setState(() {
              alerts.removeAt(index);
            });
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('${item.fixture.home!.name} vs ${item.fixture.away!.name} 경기 알람이 삭제되었습니다.'),
                backgroundColor: Colors.teal,
                duration: const Duration(milliseconds: 3000)
            ));
          },
          child: ListTile(
            contentPadding: const EdgeInsets.only(left: 10.0, right: 5.0),
            title: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: screenWidth * 0.4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getLeagueTile(item.fixture.league),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              '${item.fixture.home!.krName ?? item.fixture.home!.name} vs ${item.fixture.away!.krName ?? item.fixture.away!.name}',
                              style: const TextStyle(fontSize: 12.0),
                            ),
                          ),
                          Text(
                            DateFormat('y. M. d ${getKoreanWeekDay(item.fixture.date)} HH:mm')
                                .format(item.fixture.date),
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
                            child: Image.network(item.fixture.home!.logo, height: 50,),
                          ),
                          const Text('vs'),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Image.network(item.fixture.away!.logo, height: 50,),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.1,
                      child: IconButton(
                        icon: const Icon(Icons.alarm_on, color: Colors.teal),
                        onPressed: () {
                          Duration difference = item.fixture.date.difference(DateTime.timestamp().toLocal());
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
                      ))
                  ],
                ),
              ],
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    AlertType? selectedValue = getStrToType(item.alertType);
                    return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return AlertDialog(
                            title: const Text('알람 수정', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.indigo),),
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
                                          item.fixture.league!.logo,
                                          height: 30,),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                            '${item.fixture.league!.name} ${getKoreanRound(item.fixture.round)}'),
                                      )
                                    ],
                                  ),
                                  Text('${item.fixture.home!.krName} vs ${item.fixture.away!.krName}\n경기 알람 시간을 수정하시겠습니까?'),
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
                                            updateAlert(item.fixture.apiId, selectedValue).then((_) => {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text('알람이 수정되었습니다.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
                                                    backgroundColor: Colors.teal,
                                                    duration: Duration(milliseconds: 3000),))
                                            }).then((_) {
                                              _flush();
                                            });
                                          } catch(e) {
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                              content: Text('알람 수정에 실패하였습니다. 다시 시도해주세요.', textAlign: TextAlign.center,
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
            },
          ),
        );
      },
    );
  }

}