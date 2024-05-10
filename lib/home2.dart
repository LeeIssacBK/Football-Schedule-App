import 'dart:core';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dto/fixture.dart';
import 'dto/subscribe.dart';
import 'global.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Home2 extends StatefulWidget {
  @override
  State<Home2> createState() => _HomeState2();
}

class _HomeState2 extends State<Home2> {
  int sliderIndex = 0;
  List<Subscribe> subscribes = List.empty();
  List<Fixture> schedules = List.empty();

  @override
  void initState() {
    getSubscribes().then((_) => getSchedule().then((_) => setState(() {})));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
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
                  child: const Text('내 팀',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold))),
              subscribes.isEmpty
                  ? Container(
                      padding: const EdgeInsets.all(50.0),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '구독된 팀이 없습니다.',
                            style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Stack(
                        children: [
                          slider(screenHeight / 3.7),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: indicator(subscribes),
                            ),
                          ),
                        ],
                      ),
                    ),
              Container(
                  color: Colors.indigo,
                  width: double.infinity,
                  padding: const EdgeInsets.all(5.0),
                  height: 40.0,
                  child: const Text('경기 일정',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold))),
              schedules.isEmpty
                  ? Container(
                      padding: const EdgeInsets.all(50.0),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '경기 정보를 찾을 수 없습니다.',
                            style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: schedules.map((fixture) {
                        return Container(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    fixture.league!.name,
                                    style: const TextStyle(fontSize: 15.0),
                                  ),
                                  Text(
                                    '${fixture.round.replaceAll(RegExp(r'[^0-9]'), '')} 라운드',
                                    style: const TextStyle(fontSize: 15.0),
                                  ),
                                  Text(
                                    DateFormat('y. M. d, EEE HH:mm')
                                        .format(fixture.date),
                                    style: const TextStyle(fontSize: 15.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getSubscribes() async {
    final response = await http.get(
        Uri.parse('$baseUrl/api/subscribe/?type=TEAM'),
        headers: baseHeader);
    if (response.statusCode == 200) {
      dynamic body = jsonDecode(response.body);
      if (body is List && body.isNotEmpty) {
        subscribes = List<Subscribe>.from(
            json.decode(response.body).map((_) => Subscribe.fromJson(_)));
      }
    }
  }

  Future<void> getSchedule() async {
    final response = await http.get(Uri.parse('$baseUrl/api/fixture/subscribe'),
        headers: baseHeader);
    if (response.statusCode == 200) {
      schedules = List<Fixture>.from(
          json.decode(response.body).map((_) => Fixture.fromJson(_)));
    }
  }

  Widget slider(height) {
    List<Column> images = subscribes.map((subscribe) {
      return Column(
        children: [
          Image.network(subscribe.team!.logo),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(subscribe.team!.name,
                style: const TextStyle(
                    color: Colors.indigo,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      );
    }).toList();
    return CarouselSlider(
        items: images,
        options: CarouselOptions(
            height: height,
            autoPlay: true,
            viewportFraction: 1,
            enlargeCenterPage: false,
            initialPage: sliderIndex,
            onPageChanged: (index, reason) => setState(() {
                  sliderIndex = index;
                })));
  }

  Widget indicator(List<Subscribe>? subscribes) => Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      alignment: Alignment.bottomCenter,
      child: AnimatedSmoothIndicator(
        activeIndex: sliderIndex,
        count: subscribes!.length,
        effect: JumpingDotEffect(
            dotHeight: 6,
            dotWidth: 6,
            activeDotColor: Colors.grey,
            dotColor: Colors.grey.withOpacity(0.6)),
      ));
}
