import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:school_timetable/widgets/lessonsViews/DeactivatedLessonField.dart';
import 'package:school_timetable/widgets/lessonsViews/LessonField.dart';

class LessonCard extends StatelessWidget {
  final String _lezione;
  final String _docente;
  final String _aula;
  final String _inizio;
  final String _fine;
  final DateTime _now;
  final bool _flag; // IF TRUE FATHER WIDGET IS DAY VIEW
  bool _vacanza = false;
  var _lessonColor;

  LessonCard(this._lezione, this._docente, this._aula, this._inizio, this._fine, this._now, this._flag) {
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
    Color disabledColor = Theme.of(context).buttonTheme.getDisabledFillColor(
          new MaterialButton(onPressed: null),
        );

    // select lesson name color
    if (!_vacanza && this._lezione.contains("dispari")) {
      this._lessonColor = Theme.of(context).textTheme.display4.color;
    } else {
      this._lessonColor = Theme.of(context).textTheme.display3.color;
    }

    if (this._vacanza) {
      return new Text("");
    } else {
      // se l'ora di inizio è inferiore a l'ora attuale e il giorno è uguale al giorno di oggi ==> disattivato
      DateTime currentDate = DateTime.now();
      DateTime ora_inizio = parseTime(_inizio);

      //
      if (this._flag &&
          currentDate.day == _now.day &&
          currentDate.month == _now.month &&
          currentDate.year == _now.year &&
          ora_inizio.isBefore(currentDate)
      ) {
        return new Card(
          child: new Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  new Icon(
                    FontAwesomeIcons.book,
                    color: disabledColor,
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: new Text(
                      _lezione,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: disabledColor,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
              new DeactivatedLessonField(
                  _inizio + " - " + _fine, FontAwesomeIcons.clock),
              new DeactivatedLessonField(_aula, FontAwesomeIcons.mapMarkerAlt),
              new DeactivatedLessonField(_docente, FontAwesomeIcons.user),
            ],
          ),
        );
      } else {
        return new Card(
          child: new Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  new Icon(FontAwesomeIcons.book),
                  SizedBox(width: 4),
                  Expanded(
                    child: new AutoSizeText(
                      _lezione,
                      style: GoogleFonts.acme(
                          textStyle: TextStyle(
                              // fontWeight: FontWeight.bold,
                              color: _lessonColor,
                              fontSize: 17),
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              new LessonField("Orario", _inizio + " - " + _fine, FontAwesomeIcons.clock),
              new LessonField("Aula", _aula, FontAwesomeIcons.mapMarkerAlt),
              new LessonField("Docente", _docente, FontAwesomeIcons.user),
            ],
          ),
        );
      }
    }
  }
}
