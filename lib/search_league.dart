

import 'package:flutter/material.dart';
import 'package:geolpo/api/search_api.dart';
import 'package:geolpo/dto/league_dto.dart';
import 'package:geolpo/search_team.dart';
import 'package:geolpo/styles/text_styles.dart';
import 'package:geolpo/utils/pageRoute.dart';
import 'package:geolpo/widgets/global_widget.dart';

class SearchLeague extends StatefulWidget {
  final String countryCode;
  const SearchLeague({super.key, required this.countryCode});

  @override
  State<StatefulWidget> createState() => _SearchLeague();
}

class _SearchLeague extends State<SearchLeague> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            getGlobalLine('리그 선택', getMainFont()),
            Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: FutureBuilder<List<League>>(
                      future: getLeagues(widget.countryCode),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        List<League> leagues = snapshot.data!;
                        return Column(
                          children: leagues.map((league) {
                            return Column(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(context, globalPageRoute(SearchTeam(leagueId: league.apiId)));
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
                      },
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

}