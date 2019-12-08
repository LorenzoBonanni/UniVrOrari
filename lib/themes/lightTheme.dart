import 'package:flutter/material.dart';

ThemeData lightTheme() {
  AppBarTheme _appBarTheme(AppBarTheme base) {
    return base.copyWith(
      color: Colors.green,
      iconTheme: new IconThemeData(color: Colors.white),
      textTheme: new TextTheme(
        title: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  BottomAppBarTheme _bottomAppBarTheme(BottomAppBarTheme base) {
    return base.copyWith(
        color: Colors.green
    );
  }

  IconThemeData _iconTheme(IconThemeData base) {
    return base.copyWith(color: Colors.green, size: 18);
  }

  TextTheme _textTheme(TextTheme base) {
    return TextTheme(
      // bordeaux
      display4: TextStyle(color: Color.fromRGBO(129, 0, 44, 100)),
      // ottanio
      display3: TextStyle(color: Color.fromRGBO(2, 142, 185, 100)),
      // field name
      display2: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15),
      // filed value
      display1: TextStyle(color: Colors.black87, fontSize: 15),
    );
  }

  final ThemeData base = ThemeData.light();
  return base.copyWith(
    appBarTheme: _appBarTheme(base.appBarTheme),
    buttonColor: Colors.green,
    iconTheme: _iconTheme(base.iconTheme),
    textTheme: _textTheme(base.textTheme),
    bottomAppBarTheme: _bottomAppBarTheme(base.bottomAppBarTheme),
    primaryColor: Colors.black,
  );
}