import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dto/country.dart';
import 'dto/league.dart';
import 'global.dart';

class Search extends StatefulWidget {
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Step stepHandle = Step.first;
  String stepDescription = '대륙';
  late List<Country> countries;
  late Continent continent;
  late List<League> leagues;

  @override
  void initState() {
    super.initState();
    getCountries().then((_) => setState(() {}));
  }

  void movePage(Step step) {
    setState(() {
      if (Step.first == step) {
        stepDescription = '대륙';
      }
      if (Step.second == step) {
        stepDescription = '국가';
      }
      if (Step.third == step) {
        stepDescription = '리그';
      }
      if (Step.fourth == step) {
        stepDescription = '팀';
      }
      stepHandle = step;
    });
  }

  void backPage(Step step) {
    setState(() {
      if (Step.second == step) {
        stepDescription = '대륙';
        stepHandle = Step.first;
      }
      if (Step.third == step) {
        stepDescription = '국가';
        stepHandle = Step.second;
      }
      if (Step.fourth == step) {
        stepDescription = '리그';
        stepHandle = Step.third;
      }
    });
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
                padding:
                    stepHandle == Step.first ? const EdgeInsets.all(5.0) : null,
                height: 40.0,
                width: double.infinity,
                color: Colors.indigo,
                child: Row(
                  children: [
                    if (stepHandle != Step.first)
                      IconButton(
                          onPressed: () {
                            backPage(stepHandle);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                          )),
                    Text('$stepDescription 선택',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(child: getStep(stepHandle)),
            ],
          ),
        ),
      ),
    );
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
        return getStep1();
      case Step.second:
        return getStep2();
      case Step.third:
      // TODO: Handle this case.
      case Step.fourth:
      // TODO: Handle this case.
    }
    throw Exception('not found step');
  }

  Widget getStep1() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
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
          child: TextButton(
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
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
          child: TextButton(
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
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
          child: TextButton(
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
    );
  }

  Widget getStep2() {
    return Column(
      children: countries.isNotEmpty
          ? countries
              .where((country) => country.continent == continent)
              .map((country) {
              try {
                return Column(children: [
                  TextButton(
                    onPressed: () {},
                    style: const ButtonStyle(
                      alignment: Alignment.centerLeft,
                    ),
                    child: Text(
                      country.krName,
                      style: const TextStyle(
                          color: Colors.indigo,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ]);
              } catch (e) {
                return const Row();
              }
            }).toList()
          : [Container()],
    );
  }

  Widget getStep3() {
    return Column();
  }
}

enum Step {
  first,
  second,
  third,
  fourth;
}
