import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:school_timetable/utils/SettingUtils.dart';
import 'package:school_timetable/widgets/lessonsViews/LessonCard.dart';

// TODO: Implement Lesson Filter

class DayView extends StatefulWidget {
  final String _firstDay;
  final _lessons;
  final _now;

  DayView(this._firstDay, this._lessons, this._now);

  @override
  State<StatefulWidget> createState() {
    return new DayViewState();
  }
}

class DayViewState extends State<DayView> {
  List<Widget> _lessonsWidgets = [];
  List<String> _filteredSubjects = [];

  @override
  Widget build(BuildContext context) {
    _lessonsWidgets = [];
    List<String> splittedFirstDay = widget._firstDay.split("/");
    DateTime firstDay = DateTime(
      int.parse(splittedFirstDay[2]),
      int.parse(splittedFirstDay[1]),
      int.parse(splittedFirstDay[0]),
    );
    // days between first day and now
    var dayDifference = widget._now.difference(firstDay).inDays;

    SettingUtils.getData("lessons").then((lessons){
      Map<String, dynamic> l = json.decode(lessons);
      l.removeWhere((key, value) => value == true);
      setState(() {
        _filteredSubjects.addAll(l.keys);
      });
    });

    // lesson cards
    widget._lessons.forEach((lesson) {
      if (int.parse(lesson["giorno"]) == dayDifference + 1 && !_filteredSubjects.contains(lesson["nome_insegnamento"])) {
        this._lessonsWidgets.add(
          new LessonCard(
            lesson["nome_insegnamento"],
            lesson["docente"],
            lesson["aula"],
            lesson["ora_inizio"],
            lesson["ora_fine"],
              widget._now,
            true
          ),
        );
      }
    });

    return ListView.builder(
        itemCount: _lessonsWidgets.length,
        itemBuilder: (context, index) => _lessonsWidgets[index]
    );
  }
}
