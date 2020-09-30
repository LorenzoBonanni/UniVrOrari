import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_timetable/widgets/lessonsViews/LessonField.dart';
import 'package:school_timetable/widgets/lessonsViews/LessonNameField.dart';

// ignore: must_be_immutable
class LessonCard extends StatelessWidget {
  final String _lezione;
  final String _docente;
  final String _aula;
  final bool _extra;
  final String _inizio;
  final String _fine;
  final DateTime _now;
  final bool _flag; // IF TRUE FATHER WIDGET IS DAY VIEW
  bool _vacanza = false;
  var _lessonColor;

  LessonCard(this._lezione, this._docente, this._aula, this._inizio, this._fine, this._extra, this._now, this._flag) {
    if (
        _lezione == null ||
        _docente == null ||
        _aula == null    ||
        _inizio == null  ||
        _fine == null
    ) {
      this._vacanza = true;
    }
  }

  DateTime parseTime(String time) {
    String current = DateTime.now().toIso8601String();
    List<String> a = current.split("T");
    return DateTime.parse(a[0] + " " + time + ":00");
  }

  @override
  Widget build(BuildContext context) {
    // select lesson name color
    if (!_vacanza && this._extra) { // extra
      this._lessonColor = Theme.of(context).textTheme.headline1.color;
    } else { // normale
      this._lessonColor = Theme.of(context).textTheme.headline2.color;
    }

    if (this._vacanza) {
      return new Text("");
    } else {
      // se l'ora di inizio è inferiore a l'ora attuale e il giorno è uguale al giorno di oggi ==> disattivato
      DateTime currentDate = DateTime.now();
      DateTime oraInizio = parseTime(_inizio);

      // deactivated lesson
      if (
          this._flag &&
          currentDate.day == _now.day &&
          currentDate.month == _now.month &&
          currentDate.year == _now.year &&
          oraInizio.isBefore(currentDate)
      ) {
        return new Card(
          child: new Column(
            children: <Widget>[
              new LessonNameField(_lezione, _lessonColor, true),
              new LessonField(_inizio + " - " + _fine, FontAwesomeIcons.clock, true),
              new LessonField(_aula, FontAwesomeIcons.mapMarkerAlt, true),
              new LessonField(_docente, FontAwesomeIcons.user, true),
            ],
          ),
        );
      }
      // active lesson
      else {
        return new Card(
          child: new Column(
            children: <Widget>[
              new LessonNameField(_lezione, _lessonColor, false),
              new LessonField(_inizio + " - " + _fine, FontAwesomeIcons.clock, false),
              new LessonField( _aula, FontAwesomeIcons.mapMarkerAlt, false),
              new LessonField(_docente, FontAwesomeIcons.user, false),
            ],
          ),
        );
      }
    }
  }
}
