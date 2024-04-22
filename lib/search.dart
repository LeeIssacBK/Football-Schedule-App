import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

import 'dto/country.dart';
import 'global.dart';

class Search extends StatefulWidget {
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<Country>? countries;

  @override
  void initState() {
    super.initState();
    getCountries()
    .then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: countries != null && countries!.isNotEmpty ? countries!.map((country) {
                return Container(
                  child: Row(
                    children: [
                      SvgPicture.network(country.flag,
                        semanticsLabel: country.krName,
                        placeholderBuilder: (BuildContext context) => Container(
                            padding: const EdgeInsets.all(5.0),
                            child: const CircularProgressIndicator()),
                        height: 50.0,
                        width: 150.0,
                      ),
                      Text(country.krName),
                    ],
                  )
                );
              }).toList() : [],
      ),
    )));
  }

  Future<void> getCountries() async {
    final response = await http.get(Uri.parse('$baseUrl/api/country'), headers: baseHeader);
    if (response.statusCode == 200) {
      countries = List<Country>.from(json.decode(utf8.decode(response.bodyBytes)).map((_) => Country.fromJson(_)));
    }
  }
}
