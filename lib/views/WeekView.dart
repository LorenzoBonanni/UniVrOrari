import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:school_timetable/utils/SettingUtils.dart';
import 'package:school_timetable/widgets/Loading.dart';
import 'package:school_timetable/widgets/lessonsViews/LessonCard.dart';

dynamic sortLessons(lessons) async {
  lessons.sort((l1, l2) {
    int g1 = int.parse(l1["giorno"]);
    int g2 = int.parse(l2["giorno"]);
    var r = g1.compareTo(g2);
    return r;
  });
  return lessons;
}

List<dynamic> removeFilteredLessons(Map map) {
  List<dynamic> lessons = map["lessons"];
  List<String> filteredSubjects = map["filteredSubjects"];
  lessons.removeWhere(
    (lesson) =>
        lesson["nome_insegnamento"] == null ||
        filteredSubjects.contains(lesson["nome_insegnamento"]),
  );
  return lessons;
}

int calculateDaysOfWeek(lessons) {
  Set<String> days = {};
  lessons.forEach((lesson) {
    days.add(lesson["giorno"]);
  });
  return days.length;
}

// ignore: must_be_immutable
class WeekView extends StatefulWidget {
  var _lessons;
  final _now;
  final _nomeGiorni = ["Lunedì", "Martedì", "Mercoledì", "Giovedì", "Venerdì"];

  WeekView(this._lessons, this._now);

  @override
  _WeekViewState createState() => _WeekViewState();
}

class _WeekViewState extends State<WeekView> {
  List<String> _filteredSubjects = [];
  int nDays = -1;

  manageLessons() async {
    SettingUtils.getData("lessons").then((lessonsToFilter) {
      Map<String, dynamic> decodedLessonsToFilter =
          json.decode(lessonsToFilter);
      decodedLessonsToFilter.removeWhere((key, value) => value == true);

      _filteredSubjects.addAll(decodedLessonsToFilter.keys);
      compute(sortLessons, widget._lessons).then((sortedLessons) {
        Map map = Map();
        map["lessons"] = sortedLessons;
        map["filteredSubjects"] = _filteredSubjects;
        compute(removeFilteredLessons, map).then((filteredLessons) => {
              if (mounted)
                {
                  setState(() {
                    widget._lessons = filteredLessons;
                    nDays = calculateDaysOfWeek(filteredLessons);
                  })
                }
            });
      });
    });
  }

  initState() {
    manageLessons().then((_) {});

    super.initState();
  }

  List<Widget> createWidgets(Map map) {
    List<dynamic> lessons = map["lessons"];
    DateTime now = map["now"];

    final _nomeGiorni = [
      "Lunedì",
      "Martedì",
      "Mercoledì",
      "Giovedì",
      "Venerdì"
    ];
    String currentDayName = "";
    List<Widget> widgets = [];

    lessons.forEach((lesson) {
      String dayName = _nomeGiorni[int.parse(lesson["giorno"]) - 1];

      if (currentDayName != dayName) {
        currentDayName = dayName;
        widgets.add(new Text(
          dayName,
          style: GoogleFonts.cinzelDecorative(
            textStyle: TextStyle(
                // fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Theme.of(context).primaryColor),
          ),
          textAlign: TextAlign.center,
        ));
      } else {
        widgets.add(new LessonCard(
          lesson["nome_insegnamento"],
          lesson["docente"],
          lesson["aula"],
          lesson["ora_inizio"],
          lesson["ora_fine"],
          lesson["extra"],
          now,
          false,
        ));
      }
    });
    return widgets;
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> widgets = [];
    if (this.nDays != -1) {
      Map map = new Map();
      map["lessons"] = widget._lessons;
      map["now"] = widget._now;
      widgets = createWidgets(map);
    }

    return this.nDays == -1
        ? Loading()
        : ListView(
            children: widgets,
          );
  }
}
