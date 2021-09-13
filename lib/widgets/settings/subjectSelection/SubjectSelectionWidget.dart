import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:school_timetable/utils/SettingUtils.dart';

class SubjectSelectionWidget extends StatefulWidget {
  String _subject;

  SubjectSelectionWidget(this._subject);

  @override
  _SubjectSelectionWidgetState createState() => _SubjectSelectionWidgetState(this._subject);
}

class _SubjectSelectionWidgetState extends State<SubjectSelectionWidget> {
  bool? _value;
  String? _subject;
  Color? _color;
  Color? _normalColor;
  Color? _deactivatedColor;

  _SubjectSelectionWidgetState(this._subject);

  void changeValue(bool? value) {
    if (value != null) {
      _color = value == true ? _normalColor : _deactivatedColor;
      setState(() {
        _value = value;
      });
      setSubjectValue(value);
    }
  }

  getSubjectValue() {
    SettingUtils.getData("lessons").then((lessons){
      var l = json.decode(lessons);
      changeValue(l[_subject]);
    });
  }

  setSubjectValue(value) {
    SettingUtils.getData("lessons").then((lessons){
      var l = json.decode(lessons);
      l[_subject] = value;
      SettingUtils.setData("lessons", json.encode(l));
    });
  }

  @override
  Widget build(BuildContext context) {
    getSubjectValue();
    if (_value == null) {
      setState(() {
        _value = true;
      });
    }

    setState(() {
      _normalColor = (Theme.of(context).textTheme.headline4!.color) as Color;
      _deactivatedColor = Theme.of(context).buttonTheme.getDisabledFillColor(
          new MaterialButton(onPressed: null)
      );
    });

    return _value != null
        ? new Card(
          child: new CheckboxListTile(
            title: new Text(
                _subject!,
                style: GoogleFonts.acme(
                  textStyle: TextStyle(
                    color: _color != null
                        ? _color
                        : Theme.of(context).textTheme.headline4!.color,
                  ),
                )
            ),
            value: _value,
            onChanged: changeValue,
            controlAffinity: ListTileControlAffinity.platform,
          ),
        )
        : new Card();
  }
}
