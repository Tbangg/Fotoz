import 'package:flutter/material.dart';

class AppTheme {
  static const Color darkBlue = Color(0xFF1B3C53);
  static const Color blueGrey = Color(0xFF456882);
  static const Color beige = Color(0xFFD2C1B6);
  static const Color offWhite = Color(0xFFF9F3EF);

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: offWhite,
    primaryColor: darkBlue,
    colorScheme: ColorScheme.fromSeed(
      seedColor: darkBlue,
      primary: darkBlue,
      secondary: blueGrey,
      background: offWhite,
      surface: beige,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBlue,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
  );
}
