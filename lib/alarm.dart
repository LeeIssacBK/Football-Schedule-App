import 'dart:core';
import 'dart:convert';

import 'package:flutter/gestures.dart';
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

  List<Alert> alerts = List.empty();

  @override
  void initState() {
    getAlerts()
        .then((_) => setState(() {}));
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
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: alerts.length,
        itemBuilder: (context, index) {
          final item = alerts[index];
          return Container(
            width: screenWidth * 0.1,
            child: Dismissible(
              key: Key(item.fixture.apiId.toString()),
              // Dismissible의 배경색 설정
              background: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('삭제', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ), color: Colors.redAccent),
              // Dismissible이 Swipe될 때 호출. Swipe된 방향을 아규먼트로 수신
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                // 해당 index의 item을 리스트에서 삭제
                setState(() {
                  alerts.removeAt(index);
                });
                // 삭제한 아이템을 스낵바로 출력
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("${item.fixture.apiId} dismissed")));
              },
              // Dismissible의 자식으로 리스트타일을 생성. 리스튜뷰에 타일로 등록
              child: ListTile(title: Text(item.fixture.home!.name)),
            ),
          );
        },
    );

        // return Column(
        //   children: alerts.map((alert) {
        //     Fixture fixture = alert.fixture;
        //       return Container(
        //         padding: const EdgeInsets.all(5.0),
        //         child: Row(
        //           children: [
        //             SizedBox(
        //               width: screenWidth * 0.4,
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Text(
        //                     fixture.league!.name,
        //                     style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
        //                   ),
        //                   Text(
        //                     getKoreanRound(fixture.round),
        //                     style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
        //                   ),
        //                   Text(
        //                     DateFormat('y. M. d ${getKoreanWeekDay(fixture.date)} HH:mm')
        //                         .format(fixture.date),
        //                     style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
        //                   ),
        //                   Text(
        //                       fixture.home!.stadium,
        //                       style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
        //                       overflow: TextOverflow.ellipsis
        //                   ),
        //                 ],
        //               ),
        //             ),
        //             SizedBox(
        //               width: screenWidth * 0.44,
        //               child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   Padding(
        //                     padding: const EdgeInsets.all(5.0),
        //                     child: Image.network(fixture.home!.logo, height: 50,),
        //                   ),
        //                   const Text('vs'),
        //                   Padding(
        //                     padding: const EdgeInsets.all(5.0),
        //                     child: Image.network(fixture.away!.logo, height: 50,),
        //                   )
        //                 ],
        //               ),
        //             ),
        //             // SizedBox(
        //             //   width: screenWidth * 0.1,
        //             //   child: null
        //             // )
        //           ],
        //         ),
        //       );
        //     }).toList()
        // );
  }

  Future<void> getAlerts() async {
    final response = await http.get(Uri.parse('$baseUrl/api/alert'), headers: baseHeader);
    if (response.statusCode == 200) {
      alerts = List<Alert>.from(json
          .decode(utf8.decode(response.bodyBytes))
          .map((_) => Alert.fromJson(_)));
    }
  }

}