import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Palet Warna Minimalis & Bersih (Dominan Putih & Deep Forest Green)
  static const Color background = Color(0xFFF7FAF8); // Off-white sejuk
  static const Color surface = Colors.white; // Putih bersih
  static const Color surfaceGlass = Color(0xCCFFFFFF); // Putih transparan 80%
  static const Color borderLight = Color(0x1A0D3326); // Border sangat halus

  // Aksen Warna
  static const Color primaryDark = Color(0xFF0D3326); // Hijau tua pekat (Text & Floating Dock)
  static const Color accentGreen = Color(0xFFB5E873); // Lime / light green segar ala Dribbble
  static const Color mintContainer = Color(0xFFE2F4E6); // Mint lembut
  static const Color textPrimary = Color(0xFF0D3326);
  static const Color textSecondary = Color(0xFF6B8278);
  static const Color textMuted = Color(0xFF9CB0A6);

  // ── Alias untuk kompatibilitas backward ──────────────────────────────
  static const Color primary = primaryDark;
  static const Color secondary = textSecondary;
  static const Color onSurface = textPrimary;
  static const Color onErrorContainer = Color(0xFF7F1515);
  static const Color onWarningContainer = Color(0xFF7A4800);
  static const Color primaryContainer = Color(0xFF8BC4A8); // Hijau mint mid
  static const Color surfaceContainer = Color(0xFFEEF4F1);
  static const Color surfaceContainerHigh = Color(0xFFE4EDE8);
  static const Color surfaceContainerLow = Color(0xFFF3F8F5);
  static const Color surfaceContainerLowest = Color(0xFFF9FBFA);

  // Status Colors
  static const Color success = Color(0xFF2E9D68);
  static const Color successContainer = Color(0xFFE5F7ED);
  static const Color warning = Color(0xFFE89326);
  static const Color warningContainer = Color(0xFFFFF3E0);
  static const Color error = Color(0xFFD32F2F);
  static const Color errorContainer = Color(0xFFFEEBEB);

  // Helper untuk Dekorasi Glassmorphism
  static BoxDecoration glassDecoration({
    Color? color,
    double borderRadius = 24,
    Border? border,
    List<BoxShadow>? boxShadow,
  }) {
    return BoxDecoration(
      color: color ?? Colors.white.withValues(alpha: 0.85),
      borderRadius: BorderRadius.circular(borderRadius),
      border: border ??
          Border.all(
            color: Colors.white.withValues(alpha: 0.8),
            width: 1.5,
          ),
      boxShadow: boxShadow ??
          [
            BoxShadow(
              color: primaryDark.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
    );
  }

  // Standar Tipografi Poppins
  static TextStyle font({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? textPrimary,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.poppinsTextTheme();

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.light(
        primary: primaryDark,
        secondary: accentGreen,
        surface: surface,
        error: error,
      ),
      textTheme: baseTextTheme.apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
    );
  }
}
