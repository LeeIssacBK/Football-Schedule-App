import 'dart:core';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dto/alert.dart';
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
                child: getList(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getList() {
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
              return Column(
                children: [
                  Text('${alert.fixture.home!.name}'),
                  Text('${alert.fixture.away!.name}'),
                ],
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