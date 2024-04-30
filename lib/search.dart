import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dto/country.dart';
import 'dto/subscribe.dart';
import 'global.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Step stepHandle = Step.first;
  String stepDescription = '대륙';
  late List<Country> countries;
  late Continent continent;
  late String countryCode;
  late int leagueId;

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

  Future<List<League>> getLeagues(String countryCode) async {
    final response = await http.get(
        Uri.parse('$baseUrl/api/league?countryCode=$countryCode'),
        headers: baseHeader);
    if (response.statusCode == 200) {
      return List<League>.from(json
          .decode(utf8.decode(response.bodyBytes))
          .map((_) => League.fromJson(_)));
    } else {
      return List.empty();
    }
  }

  Future<List<Team>> getTeams(int leagueId) async {
    final response = await http.get(
        Uri.parse('$baseUrl/api/team?leagueId=$leagueId'),
        headers: baseHeader);
    if (response.statusCode == 200) {
      return List<Team>.from(json
          .decode(utf8.decode(response.bodyBytes))
          .map((_) => Team.fromJson(_)));
    } else {
      return List.empty();
    }
  }

  Widget getStep(Step handle) {
    switch (handle) {
      case Step.first:
        return getStep1();
      case Step.second:
        return getStep2();
      case Step.third:
        return getStep3();
      case Step.fourth:
        return getStep4();
    }
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
                    onPressed: () {
                      countryCode = country.code!;
                      movePage(Step.third);
                    },
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
          : [const CircularProgressIndicator()],
    );
  }

  Widget getStep3() {
    return FutureBuilder<List<League>>(
      future: getLeagues(countryCode),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<League> leagues = snapshot.data!;
          return Column(
            children: leagues.map((league) {
              return Column(
                children: [
                  TextButton(
                    onPressed: () {
                      leagueId = league.apiId;
                      movePage(Step.fourth);
                    },
                    style: const ButtonStyle(
                      alignment: Alignment.centerLeft,
                    ),
                    child: Text(
                      league.name,
                      style: const TextStyle(
                        color: Colors.indigo,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        }
      },
    );
  }

  Widget getStep4() {
    return FutureBuilder<List<Team>>(
      future: getTeams(leagueId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Team> teams = snapshot.data!;
          if (teams.isEmpty) {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100.0,
                ),
                Text(
                  '팀 정보를 찾을 수 없습니다.',
                  style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          }
          return Column(
            children: teams.map((team) {
              return Column(
                children: [
                  TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(team.name, style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.indigo),),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(padding: const EdgeInsets.all(30.0), child: Image.network(team.logo)),
                                  Container(padding: const EdgeInsets.all(5.0), child: Text('${team.name} 을 구독하시겠습니까?')),
                                ],
                              ),
                              contentTextStyle: const TextStyle(color: Colors.indigo),
                              actions: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: ElevatedButton(
                                            onPressed: () {}, child: const Text('예')),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('아니오')),
                                      ),
                                    ]),
                              ],
                            );
                          });
                    },
                    style: const ButtonStyle(
                      alignment: Alignment.centerLeft,
                    ),
                    child: Text(
                      team.name,
                      style: const TextStyle(
                        color: Colors.indigo,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        }
      },
    );
  }
}

enum Step {
  first,
  second,
  third,
  fourth;
}
