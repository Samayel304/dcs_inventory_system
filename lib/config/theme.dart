import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
    primaryColor: Colors.black,

    // primaryColorDark: Color(0xFFFC0028),
    // primaryColorLight: Color(0xFFFE9AAA),

    scaffoldBackgroundColor: Colors.white,
    backgroundColor: const Color(0xFFF4F4F4),

    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      headline1: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 36,
      ),
      headline2: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      headline3: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      headline4: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      headline5: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      headline6: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontSize: 14,
      ),
      bodyText1: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontSize: 12,
      ),
      bodyText2: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontSize: 10,
      ),
    ),
  );
}
