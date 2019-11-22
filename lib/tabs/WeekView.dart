import 'package:flutter/material.dart';
import 'package:school_timetable/screens/MainScreen.dart';
import 'package:school_timetable/widgets/LessonCard.dart';

class WeekView extends StatelessWidget {
  List<Widget> _lessonsWidgets = [];
  String _firstDay;
  String _lastDay;
  var _lessons;
  final _nomeGiorni = ["Lunedì", "Martedì", "Mercoledì", "Giovedì", "Venerdì"];

  WeekView(firstDay, lastDay, lessons) {
    this._firstDay = firstDay;
    this._lastDay = lastDay;
    this._lessons = lessons;
  }

  @override
  Widget build(BuildContext context) {
    _lessonsWidgets = [];
    String giorno = "";

    this._lessons.forEach((lesson) {
      if (lesson["nome_insegnamento"] != null){
        String dayName = this._nomeGiorni[int.parse(lesson["giorno"]) - 1];
        if (giorno != dayName) {
          giorno = dayName;
          this._lessonsWidgets.add(new Text(dayName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Theme.of(context).primaryColor)));
        }

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