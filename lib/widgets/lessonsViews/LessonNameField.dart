import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class LessonNameField extends StatelessWidget {
  final _lezione;
  final Color _lessonColor;
  final bool deactivated;

  LessonNameField(this._lezione, this._lessonColor, this.deactivated);


  @override
  Widget build(BuildContext context) {
    Color disabledColor = Theme.of(context).buttonTheme.getDisabledFillColor(
        new MaterialButton(onPressed: null)
    );
    Color color = this.deactivated ? disabledColor : _lessonColor;
    Color iconColor = this.deactivated ? disabledColor : Theme.of(context).iconTheme.color;

    return Row(
      children: <Widget>[
        new Icon(FontAwesomeIcons.book, color: iconColor),
        SizedBox(width: 4),
        Expanded(
          child: new AutoSizeText(
            _lezione,
            style: GoogleFonts.acme(
              textStyle: TextStyle(
                  color: color,
                  fontSize: 17
              ),
            ),
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
