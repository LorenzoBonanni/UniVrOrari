import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme() {
  AppBarTheme _appBarTheme(AppBarTheme base) {
    return base.copyWith(
      color: Color(0xff303030),
      iconTheme: new IconThemeData(color: Colors.white),
      textTheme: new TextTheme(
        title: GoogleFonts.raleway(
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  IconThemeData _iconTheme(IconThemeData base) {
    return base.copyWith(color: Colors.greenAccent, size: 18);
  }

  TextTheme _textTheme(TextTheme base) {
    return TextTheme(
        // rosa
        headline1: TextStyle(color: Color(0xfff551e7)),
        // blu
        headline2: TextStyle(color: Color(0xff6ea0f5)),
        // field name
        headline3: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        // filed value
        headline4: TextStyle(color: Colors.white, fontSize: 15));
  }

  _tabBarTheme(TabBarTheme base) {
    base.copyWith(labelColor: Colors.green);
  }

  final ThemeData base = ThemeData.dark();
  return base.copyWith(
      appBarTheme: _appBarTheme(base.appBarTheme),
      buttonColor: Colors.green,
      iconTheme: _iconTheme(base.iconTheme),
      textTheme: _textTheme(base.textTheme),
      tabBarTheme: _tabBarTheme(base.tabBarTheme),
      primaryColor: Colors.white
  );
}
