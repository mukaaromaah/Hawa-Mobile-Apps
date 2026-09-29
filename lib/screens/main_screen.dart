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

  @override
  void initState() {
    super.initState();
    // Simulate push notification for demo scenario ("Andi")
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 24),
          backgroundColor: AppTheme.errorContainer,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppTheme.error,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.notifications_active, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hawa • Just Now',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.onErrorContainer),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Zone 04 Critical Alert!',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.onErrorContainer),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Rapid PM2.5 increase detected. Adaptive sensing boosted to 15s interval.',
                      style: TextStyle(fontSize: 12, color: AppTheme.onErrorContainer),
                    ),
                  ],
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 8),
          action: SnackBarAction(
            label: 'VIEW',
            textColor: AppTheme.error,
            onPressed: () {
              setState(() {
                _selectedIndex = 2; // Jump to Alerts tab
              });
            },
          ),
        ),
      );
    });
  }

  // Daftar halaman yang akan ditampilkan sesuai tab yang dipilih
  final List<Widget> _screens = const [
    HomeScreen(),
    ZonesScreen(),
    AlertsScreen(),
    HistoryScreen(),
    NodesScreen(),
  ];

  final List<String> _titles = [
    'Home',
    'Zones',
    'Alerts',
    'History',
    'Nodes',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surface.withValues(alpha: 0.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _titles[_selectedIndex],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.onSurface,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface.withValues(alpha: 0.8),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF18352A).withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
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
