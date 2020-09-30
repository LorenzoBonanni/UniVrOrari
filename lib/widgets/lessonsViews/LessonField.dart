import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LessonField extends StatelessWidget {
  String _text;
  final IconData _icon;
  final bool deactivated;

  LessonField(this._text , this._icon, this.deactivated);

  @override
  Widget build(BuildContext context) {
    _text = _text.replaceAll("Ã", "à");
    double size;
    double iconSize;
    if(MediaQuery.of(context).size.width <= 480) {
      size = 15;
      iconSize = 18;
    }
    else if(MediaQuery.of(context).size.width <= 768) {
      size = 18;
      iconSize = 22;
    }

    Color disabledColor = Theme.of(context).buttonTheme.getDisabledFillColor(
        new MaterialButton(onPressed: null)
    );
    Color color = this.deactivated ? disabledColor : Theme.of(context).textTheme.headline4.color;
    Color iconColor = this.deactivated ? disabledColor : Theme.of(context).iconTheme.color;

    return Padding(
      padding: const EdgeInsets.only(left: 3.0, top: 2.0),
      child: new Row(
        children: <Widget>[
          new Icon(this._icon, color: iconColor, size: iconSize,),
          SizedBox(width: 4),
          Expanded(
              child: new Text(
            _text,
            style: GoogleFonts.workSans(
              textStyle: Theme.of(context).textTheme.headline4.copyWith(color: color, fontSize: size),
            ),
          ))
        ],
      ),
    );
  }
}
