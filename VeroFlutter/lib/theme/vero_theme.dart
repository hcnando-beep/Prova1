import 'package:flutter/material.dart';

abstract class VeroColors {
  static const primary        = Color(0xFF7B1FA2);
  static const primaryDark    = Color(0xFF4A148C);
  static const secondary      = Color(0xFFF59E0B);
  static const background     = Color(0xFFF8F5FC);
  static const text           = Color(0xFF1E1028);
  static const subtext        = Color(0xFF7A7086);
  static const success        = Color(0xFF27AE60);
  static const error          = Color(0xFFE53E3E);
  static const card           = Colors.white;
  static const border         = Color(0xFFD6C8E8);
  static const gradientStart  = Color(0xFF7B1FA2);
  static const gradientEnd    = Color(0xFFC048C8);
}

abstract class VeroTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: VeroColors.primary,
      primary: VeroColors.primary,
      secondary: VeroColors.secondary,
      surface: VeroColors.card,
      error: VeroColors.error,
    ),
    scaffoldBackgroundColor: VeroColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      shadowColor: VeroColors.border,
      iconTheme: IconThemeData(color: VeroColors.primary),
      titleTextStyle: TextStyle(
        color: VeroColors.text,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
    ),
    dividerColor: VeroColors.border,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: VeroColors.border, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: VeroColors.border, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: VeroColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: VeroColors.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: VeroColors.error, width: 2),
      ),
    ),
  );
}
