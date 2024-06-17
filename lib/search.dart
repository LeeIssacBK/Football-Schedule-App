import 'package:flutter/material.dart';
import 'package:geolpo/api/search_api.dart';
import 'package:geolpo/styles/text_styles.dart';

import 'dto/country_dto.dart';
import 'dto/league_dto.dart';
import 'dto/team_dto.dart';
import 'enums/continent_type.dart';
import 'enums/step_type.dart';
import 'navibar.dart';

class Search extends StatefulWidget {
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Step_ stepHandle = Step_.first;
  String stepDescription = '대륙';
  late List<Country> countries;
  late Continent continent;
  late String countryCode;
  late int leagueId;

  @override
  void initState() {
    super.initState();
  }

  void movePage(Step_ step) {
    setState(() {
      if (Step_.first == step) {
        stepDescription = '대륙';
      }
      if (Step_.second == step) {
        stepDescription = '국가';
      }
      if (Step_.third == step) {
        stepDescription = '리그';
      }
      if (Step_.fourth == step) {
        stepDescription = '팀';
      }
      stepHandle = step;
    });
  }

  void backPage(Step_ step) {
    setState(() {
      if (Step_.second == step) {
        stepDescription = '대륙';
        stepHandle = Step_.first;
      }
      if (Step_.third == step) {
        stepDescription = '국가';
        stepHandle = Step_.second;
      }
      if (Step_.fourth == step) {
        stepDescription = '리그';
        stepHandle = Step_.third;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding:
            stepHandle == Step_.first ? const EdgeInsets.all(5.0) : null,
            height: 40.0,
            width: double.infinity,
            color: Colors.indigo,
            child: Row(
              children: [
                if (stepHandle != Step_.first)
                  IconButton(
                      onPressed: () {
                        backPage(stepHandle);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      )),
                Text('$stepDescription 선택',
                    style: getMainFont()),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    getStep(stepHandle)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getStep(Step_ handle) {
    switch (handle) {
      case Step_.first:
        return getStep1();
      case Step_.second:
        return getStep2();
      case Step_.third:
        return getStep3();
      case Step_.fourth:
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
                movePage(Step_.second);
              },
              child: Text('유럽', style: getSearchFont(),
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
              onPressed: () {
                continent = Continent.asia;
                movePage(Step_.second);
              },
              child: Text('아시아', style: getSearchFont(),
              )),
        ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: TextButton(
        //       onPressed: () {
        //         continent = Continent.southAmerica;
        //         movePage(Step_.second);
        //       },
        //       child: const Text(
        //         '남미',
        //         style: TextStyle(
        //             color: Colors.indigo,
        //             fontSize: 20.0,
        //             fontWeight: FontWeight.bold),
        //       )),
        // ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: TextButton(
        //       onPressed: () {
        //         continent = Continent.northAmerica;
        //         movePage(Step_.second);
        //       },
        //       child: const Text(
        //         '북미',
        //         style: TextStyle(
        //             color: Colors.indigo,
        //             fontSize: 20.0,
        //             fontWeight: FontWeight.bold),
        //       )),
        // ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: TextButton(
        //       onPressed: () {
        //         continent = Continent.oceania;
        //         movePage(Step_.second);
        //       },
        //       child: const Text(
        //         '오세아니아',
        //         style: TextStyle(
        //             color: Colors.indigo,
        //             fontSize: 20.0,
        //             fontWeight: FontWeight.bold),
        //       )),
        // ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: TextButton(
        //       onPressed: () {
        //         continent = Continent.africa;
        //         movePage(Step_.second);
        //       },
        //       child: const Text(
        //         '아프리카',
        //         style: TextStyle(
        //             color: Colors.indigo,
        //             fontSize: 20.0,
        //             fontWeight: FontWeight.bold),
        //       )),
        // ),
      ],
    );
  }


  Widget getStep2() {
    return FutureBuilder<List<Country>>(
      future: getCountries(continent),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Country> leagues = snapshot.data!;
          if (leagues.isEmpty) {
            return Container(
              padding: const EdgeInsets.fromLTRB(0, 100.0, 0, 100.0),
              child: Column(
                children: [
                  Text('준비중 입니다.', style: getSearchFont(),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: leagues.map((country) {
              return Column(
                children: [
                  TextButton(
                    onPressed: () {
                      countryCode = country.code!;
                      movePage(Step_.third);
                    },
                    style: const ButtonStyle(
                      alignment: Alignment.centerLeft,
                    ),
                    child: Text(
                      country.krName,
                      style: getSearchFont(),
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
                      movePage(Step_.fourth);
                    },
                    style: const ButtonStyle(
                      alignment: Alignment.centerLeft,
                    ),
                    child: Text(
                      league.name,
                      style: getSearchFont(),
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
          return Text('Error: ${snapshot.error} \n ${snapshot.stackTrace}');
        } else {
          List<Team> teams = snapshot.data!;
          if (teams.isEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100.0,),
                Text('팀 정보를 찾을 수 없습니다.', style: getSearchFont(),),
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
                              title: Text(team.krName ?? team.name, style: getAlertDialogTitleStyle()),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(padding: const EdgeInsets.all(30.0), child: Image.network(team.logo)),
                                  Container(padding: const EdgeInsets.all(5.0), child: Text('${team.krName ?? team.name} 을 구독하시겠습니까?')),
                                ],
                              ),
                              contentTextStyle: getAlertDialogContentStyle(),
                              actions: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              subscribeTeam(team.apiId).then((_) =>
                                                  Navigator.of(context).pop()).then((_) =>
                                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Navibar(selectedIndex: 0,)))
                                              );
                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                content: Text(
                                                  '팀 구독이 완료되었습니다.',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                                backgroundColor: Colors.teal,
                                                duration: Duration(milliseconds: 3000),
                                              ));
                                            }, child: Text('예', style: getButtonTextColor(),)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('아니오', style: getButtonTextColor(),)),
                                      ),
                                    ]),
                              ],
                            );
                          });
                    },
                    style: const ButtonStyle(
                      alignment: Alignment.centerLeft,
                    ),
                    child: Text(team.krName ?? team.name, style: getSearchFont(),
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
