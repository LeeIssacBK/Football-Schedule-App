import 'package:flutter/material.dart';
import 'package:geolpo/api/search_api.dart';
import 'package:geolpo/search_country.dart';
import 'package:geolpo/styles/text_styles.dart';
import 'package:geolpo/utils/pageRoute.dart';
import 'package:geolpo/widgets/global_widget.dart';

import 'dto/country_dto.dart';
import 'dto/league_dto.dart';
import 'dto/team_dto.dart';
import 'enums/continent_type.dart';
import 'enums/step_type.dart';
import 'navibar.dart';

final

class Search extends StatefulWidget {
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late List<Country> countries;
  late Continent continent;
  late String countryCode;
  late int leagueId;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            getGlobalLine('팀 찾기', getMainFont()),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                            onPressed: () {
                              Navigator.push(context, globalPageRoute(const SearchCountry(continent: Continent.europe)));
                            },
                            child: Text('유럽', style: getSearchFont(),
                            )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                            onPressed: () {
                              Navigator.push(context, globalPageRoute(const SearchCountry(continent: Continent.asia)));
                            },
                            child: Text('아시아', style: getSearchFont(),
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getStep4() {
    return FutureBuilder<List<Team>>(
      future: getTeams(leagueId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error} \n ${snapshot.stackTrace}');
        }
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
                            title: Text('팀 구독', style: getAlertDialogTitleStyle()),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(padding: const EdgeInsets.all(30.0), child: Image.network(team.logo)),
                                Container(padding: const EdgeInsets.all(5.0), child: Text('${team.krName ?? team.name}을(를) 구독하시겠습니까?')),
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
      },
    );
  }
}
