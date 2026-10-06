import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  // Alert badge: shown on Alerts tab (index 2) until user visits it
  bool _hasUnreadAlert = true;

  final List<Widget> _screens = const [
    HomeScreen(),
    ZonesScreen(),
    AlertsScreen(),
    HistoryScreen(),
    NodesScreen(),
  ];

  final List<({IconData icon, IconData activeIcon, String label})> _navItems = [
    (icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home'),
    (icon: Icons.grid_view_outlined, activeIcon: Icons.grid_view_rounded, label: 'Zones'),
    (icon: Icons.notifications_outlined, activeIcon: Icons.notifications_rounded, label: 'Alerts'),
    (icon: Icons.show_chart_outlined, activeIcon: Icons.show_chart, label: 'History'),
    (icon: Icons.wifi_tethering_outlined, activeIcon: Icons.wifi_tethering, label: 'Nodes'),
  ];

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    HapticFeedback.selectionClick();
    // Clear alert badge when user visits Alerts tab
    if (index == 2 && _hasUnreadAlert) {
      setState(() => _hasUnreadAlert = false);
    } else {
      setState(() => _selectedIndex = index);
    }
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      extendBody: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildFloatingPillDock(),
    );
  }

  Widget _buildFloatingPillDock() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 28, top: 10),
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_navItems.length, (index) {
            final item = _navItems[index];
            final isSelected = _selectedIndex == index;
            // Show badge on Alerts tab (index 2) when unread
            final showBadge = index == 2 && _hasUnreadAlert;

            return GestureDetector(
              onTap: () => _onItemTapped(index),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                padding: EdgeInsets.symmetric(
                  horizontal: isSelected ? 14 : 10,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.accentGreen : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          isSelected ? item.activeIcon : item.icon,
                          color: isSelected
                              ? AppTheme.primaryDark
                              : Colors.white.withValues(alpha: 0.5),
                          size: 22,
                        ),
                        if (showBadge)
                          Positioned(
                            top: -3,
                            right: -3,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppTheme.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 6),
                      Text(
                        item.label,
                        style: AppTheme.font(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryDark,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
