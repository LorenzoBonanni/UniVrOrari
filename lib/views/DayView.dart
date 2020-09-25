import 'package:flutter/material.dart';
import 'package:school_timetable/widgets/lessonsViews/LessonCard.dart';

class DayView extends StatefulWidget {
  final String _firstDay;
  final _lessons;
  final _now;

  DayView(this._firstDay, this._lessons, this._now);

  @override
  State<StatefulWidget> createState() {
    return new DayViewState();
  }
}

class DayViewState extends State<DayView> {
  List<Widget> _lessonsWidgets = [];

  @override
  Widget build(BuildContext context) {
    _lessonsWidgets = [];
    List<String> splittedFirstDay = widget._firstDay.split("/");
    DateTime firstDay = DateTime(
      int.parse(splittedFirstDay[2]),
      int.parse(splittedFirstDay[1]),
      int.parse(splittedFirstDay[0]),
    );
    // days between first day and now
    var dayDifference = widget._now.difference(firstDay).inDays;

    // lesson cards
    widget._lessons.forEach((lesson) {
      if (int.parse(lesson["giorno"]) == dayDifference + 1) {
        this._lessonsWidgets.add(
          new LessonCard(
            lesson["nome_insegnamento"],
            lesson["docente"],
            lesson["aula"],
            lesson["ora_inizio"],
            lesson["ora_fine"],
              widget._now,
            true
          ),
        );
      }
    });

    return ListView.builder(
        itemCount: _lessonsWidgets.length,
        itemBuilder: (context, index) => _lessonsWidgets[index]
    );
  }
}
