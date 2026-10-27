import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hawa_mobile/screens/home_screen.dart';
import 'package:hawa_mobile/screens/history_screen.dart';
import 'package:hawa_mobile/screens/log_data_screen.dart';
import 'package:hawa_mobile/theme/app_theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  final List<({IconData icon, IconData activeIcon, String label})> _navItems = [
    (icon: Icons.sensors_outlined, activeIcon: Icons.sensors_rounded, label: 'Monitor'),
    (icon: Icons.insights_outlined, activeIcon: Icons.insights_rounded, label: 'Tren'),
    (icon: Icons.table_chart_outlined, activeIcon: Icons.table_chart_rounded, label: 'Log Data'),
  ];

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(onNavigateToTab: _onItemTapped),
      const HistoryScreen(),
      const LogDataScreen(),
    ];
  }

  void _onItemTapped(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      extendBody: false,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildFloatingPillDock(),
    );
  }

  Widget _buildFloatingPillDock() {
    return Container(
      padding: const EdgeInsets.only(left: 36, right: 36, bottom: 28, top: 8),
      color: Colors.transparent,
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: AppTheme.primaryDark,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryDark.withValues(alpha: 0.28),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(_navItems.length, (index) {
            final item = _navItems[index];
            final isSelected = _selectedIndex == index;

            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => _onItemTapped(index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSelected ? 18 : 12,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.16)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? item.activeIcon : item.icon,
                        color: isSelected
                            ? const Color(0xFF5EEAD4) // mint accent
                            : Colors.white.withValues(alpha: 0.5),
                        size: 22,
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 8),
                        Text(
                          item.label,
                          style: AppTheme.font(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
