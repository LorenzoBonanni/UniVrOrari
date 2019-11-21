import 'package:flutter/material.dart';

class LessonField extends StatelessWidget {
  String _text;
  String _fieldName;
  var _icon;

  LessonField(fieldName, text, icon) {
    this._text = text;
    this._fieldName = fieldName;
    this._icon = icon;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 3.0, top: 2.0),
      child: new Row(
        children: <Widget>[
          new Icon(this._icon),
          SizedBox(width: 4),
          new Text(
            _fieldName + ": ",
            style: Theme.of(context).textTheme.display2,
          ),
          Expanded(
              child: new Text(
            _text,
            style: Theme.of(context).textTheme.display1,
          ))
        ],
      ),
    );
  }
}
