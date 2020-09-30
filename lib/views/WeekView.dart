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



  @override
  Widget build(BuildContext context) {
    _lessonsWidgets = [];
    String currentDayName = "";

    SettingUtils.getData("lessons").then((lessons){
      Map<String, dynamic> l = json.decode(lessons);
      l.removeWhere((key, value) => value == true);
      setState(() {
        _filteredSubjects.addAll(l.keys);
      });
    });

    widget._lessons.forEach((lesson) {
      if (lesson["nome_insegnamento"] != null && !_filteredSubjects.contains(lesson["nome_insegnamento"])) {
        String dayName = widget._nomeGiorni[int.parse(lesson["giorno"]) - 1];
        if (currentDayName != dayName) {
          currentDayName = dayName;
          this._lessonsWidgets.add(
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

        this._lessonsWidgets.add(
          new LessonCard(
              lesson["nome_insegnamento"],
              lesson["docente"],
              lesson["aula"],
              lesson["ora_inizio"],
              lesson["ora_fine"],
              widget._now,
              false
          ),
        );
      }
    });

    return new ListView.builder(
        itemCount: _lessonsWidgets.length,
        itemBuilder: (context, index) => _lessonsWidgets[index]
    );
  }
}