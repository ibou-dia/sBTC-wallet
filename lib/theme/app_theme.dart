import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Bitcoin orange color
  static const Color bitcoinOrange = Color(0xFFF7931A);
  
  // Other colors
  static const Color background = Colors.white;
  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Color(0xFF757575);
  static const Color cardBackground = Color(0xFFF5F5F5);
  static const Color divider = Color(0xFFEEEEEE);
  
  // Light theme
  static final ThemeData lightTheme = ThemeData(
    primaryColor: bitcoinOrange,
    scaffoldBackgroundColor: background,
    colorScheme: ColorScheme.light(
      primary: bitcoinOrange,
      secondary: bitcoinOrange,
      surface: background,
      background: background,
    ),
    textTheme: GoogleFonts.interTextTheme(
      ThemeData.light().textTheme.copyWith(
        headlineLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 28,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 24,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: bitcoinOrange,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: textPrimary,
        side: const BorderSide(color: textPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: bitcoinOrange,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cardBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: bitcoinOrange),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}
