import 'package:flutter/material.dart';

class AppTheme {
  // Colores principales
  static const Color orangePrimary = Color(0xFFFF6B35);
  static const Color orangeLight = Color(0xFFFF8C5A);
  static const Color yellowPrimary = Color(0xFFFFD23F);
  static const Color yellowLight = Color(0xFFFFE066);
  static const Color pinkPrimary = Color(0xFFFFB3BA);
  static const Color pinkLight = Color(0xFFFFCCD0);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: orangePrimary,
      secondary: yellowPrimary,
      tertiary: pinkPrimary,
      surface: Colors.white,
      background: Colors.white,
      error: Colors.red,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: orangePrimary),
      titleTextStyle: TextStyle(
        color: orangePrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: orangePrimary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: orangeLight, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: orangePrimary, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey[50],
    ),
  );
}

