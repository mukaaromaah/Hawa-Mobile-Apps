import 'package:flutter/material.dart';
import 'package:hawa_mobile/screens/main_screen.dart';
import 'package:hawa_mobile/theme/app_theme.dart';

void main() {
  runApp(const HawaApp());
}

class HawaApp extends StatelessWidget {
  const HawaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hawa Mobile App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainScreen(),
    );
  }
}
