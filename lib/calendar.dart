import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;

import 'dto/fixture.dart';
import 'global.dart';


class Calendar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {

  List<Fixture> schedules = List.empty();

  @override
  void initState() {
    getSchedule().then((_) => setState(() {}));
    super.initState();
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
        dataSource: FixtureDataSource(_getDataSource()),
        monthViewSettings: const MonthViewSettings(
            showAgenda: true,
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment
        )
      ),
    );
  }

  List<Source> _getDataSource() {
    final List<Source> sources  = <Source>[];
    for (var fixture in schedules) {
      sources.add(
        Source('${fixture.league!.name} '
                '${fixture.home!.krName ?? fixture.home!.name} vs ${fixture.away!.krName ?? fixture.away!.name}' ,
                fixture.date,
                fixture.date.add(const Duration(hours: 2)),
                fixture.league!.type == 'LEAGUE' ? Colors.deepOrangeAccent : Colors.blue,
                false)
      );
    }
    return sources;
  }

  Future<void> getSchedule() async {
    final response = await http.get(Uri.parse('$baseUrl/api/fixture/subscribe'),
        headers: baseHeader);
    if (response.statusCode == 200) {
      schedules = List<Fixture>.from(
          json.decode(utf8.decode(response.bodyBytes)).map((_) => Fixture.fromJson(_)));
    }
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