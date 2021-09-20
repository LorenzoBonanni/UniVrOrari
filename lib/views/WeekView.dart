import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:school_timetable/utils/SettingUtils.dart';
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

dynamic removeFilteredLessons([lessons, filteredSubjects]) {
  print("remove filtered");

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
  List<Widget> _lessonsWidgets = [];
  List<String> _filteredSubjects = [];
  int nDays = 0;

  manageLessons() async {
    SettingUtils.getData("lessons").then((lessonsToFilter) {
      Map<String, dynamic> decodedLessonsToFilter = json.decode(lessonsToFilter);
      decodedLessonsToFilter.removeWhere((key, value) => value == true);
      print(decodedLessonsToFilter);

      _filteredSubjects.addAll(decodedLessonsToFilter.keys);
      compute(sortLessons, widget._lessons).then(
        (sortedLessons) {
          print("decodedLessonsToFilter: ");
          print(decodedLessonsToFilter);
          compute(
            removeFilteredLessons,
            [sortedLessons, decodedLessonsToFilter],
          ).then(
                (filteredLessons) => widget._lessons = filteredLessons,
          );
        }
      );
    });
  }

  initState() {
    // print(widget._lessons);
    manageLessons().then((_) {
      compute(calculateDaysOfWeek, widget._lessons).then(
        (numberOfDays) => this.nDays = numberOfDays,
      );
    });

    // createLessonWidgets();

    super.initState();
  }

  void createLessonWidgets() {
    String currentDayName = "";
    List<Widget> l = [];

    widget._lessons.forEach((lesson) {
      if (lesson["nome_insegnamento"] != null &&
          !_filteredSubjects.contains(lesson["nome_insegnamento"])) {
        String dayName = widget._nomeGiorni[int.parse(lesson["giorno"]) - 1];
        if (currentDayName != dayName) {
          currentDayName = dayName;
          l.add(
            new Text(
              dayName,
              style: GoogleFonts.cinzelDecorative(
                textStyle: TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Theme.of(context).primaryColor),
              ),
              textAlign: TextAlign.center,
            ),
          );
        }

        l.add(
          new LessonCard(
            lesson["nome_insegnamento"],
            lesson["docente"],
            lesson["aula"],
            lesson["ora_inizio"],
            lesson["ora_fine"],
            lesson["extra"],
            widget._now,
            false,
          ),
        );
      }
    });
    setState(() {
      this._lessonsWidgets = l;
    });
  }

  @override
  Widget build(BuildContext context) {
    _lessonsWidgets = [];
    String currentDayName = "";

    // return new ListView.builder(
    //     itemCount: _lessonsWidgets.length,
    //     itemBuilder: (context, index) => _lessonsWidgets[index],
    // );
    return new ListView.builder(
      itemCount: widget._lessons.length + nDays,
      itemBuilder: (context, index) {
        var lesson = widget._lessons[index];
        String dayName = widget._nomeGiorni[int.parse(lesson["giorno"]) - 1];

        if (currentDayName != dayName) {
          currentDayName = dayName;
          return new Text(
            dayName,
            style: GoogleFonts.cinzelDecorative(
              textStyle: TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Theme.of(context).primaryColor),
            ),
            textAlign: TextAlign.center,
          );
        }

        return new LessonCard(
          lesson["nome_insegnamento"],
          lesson["docente"],
          lesson["aula"],
          lesson["ora_inizio"],
          lesson["ora_fine"],
          lesson["extra"],
          widget._now,
          false,
        );
      },
    );
  }
}
