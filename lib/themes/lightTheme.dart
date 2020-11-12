import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme() {
  AppBarTheme _appBarTheme(AppBarTheme base) {
    return base.copyWith(
      color: Color(0xfffafafa),
      iconTheme: new IconThemeData(color: Colors.green),
      textTheme: new TextTheme(
        headline6: GoogleFonts.raleway(textStyle: TextStyle (
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.green,
          ),
        ),
      ),
    );
  }

  IconThemeData _iconTheme(IconThemeData base) {
    return base.copyWith(color: Colors.green);
  }

  TextTheme _textTheme(TextTheme base) {
    return TextTheme(
      // bordeaux
      headline1: TextStyle(color: Color.fromRGBO(129, 0, 44, 100)),
      // ottanio
      headline2: TextStyle(color: Color.fromRGBO(2, 142, 185, 100)),
      // field name
      headline3: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15),
      // filed value
      headline4: TextStyle(color: Colors.black87, fontSize: 15),
    );
  }

  final ThemeData base = ThemeData.light();
  return base.copyWith(
    appBarTheme: _appBarTheme(base.appBarTheme),
    buttonColor: Colors.green,
    iconTheme: _iconTheme(base.iconTheme),
    textTheme: _textTheme(base.textTheme),
    primaryColor: Colors.black,
    backgroundColor: Colors.white
  );
}