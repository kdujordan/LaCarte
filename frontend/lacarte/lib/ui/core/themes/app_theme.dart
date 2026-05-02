import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color forestGreen = Color(0xFF18442A);
  static const Color mossGreen = Color(0xFF45644A);
  static const Color teaGreen = Color(0xFFE4DBC4);
  static const Color offWhite = Color(0xFFF3EDE3);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: mossGreen,
        onPrimary: Colors.white,
        secondary: forestGreen,
        onSecondary: Colors.white,
        tertiary: teaGreen,
        onTertiary: forestGreen,
        error: Color(0xffba1a1a),
        onError: Colors.white,
        surface: offWhite,
        onSurface: Colors.white,
      ),

      textTheme: GoogleFonts.cabinTextTheme(
        ThemeData.light().textTheme.copyWith(
          displayLarge: const TextStyle(
            color: forestGreen,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: const TextStyle(color: forestGreen),
        ),
      ),

      scaffoldBackgroundColor: offWhite,
      appBarTheme: const AppBarTheme(
        backgroundColor: forestGreen,
        foregroundColor: offWhite,
        elevation: 0,
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: mossGreen,
        foregroundColor: Colors.white,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        // ignore: deprecated_member_use
        fillColor: teaGreen.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
