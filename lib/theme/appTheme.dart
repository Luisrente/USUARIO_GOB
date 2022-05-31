import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Colors.indigo;

  static final ThemeData ligthTheme = ThemeData.light().copyWith(
      primaryColor: Colors.indigo,
      appBarTheme: const AppBarTheme(color: primary, elevation: 0),
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(backgroundColor: primary),
      bottomNavigationBarTheme:
          const BottomNavigationBarThemeData(selectedItemColor: primary));
}
