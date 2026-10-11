import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LuxuryColors {
  // Altın ve Lüks Vurgu Renkleri
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFF5D77F);
  static const Color goldDark = Color(0xFFAA771C);
  static const Color goldGlow = Color(0x33D4AF37);

  // Koyu Lüks Tema Renkleri
  static const Color darkBg = Color(0xFF090B10);
  static const Color darkSurface = Color(0xFF131722);
  static const Color darkCard = Color(0xFF191F2E);
  static const Color darkBorder = Color(0x33D4AF37);

  // Açık Lüks Tema Renkleri
  static const Color lightBg = Color(0xFFF9F7F2);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF5F2EB);
  static const Color lightBorder = Color(0x44D4AF37);

  // Altın Gradyanlar
  static const LinearGradient goldGradient = LinearGradient(
    colors: [goldLight, gold, goldDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGlowGradient = LinearGradient(
    colors: [Color(0x22D4AF37), Colors.transparent],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class LuxuryTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: LuxuryColors.darkBg,
      primaryColor: LuxuryColors.gold,
      cardColor: LuxuryColors.darkCard,
      colorScheme: const ColorScheme.dark(
        primary: LuxuryColors.gold,
        secondary: LuxuryColors.goldLight,
        surface: LuxuryColors.darkSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: LuxuryColors.darkBg,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cinzel(
          color: LuxuryColors.goldLight,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.cinzel(
          color: LuxuryColors.goldLight,
          fontSize: 26,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
        headlineMedium: GoogleFonts.cinzel(
          color: LuxuryColors.goldLight,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
        titleMedium: GoogleFonts.montserrat(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: GoogleFonts.montserrat(
          color: const Color(0xFFC0C7D5),
          fontSize: 14,
        ),
        bodySmall: GoogleFonts.montserrat(
          color: const Color(0xFF8B94A5),
          fontSize: 12,
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: LuxuryColors.lightBg,
      primaryColor: LuxuryColors.goldDark,
      cardColor: LuxuryColors.lightCard,
      colorScheme: const ColorScheme.light(
        primary: LuxuryColors.goldDark,
        secondary: LuxuryColors.gold,
        surface: LuxuryColors.lightSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: LuxuryColors.lightBg,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cinzel(
          color: LuxuryColors.goldDark,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.cinzel(
          color: LuxuryColors.goldDark,
          fontSize: 26,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
        headlineMedium: GoogleFonts.cinzel(
          color: LuxuryColors.goldDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
        titleMedium: GoogleFonts.montserrat(
          color: const Color(0xFF1B1D23),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: GoogleFonts.montserrat(
          color: const Color(0xFF4A4E5A),
          fontSize: 14,
        ),
        bodySmall: GoogleFonts.montserrat(
          color: const Color(0xFF757B8A),
          fontSize: 12,
        ),
      ),
    );
  }
}
