
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF061426),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF55C7F3),
          brightness: Brightness.dark,
        ),
      );

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF3F8FC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF55C7F3),
          brightness: Brightness.light,
        ),
      );
}
