import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFF141613); // Deep dark green/black
  static const Color surface = Color(0xFF1E221D); // Slightly lighter card bg
  static const Color primary = Color(0xFF67E064); // Bright green
  static const Color secondary = Color(0xFF2C332B); // Secondary dark
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB0B3B0);
  static const Color accentYellow = Color(0xFFFFD54F);
  static const Color accentBlue = Color(0xFF64B5F6);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: primary,
        surface: surface,
        background: background,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      cardTheme: CardThemeData(
        color: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
      ),
      iconTheme: const IconThemeData(color: Color(0xFFB0B3B0)),
    );
  }
}
