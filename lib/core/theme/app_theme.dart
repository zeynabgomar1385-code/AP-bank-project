import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6EE7B7), 
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF6FFFB),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(0xFFEAFBF4),
          foregroundColor: Color(0xFF065F46),
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF34D399),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0B2F24),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(0xFF0F3D2E),
          foregroundColor: Color(0xFFA7F3D0),
        ),
      );
}
