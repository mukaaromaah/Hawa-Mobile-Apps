import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Warna Utama dari UI UX
  static const Color surface = Color(0xFFE7FFF2);
  static const Color onSurface = Color(0xFF022016);
  static const Color primary = Color(0xFF004425);
  static const Color secondary = Color(0xFF3E674F);
  static const Color primaryContainer = Color(0xFF205C3A);
  static const Color onPrimaryContainer = Color(0xFF95D2A7);
  static const Color surfaceContainerLow = Color(0xFFDAFBEA);
  static const Color surfaceContainer = Color(0xFFD4F5E5);
  static const Color surfaceContainerHigh = Color(0xFFCFF0DF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);
  static const Color error = Color(0xFFBA1A1A);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: surface,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: surface,
        error: error,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondaryContainer: surfaceContainerHigh,
        errorContainer: errorContainer,
        onErrorContainer: onErrorContainer,
      ),
      textTheme: GoogleFonts.outfitTextTheme().apply(
        bodyColor: onSurface,
        displayColor: onSurface,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface.withValues(alpha: 0.8),
        selectedItemColor: primaryContainer,
        unselectedItemColor: const Color(0xFF404942), // on-surface-variant
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: primary),
        titleTextStyle: TextStyle(
          color: onSurface,
          fontSize: 22, // headline-md
          fontWeight: FontWeight.w600,
          fontFamily: 'Outfit',
        ),
      ),
    );
  }
}
