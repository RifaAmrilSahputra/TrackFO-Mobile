import 'package:flutter/material.dart';

class AppTheme {
  // Color palette matching admin pages
  static const Color kIndigo = Color(0xFF4F46E5);
  static const Color kCyan = Color(0xFF06B6D4);
  static const Color kBg = Color(0xFFF8FAFF);
  static const Color kTextPrimary = Color(0xFF1F2937);
  static const Color kTextSecondary = Color(0xFF6B7280);
  static const Color kLime = Color(0xFF10B981);
  static const Color kAmber = Color(0xFFF59E0B);
  static const Color kRose = Color(0xFFF43F5E);

  static ThemeData get darkTheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: kIndigo,
      brightness: Brightness.dark,
    );

    return ThemeData.dark(useMaterial3: true).copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerHighest,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: scheme.onSurface.withAlpha(31)),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: scheme.onSurface.withAlpha(31)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kIndigo, width: 2),
        ),
        hintStyle: TextStyle(color: scheme.onSurface.withAlpha(179)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kIndigo,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: const StadiumBorder(),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.surfaceContainerHighest,
        contentTextStyle: TextStyle(color: scheme.onSurface),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: scheme.onSurface, height: 1.4),
        bodyMedium: TextStyle(color: scheme.onSurface),
        titleLarge: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
        headlineSmall: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
    );
  }
}

