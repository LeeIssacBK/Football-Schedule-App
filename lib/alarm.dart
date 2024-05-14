import 'dart:core';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'dto/alert.dart';
import 'dto/fixture.dart';
import 'global.dart';

class Alarm extends StatefulWidget {
  @override
  State<Alarm> createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {

  @override
  void initState() {
    super.initState();
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
              Container(
                padding: const EdgeInsets.all(5.0),
                child: getList(screenWidth),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getList(double screenWidth) {
    return FutureBuilder<List<Alert>>(
      future: getAlerts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        List<Alert> alerts = snapshot.data!;
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
        return Column(
          children: alerts.map((alert) {
            Fixture fixture = alert.fixture;
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
                            getKoreanRound(fixture.round),
                            style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            DateFormat('y. M. d ${getKoreanWeekDay(fixture.date)} HH:mm')
                                .format(fixture.date),
                            style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                              fixture.home!.stadium,
                              style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis
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
                                                  // saveAlert(fixture.apiId).then((flag) => {
                                                  //   if (flag) {
                                                  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                  //       content: Text('알람 등록이 완료되었습니다!',
                                                  //         textAlign: TextAlign.center,
                                                  //         style: TextStyle(color: Colors.white),
                                                  //       ),
                                                  //       backgroundColor: Colors.teal,
                                                  //       duration: Duration(milliseconds: 1000),
                                                  //     ))
                                                  //   } else {
                                                  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                  //       content: Text('알람 등록이 실패하였습니다. 다시 시도해주세요.',
                                                  //         textAlign: TextAlign.center,
                                                  //         style: TextStyle(color: Colors.white),
                                                  //       ),
                                                  //       backgroundColor: Colors.redAccent,
                                                  //       duration: Duration(milliseconds: 1000),
                                                  //     ))
                                                  //   }
                                                  // });
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
            }).toList()
        );
      }
    );
  }

  Future<List<Alert>> getAlerts() async {
    final response = await http.get(Uri.parse('$baseUrl/api/alert'), headers: baseHeader);
    if (response.statusCode == 200) {
      return List<Alert>.from(json
          .decode(utf8.decode(response.bodyBytes))
          .map((_) => Alert.fromJson(_)));
    }
    return List.empty();
  }

}