import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:school_timetable/utils/SettingUtils.dart';
import 'package:school_timetable/widgets/lessonsViews/LessonCard.dart';

// ignore: must_be_immutable
class WeekView extends StatefulWidget {
  final _lessons;
  final _now;
  final _nomeGiorni = ["Lunedì", "Martedì", "Mercoledì", "Giovedì", "Venerdì"];

  WeekView(this._lessons, this._now);

  @override
  _WeekViewState createState() => _WeekViewState();
}

class _WeekViewState extends State<WeekView> {
  List<Widget> _lessonsWidgets = [];
  List<String> _filteredSubjects = [];

  sortLessons() async{
    setState(() {
      widget._lessons.sort((l1, l2){
        int g1 = int.parse(l1["giorno"]);
        int g2 = int.parse(l2["giorno"]);
        var r = g1.compareTo(g2);
        return r;
        // if (r != 0) return r; // 0 -> equal
        // return g1.compareTo(l2M);
      });
    });

    // lezioni.sort((l1, l2){
    //   l1 = l1["ora_inizio"].split(":");
    //   l2 = l2["ora_inizio"].split(":");
    //   var l1H = l1[0];
    //   var l1M = l1[1];
    //   var l2H = l2[0];
    //   var l2M = l2[1];
    //   var r = l1H.compareTo(l2H);
    //   if (r != 0) return r; // 0 -> equal
    //   return l1M.compareTo(l2M);
    // });
  }

  void createLessonWidgets() {
    String currentDayName = "";
    List<Widget> l = [];

    widget._lessons.forEach((lesson) {
      if (lesson["nome_insegnamento"] != null && !_filteredSubjects.contains(lesson["nome_insegnamento"])) {
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
                    color: Theme.of(context).primaryColor
                ),
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
              false
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

    sortLessons();
    SettingUtils.getData("lessons").then((lessons){
      Map<String, dynamic> l = json.decode(lessons);
      l.removeWhere((key, value) => value == true);
      _filteredSubjects.addAll(l.keys);
    });
    createLessonWidgets();

    return new ListView.builder(
        itemCount: _lessonsWidgets.length,
        itemBuilder: (context, index) => _lessonsWidgets[index]
    );
  }
}