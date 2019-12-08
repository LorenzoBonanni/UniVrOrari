import 'package:flutter/material.dart';
import 'package:school_timetable/widgets/lessonsViews/LessonCard.dart';

class WeekView extends StatelessWidget {
  List<Widget> _lessonsWidgets = [];
  var _lessons;
  var _now;
  final _nomeGiorni = ["Lunedì", "Martedì", "Mercoledì", "Giovedì", "Venerdì"];

  WeekView(this._lessons, this._now);

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
            _now,
            false
          ),
        );
      }
    });


    return new Column(
      children: _lessonsWidgets,
    );
  }
}