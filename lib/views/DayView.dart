import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:school_timetable/utils/SettingUtils.dart';
import 'package:school_timetable/widgets/Loading.dart';
import 'package:school_timetable/widgets/lessonsViews/LessonCard.dart';

class DayView extends StatefulWidget {
  final String _firstDay;
  final List<dynamic> _lessons;
  final _now;

  DayView(this._firstDay, this._lessons, this._now);

  @override
  State<StatefulWidget> createState() {
    return new DayViewState();
  }
}

class DayViewState extends State<DayView> {
  List<String> _filteredSubjects = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> lessons = widget._lessons;
    SettingUtils.getData("lessons").then((filteredLessons) {
      Map<String, dynamic> fl = json.decode(filteredLessons);
      fl.removeWhere((key, value) => value == true);
      if (fl.isNotEmpty) {
        lessons.removeWhere(
          (lesson) => fl.keys.contains(lesson["nome_insegnamento"]),
        );
        setState(() {
          _filteredSubjects.addAll(fl.keys);
        });
      }
    });

    List<String> splittedFirstDay = widget._firstDay.split("/");
    DateTime firstDay = DateTime(
      int.parse(splittedFirstDay[2]),
      int.parse(splittedFirstDay[1]),
      int.parse(splittedFirstDay[0]),
    );
    // days between first day and now
    var dayDifference = widget._now.difference(firstDay).inDays;
    lessons.removeWhere((l) => int.parse(l["giorno"]) != dayDifference + 1);
    return ListView.builder(
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        return new LessonCard(
          lessons[index]["nome_insegnamento"],
          lessons[index]["docente"],
          lessons[index]["aula"],
          lessons[index]["ora_inizio"],
          lessons[index]["ora_fine"],
          lessons[index]["extra"],
          widget._now,
          true,
        );
      },
    );
    // return Loading();
  }
}
