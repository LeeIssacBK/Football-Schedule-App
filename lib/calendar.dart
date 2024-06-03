import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolpo/utils/parser.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;

import 'dto/fixture_dto.dart';
import 'api/auth_api.dart';


class Calendar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {

  List<Fixture> schedules = List.empty();

  @override
  void initState() {
    super.initState();
    getSchedule().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCalendar(
        view: CalendarView.month,
        headerDateFormat: 'y년 M월',
        headerStyle: const CalendarHeaderStyle(
            backgroundColor: Colors.indigo,
            textStyle: TextStyle(color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17.0)),
        todayHighlightColor: Colors.indigo,
        selectionDecoration: BoxDecoration(border: Border.all(color: Colors.indigo)),
        showNavigationArrow: true,
        showTodayButton: true,
        showDatePickerButton: true,
        appointmentBuilder: (BuildContext context, CalendarAppointmentDetails details) {
          final Source source = details.appointments.first;
          return Container(
            width: double.infinity,
            height: 100.0,
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              color: source.background,
              borderRadius: BorderRadius.circular(3)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  source.eventName,
                  style: const TextStyle(color: Colors.white, fontSize: 13.0),
                  overflow: TextOverflow.ellipsis,
                ),
                Text('${DateFormat('a h:mm').format(source.from)} ~ ${DateFormat('a h:mm').format(source.to)}',
                  style: const TextStyle(color: Colors.white, fontSize: 13.0),
                ),
              ]
            ),
          );
        },
        dataSource: FixtureDataSource(_getDataSource()),
        monthViewSettings: const MonthViewSettings(
            showAgenda: true,
            monthCellStyle: MonthCellStyle(
                trailingDatesTextStyle: TextStyle(color: Colors.grey),
                leadingDatesTextStyle: TextStyle(color: Colors.grey)
            ),
            appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
            agendaItemHeight: 64.0
        )
      ),
    );
  }

  List<Source> _getDataSource() {
    final List<Source> sources  = <Source>[];
    for (var fixture in schedules) {
      sources.add(Source(generateScheduleSubject(fixture), fixture.date,
            fixture.date.add(const Duration(hours: 2)),
            generateScheduleColor(fixture), false));
    }
    return sources;
  }

  Future<void> getSchedule() async {
    final response = await http.get(Uri.parse('$baseUrl/api/fixture/calendar'),
        headers: baseHeader);
    if (response.statusCode == 200) {
      schedules = List<Fixture>.from(
          json.decode(utf8.decode(response.bodyBytes)).map((_) => Fixture.fromJson(_)));
    }
  }

  String generateScheduleSubject(Fixture fixture) {
    if (fixture.status == 'FT' || fixture.status == 'AET' || fixture.status == 'PEN') {
      return '[${fixture.league!.name}] ${getKoreanRound(fixture.round)}\n'
          '${fixture.home!.krName ?? fixture.home!.name} ${fixture.homeGoal} : '
          '${fixture.awayGoal} ${fixture.away!.krName ?? fixture.away!.name}';
    }
    return '[${fixture.league!.name}] ${getKoreanRound(fixture.round)}\n'
        '${fixture.home!.krName ?? fixture.home!.name} vs ${fixture.away!.krName ?? fixture.away!.name}';
  }

  Color generateScheduleColor(Fixture fixture) {
    if (fixture.status == 'FT' || fixture.status == 'AET' || fixture.status == 'PEN') {
      return Colors.grey;
    }
    return fixture.league!.type == 'LEAGUE' ? Colors.deepOrangeAccent : Colors.blue;
  }

}

class FixtureDataSource extends CalendarDataSource {
  FixtureDataSource(List<Source> source){
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Source {
  Source(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}