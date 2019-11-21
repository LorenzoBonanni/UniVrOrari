import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_timetable/widgets/LessonField.dart';

class LessonCard extends StatelessWidget {
  String _lezione;
  String _docente;
  String _aula;
  String _inizio;
  String _fine;
  bool _vacanza = false;
  var _lessonColor;

  // bordeaux
  final _lightDispari = Color.fromRGBO(129, 0, 44, 100);

  // ottanio
  final _lightPari = Color.fromRGBO(2, 142, 185, 100);

  // bigBubble
  final _darkDispari = Color(0xff66ff);

  // ottanio
  final _darkPari = Color.fromRGBO(2, 142, 185, 100);

  LessonCard(lezione, docente, aula, inizio, fine) {
    this._lezione = lezione;
    this._docente = docente;
    this._aula = aula;
    this._inizio = inizio;
    this._fine = fine;

    if (lezione == null ||
        docente == null ||
        aula == null ||
        inizio == null ||
        fine == null) {
      this._vacanza = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_vacanza && this._lezione.contains("dispari")) {
      this._lessonColor = Theme.of(context).textTheme.display4.color;
    } else {
      this._lessonColor = Theme.of(context).textTheme.display3.color;
    }

    if (this._vacanza) {
      return new Text("");
    } else {
      return new Card(
        child: new Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                new Icon(FontAwesomeIcons.book),
                SizedBox(width: 4),
                Expanded(
                  child: new Text(_lezione,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _lessonColor,
                          fontSize: 18)),
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
