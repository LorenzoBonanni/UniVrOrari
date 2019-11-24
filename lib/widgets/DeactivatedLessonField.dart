import 'package:flutter/material.dart';

class DeactivatedLessonField extends StatelessWidget {
  String _text;
  String _fieldName;
  var _icon;

  DeactivatedLessonField(this._fieldName, this._text, this._icon);

  @override
  Widget build(BuildContext context) {
    Color disabledColor = Theme.of(context).buttonTheme.getDisabledFillColor(
          new MaterialButton(onPressed: null),
        );

    return Padding(
      padding: const EdgeInsets.only(left: 3.0, top: 2.0),
      child: new Row(
        children: <Widget>[
          new Icon(
            this._icon,
            color: disabledColor,
          ),
          SizedBox(width: 4),
          new Text(
            _fieldName + ": ",
            style: Theme.of(context)
                .textTheme
                .display2
                .copyWith(color: disabledColor),
          ),
          Expanded(
            child: new Text(
              _text,
              style: Theme.of(context)
                  .textTheme
                  .display1
                  .copyWith(color: disabledColor),
            ),
          )
        ],
      ),
    );
  }
}
