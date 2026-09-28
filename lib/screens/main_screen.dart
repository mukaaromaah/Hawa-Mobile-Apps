import 'package:flutter/material.dart';
import 'package:hawa_mobile/screens/home_screen.dart';
import 'package:hawa_mobile/screens/zones_screen.dart';
import 'package:hawa_mobile/screens/alerts_screen.dart';
import 'package:hawa_mobile/screens/history_screen.dart';
import 'package:hawa_mobile/screens/nodes_screen.dart';
import 'package:hawa_mobile/theme/app_theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Daftar halaman yang akan ditampilkan sesuai tab yang dipilih
  final List<Widget> _screens = const [
    HomeScreen(),
    ZonesScreen(),
    AlertsScreen(),
    HistoryScreen(),
    NodesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hawa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, size: 30),
            onPressed: () {},
          )
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              activeIcon: Icon(Icons.grid_view),
              label: 'Zones',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined),
              activeIcon: Icon(Icons.notifications),
              label: 'Alerts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart_outlined),
              activeIcon: Icon(Icons.show_chart),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.wifi_tethering),
              label: 'Nodes',
            ),
          ],
        ),
      ),
    );
  }
}
