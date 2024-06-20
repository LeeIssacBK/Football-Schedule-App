import 'package:flutter/material.dart';
import 'package:geolpo/api/search_api.dart';
import 'package:geolpo/dto/country_dto.dart';
import 'package:geolpo/enums/continent_type.dart';
import 'package:geolpo/search_league.dart';
import 'package:geolpo/styles/text_styles.dart';
import 'package:geolpo/utils/pageRoute.dart';
import 'package:geolpo/widgets/global_widget.dart';

class SearchCountry extends StatefulWidget {
  final Continent continent;
  const SearchCountry({super.key, required this.continent});

  @override
  State<StatefulWidget> createState() => _SearchCountry();
}

class _SearchCountry extends State<SearchCountry> {

  List<Country>? countries;
  late String countryCode;

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
            getGlobalLine('국가 선택', getMainFont()),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: FutureBuilder<List<Country>>(
                      future: getCountries(widget.continent),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
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
                                InkWell(
                                  onTap: () {
                                    Navigator.push(context, globalPageRoute(SearchLeague(countryCode: country.code!)));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          country.krName,
                                          style: getSearchFont(),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        );
                      }
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
