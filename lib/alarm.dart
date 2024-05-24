import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'dto/alert.dart';
import 'dto/subscribe.dart';
import 'global.dart';

class Alarm extends StatefulWidget {
  @override
  State<Alarm> createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {

  List<Alert> alerts = List.empty();
  List<Subscribe> subscribes = List.empty();
  List<int> myTeamIds = List.empty();
  final List<AlertType> alertTypes = getAlertTypes();

  @override
  void initState() {
    getAlerts().then((_) => {
      getSubscribes()}).then((_) =>
        setState(() {}));
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
        itemCount: alerts.length,
        itemBuilder: (context, index) {
          final item = alerts[index];
          return Dismissible(
            key: Key(item.fixture.apiId.toString()),
            // Dismissible의 배경색 설정
            background: Container(
              color: Colors.redAccent,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Text('삭제', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              )),
            direction: DismissDirection.endToStart,
            // Dismissible이 Swipe될 때 호출. Swipe된 방향을 아규먼트로 수신
            onDismissed: (direction) {
              // 해당 index의 item을 리스트에서 삭제
              deleteAlert(item.fixture.apiId);
              setState(() {
                alerts.removeAt(index);
              });
              // 삭제한 아이템을 스낵바로 출력
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('${item.fixture.home!.name} vs ${item.fixture.away!.name} 경기 알람이 삭제되었습니다.'),
                  backgroundColor: Colors.teal,
                  duration: const Duration(milliseconds: 1000)
              ));
            },
            // Dismissible의 자식으로 리스트타일을 생성. 리스튜뷰에 타일로 등록
            child: ListTile(
              leading: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Image.network(item.fixture.league!.logo),
              ),
              title: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: screenWidth * 0.3,
                        child: Column(
                          children: [
                            Image.network(item.fixture.home!.logo, height: 40),
                            Text(item.fixture.home!.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0)),
                          ],
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      const Text('vs'),
                      const Expanded(child: SizedBox()),
                      SizedBox(
                        width: screenWidth * 0.3,
                        child: Column(
                          children: [
                            Image.network(item.fixture.away!.logo, height: 40),
                            Text(item.fixture.away!.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0, overflow: TextOverflow.fade,)),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
              subtitle: Column(
                children: [
                  Text(DateFormat('y. M. d ${getKoreanWeekDay(item.fixture.date)} HH:mm').format(item.fixture.date),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.indigo))
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
                                    Text('${item.fixture.home!.name} vs ${item.fixture.away!.name} 경기 알람 시간을 수정하시겠습니까?'),
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
                                              updateAlert(item.fixture.apiId, selectedValue).then((_) => {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      content: Text('알람이 수정되었습니다.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
                                                      backgroundColor: Colors.teal,
                                                      duration: Duration(milliseconds: 1000),))
                                              }).then((_) {
                                                _refresh();
                                              });
                                            } catch(e) {
                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                content: Text('알람 수정에 실패하였습니다. 다시 시도해주세요.', textAlign: TextAlign.center,
                                                  style: TextStyle(color: Colors.white),),
                                                backgroundColor: Colors.redAccent,
                                                duration: Duration(milliseconds: 1000),));
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

  Future<void> getAlerts() async {
    final response = await http.get(Uri.parse('$baseUrl/api/alert'), headers: baseHeader);
    if (response.statusCode == 200) {
      alerts = List<Alert>.from(json
          .decode(utf8.decode(response.bodyBytes))
          .map((_) => Alert.fromJson(_)));
    }
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
        myTeamIds = subscribes.map((_) => _.team!.apiId).toList();
      }
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

  Future<void> updateAlert(int apiId, AlertType? alertType) async {
    Map<String, String> requestHeader = baseHeader;
    requestHeader['Content-Type'] = 'application/json';
    final response = await http.put(Uri.parse('$baseUrl/api/alert'),
        body: jsonEncode(AlertRequest(fixtureId: apiId, alertType: alertType?.type)),
        headers: baseHeader);
    if (response.statusCode != 200) {
      throw Exception('$response.statusCode error');
    }
  }

  Future<void> deleteAlert(int apiId) async {
    Map<String, String> requestHeader = baseHeader;
    requestHeader['Content-Type'] = 'application/json';
    final response = await http.delete(Uri.parse('$baseUrl/api/alert'),
        body: jsonEncode(AlertRequest(fixtureId: apiId, alertType: null)),
        headers: baseHeader);
    if (response.statusCode != 200) {
      throw Exception('$response.statusCode error');
    }
  }

  void _refresh() {
    getAlerts().then((_) => {
      getSubscribes()}).then((_) =>
        setState(() {}));
  }

}