import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Warna Utama dari Mockup
  static const Color primaryGreen = Color(0xFF114C3B); // Hijau tua / teks
  static const Color softGreen = Color(0xFFE2F6E9); // Latar belakang utama
  static const Color accentGreen = Color(0xFF8CD4A5); // Aksen hijau muda
  static const Color white = Colors.white;
  static const Color warningRed = Color(0xFFE57373); // Merah peringatan
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: softGreen,
      colorScheme: ColorScheme.light(
        primary: primaryGreen,
        secondary: accentGreen,
        surface: white,
        error: warningRed,
      ),
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: primaryGreen,
        displayColor: primaryGreen,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: softGreen,
        selectedItemColor: primaryGreen,
        unselectedItemColor: Colors.black38,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: softGreen,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: primaryGreen),
        titleTextStyle: TextStyle(
          color: primaryGreen,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
