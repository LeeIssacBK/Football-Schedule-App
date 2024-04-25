import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'dto/country.dart';
import 'global.dart';

class Search extends StatefulWidget {
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Step stepHandle = Step.first;
  late String stepDescription;
  late List<Country> countries;
  late Continent continent;

  @override
  void initState() {
    super.initState();
    getCountries().then((_) => setState(() {}));
  }

  void movePage(Step step) {
    setState(() {
      stepHandle = step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(children: [
            Container(
                color: Colors.indigo,
                width: double.infinity,
                padding: const EdgeInsets.all(5.0),
                child: Text('$stepDescription 선택',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold))),
            const Expanded(child: SizedBox()),
            Container(child: getStep(stepHandle)),
            const Expanded(child: SizedBox()),
          ]),
        ));
  }

  Future<void> getCountries() async {
    final response =
        await http.get(Uri.parse('$baseUrl/api/country'), headers: baseHeader);
    if (response.statusCode == 200) {
      countries = List<Country>.from(json
          .decode(utf8.decode(response.bodyBytes))
          .map((_) => Country.fromJson(_)));
    }
  }

  Widget getStep(Step handle) {
    switch (handle) {
      case Step.first:
        stepDescription = '대륙';
        return getStep1();
      case Step.second:
        stepDescription = '국가';
        return getStep2();
      case Step.third:
        stepDescription = '리그';
      // TODO: Handle this case.
      case Step.fourth:
        stepDescription = '팀';
      // TODO: Handle this case.
    }
    throw Exception('not found step');
  }

  Widget getStep1() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    continent = Continent.europe;
                    movePage(Step.second);
                  },
                  child: const Text(
                    '유럽',
                    style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    continent = Continent.asia;
                    movePage(Step.second);
                  },
                  child: const Text(
                    '아시아',
                    style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    continent = Continent.southAmerica;
                    movePage(Step.second);
                  },
                  child: const Text(
                    '남미',
                    style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    continent = Continent.northAmerica;
                    movePage(Step.second);
                  },
                  child: const Text(
                    '북미',
                    style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    continent = Continent.oceania;
                    movePage(Step.second);
                  },
                  child: const Text(
                    '오세아니아',
                    style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    continent = Continent.africa;
                    movePage(Step.second);
                  },
                  child: const Text(
                    '아프리카',
                    style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        ),
      ],
    );
  }

  Widget getStep2() {
    return Column(
      children: [
        Row(
          children: [
            ElevatedButton(onPressed: (){
              movePage(Step.first);
            }, child: const Text('뒤로 가기'))
          ],
        ),
      ],
    );
  }
}

enum Step {
  first, second, third, fourth;
}
