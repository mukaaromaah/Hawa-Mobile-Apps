import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hawa_mobile/providers/sensor_provider.dart';
import 'package:hawa_mobile/screens/main_screen.dart';
import 'package:hawa_mobile/theme/app_theme.dart';

void main() {
  runApp(const HawaApp());
}

class HawaApp extends StatelessWidget {
  const HawaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SensorProvider()),
      ],
      child: MaterialApp(
        title: 'Hawa Mobile App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainScreen(),
      ),
    );
  }
}
