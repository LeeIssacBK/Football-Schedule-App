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
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              globalPageRoute(const SearchCountry(continent: Continent.europe)));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('유럽', style: getSearchFont()),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              globalPageRoute(const SearchCountry(continent: Continent.asia)));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('아시아', style: getSearchFont()),
                            )
                          ],
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

}
