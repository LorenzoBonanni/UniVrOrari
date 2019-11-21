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
        display2: TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15),
        // filed value
        display1: TextStyle(color: Colors.black87, fontSize: 15));
  }

  final ThemeData base = ThemeData.light();
  return base.copyWith(
      appBarTheme: _appBarTheme(base.appBarTheme),
      buttonColor: Colors.green,
      iconTheme: _iconTheme(base.iconTheme),
      textTheme: _textTheme(base.textTheme));
}

ThemeData darkTheme() {
  AppBarTheme _appBarTheme(AppBarTheme base) {
    return base.copyWith(
      color: Color(0xff177a3d),
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

  IconThemeData _iconTheme(IconThemeData base) {
    return base.copyWith(color: Colors.greenAccent, size: 18);
  }

  TextTheme _textTheme(TextTheme base) {
    return TextTheme(
        // rosa
        display4: TextStyle(color: Color(0xfff551e7)),
        // blu
        display3: TextStyle(color: Color(0xff6ea0f5)),
        // field name
        display2: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        // filed value
        display1: TextStyle(color: Colors.white, fontSize: 15));
  }

  _tabBarTheme(TabBarTheme base) {
    base.copyWith(
      labelColor: Colors.green
    );
  }

  final ThemeData base = ThemeData.dark();
  return base.copyWith(
      appBarTheme: _appBarTheme(base.appBarTheme),
      buttonColor: Colors.green,
      iconTheme: _iconTheme(base.iconTheme),
      textTheme: _textTheme(base.textTheme),
      tabBarTheme: _tabBarTheme(base.tabBarTheme));
}
