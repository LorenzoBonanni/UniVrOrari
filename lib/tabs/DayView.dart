import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_timetable/screens/MainScreen.dart';
import 'package:school_timetable/widgets/LessonCard.dart';

class DayView extends StatefulWidget {
  String _firstDay;
  var _lessons;
  var _now;

  DayView(firstDay, lessons, now) {
    this._firstDay = firstDay;
    this._lessons = lessons;
    this._now = now;
  }

  @override
  State<StatefulWidget> createState() {
    return new DayViewState(_firstDay, _lessons, _now);
  }
}

class DayViewState extends State<DayView> {
  List<Widget> _lessonsWidgets = [];
  String _firstDay;
  var _lessons;
  var _now;

  DayViewState(firstDay, lessons, now) {
    this._firstDay = firstDay;
    this._lessons = lessons;
    this._now = now;
  }

  @override
  Widget build(BuildContext context) {
    _lessonsWidgets = [];
    List<String> splittedFirstDay = this._firstDay.split("/");
    DateTime firstDay = DateTime(
      int.parse(splittedFirstDay[2]),
      int.parse(splittedFirstDay[1]),
      int.parse(splittedFirstDay[0]),
    );
    // days between first day and now
    var dayDifference = this._now.difference(firstDay).inDays;

    // lesson cards
    this._lessons.forEach((lesson) {
      if (int.parse(lesson["giorno"]) == dayDifference + 1) {
        this._lessonsWidgets.add(
              new LessonCard(
                lesson["nome_insegnamento"],
                lesson["docente"],
                lesson["aula"],
                lesson["ora_inizio"],
                lesson["ora_fine"],
              ),
            );
      }
    });

    return new Column(
      children: _lessonsWidgets,
    );
  }
}
