import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LessonField extends StatelessWidget {
  String _text;
  var _icon;

  LessonField(fieldName, this._text , this._icon);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 3.0, top: 2.0),
      child: new Row(
        children: <Widget>[
          new Icon(this._icon),
          SizedBox(width: 4),
          Expanded(
              child: new Text(
            _text,
            style: GoogleFonts.workSans(
              textStyle: Theme.of(context).textTheme.display1,
            ),
          ))
        ],
      ),
    );
  }
}
