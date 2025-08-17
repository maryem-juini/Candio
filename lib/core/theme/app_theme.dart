// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App theme configuration class
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // App colors - easily customizable
  static const Color _primaryColor = Color(0xFFFF00FF);
  static const Color _secondaryColor = Color(0xFF625B71);
  static const Color _tertiaryColor = Color(0xFF7D5260);
  static const Color _errorColor = Color(0xFFBA1A1A);
  static const Color _surfaceColor = Color(0xFFFFFBFE);
  static const Color _backgroundColor = Color(0xFFFFFBFE);
  static const Color _onPrimaryColor = Color(0xFFFFFFFF);
  static const Color _onSecondaryColor = Color(0xFFFFFFFF);
  static const Color _onTertiaryColor = Color(0xFFFFFFFF);
  static const Color _onErrorColor = Color(0xFFFFFFFF);
  static const Color _onSurfaceColor = Color(0xFF1C1B1F);
  static const Color _onBackgroundColor = Color(0xFF1C1B1F);

  // Public color getters for use in widgets
  static const Color primaryColor = _primaryColor;
  static const Color secondaryColor = _secondaryColor;
  static const Color tertiaryColor = _tertiaryColor;
  static const Color errorColor = _errorColor;
  static const Color surfaceColor = _surfaceColor;
  static const Color backgroundColor = _backgroundColor;
  static const Color onPrimaryColor = _onPrimaryColor;
  static const Color onSecondaryColor = _onSecondaryColor;
  static const Color onTertiaryColor = _onTertiaryColor;
  static const Color onErrorColor = _onErrorColor;
  static const Color onSurfaceColor = _onSurfaceColor;
  static const Color onBackgroundColor = _onBackgroundColor;

  // Additional semantic colors for CustomText
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color infoColor = Color(0xFF2196F3);

  // Light theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: _primaryColor,
        secondary: _secondaryColor,
        tertiary: _tertiaryColor,
        error: _errorColor,
        surface: _surfaceColor,
        background: _backgroundColor,
        onPrimary: _onPrimaryColor,
        onSecondary: _onSecondaryColor,
        onTertiary: _onTertiaryColor,
        onError: _onErrorColor,
        onSurface: _onSurfaceColor,
        onBackground: _onBackgroundColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _primaryColor,
        foregroundColor: _onPrimaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _onPrimaryColor,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: _onPrimaryColor,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryColor,
          side: const BorderSide(color: _primaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _secondaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: _surfaceColor,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _primaryColor,
        foregroundColor: _onPrimaryColor,
        elevation: 4,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _surfaceColor,
        selectedItemColor: _primaryColor,
        unselectedItemColor: _secondaryColor,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  // Dark theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: _primaryColor,
        secondary: _secondaryColor,
        tertiary: _tertiaryColor,
        error: _errorColor,
        surface: Color(0xFF1C1B1F),
        background: Color(0xFF1C1B1F),
        onPrimary: _onPrimaryColor,
        onSecondary: _onSecondaryColor,
        onTertiary: _onTertiaryColor,
        onError: _onErrorColor,
        onSurface: Color(0xFFE6E1E5),
        onBackground: Color(0xFFE6E1E5),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1C1B1F),
        foregroundColor: Color(0xFFE6E1E5),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFFE6E1E5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: _onPrimaryColor,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryColor,
          side: const BorderSide(color: _primaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _secondaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: const Color(0xFF1C1B1F),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _primaryColor,
        foregroundColor: _onPrimaryColor,
        elevation: 4,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1C1B1F),
        selectedItemColor: _primaryColor,
        unselectedItemColor: _secondaryColor,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  // Custom text styles
  // Heading2 variations
  static TextStyle get heading2Bold => GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  static TextStyle get heading2Semibold => GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
  );

  static TextStyle get heading2Medium => GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.25,
  );

  // Heading1 variations
  static TextStyle get heading1Bold =>
      GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold);

  static TextStyle get heading1Semibold =>
      GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600);

  static TextStyle get heading1Medium =>
      GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w500);

  // Body1 variations
  static TextStyle get body1Bold =>
      GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold);

  static TextStyle get body1Semibold =>
      GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600);

  static TextStyle get body1Medium =>
      GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500);

  // Body2 variations
  static TextStyle get body2Bold =>
      GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold);

  static TextStyle get body2Semibold =>
      GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600);

  static TextStyle get body2Medium =>
      GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500);

  // Caption variations
  static TextStyle get captionBold =>
      GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold);

  static TextStyle get captionSemibold =>
      GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600);

  static TextStyle get captionMedium =>
      GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500);
}
