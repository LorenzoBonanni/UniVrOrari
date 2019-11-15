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

  LessonCard(lezione, docente, aula, inizio, fine) {
    this._lezione = lezione;
    this._docente = docente;
    this._aula = aula;
    this._inizio = inizio;
    this._fine = fine;


    if (
        lezione == null ||
        docente == null ||
        aula == null ||
        inizio == null ||
        fine == null
    ) {
      this._vacanza = true;
    }

    if(!_vacanza && lezione.contains("dispari")) {
      // bordeaux
      this._lessonColor = Color.fromRGBO(129, 0, 44, 100);
    } else {
      // ottanio
      this._lessonColor = Color.fromRGBO(2, 142, 185, 100);
    }
  }

  @override
  Widget build(BuildContext context) {

    if (this._vacanza) {
      return new Text("");
    } else {
      return new Card(
        child: new Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                new Icon(
                  FontAwesomeIcons.book,
                  color: Colors.green,
                  size: 18,
                ),
                SizedBox(width: 4),
                Expanded(
                  child: new Text(_lezione,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: _lessonColor)),
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

