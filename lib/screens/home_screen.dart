import 'package:flutter/material.dart';
import 'package:hawa_mobile/models/sensor_data.dart';
import 'package:hawa_mobile/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SensorData data = SensorData.mockSample;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F6EE),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppTheme.primaryGreen,
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 500));
            setState(() {});
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Top Bar: Dot Home & Avatar Profile
                _buildTopBar(),
                const SizedBox(height: 18),

                // 2. Title & Live Sync Badge
                _buildTitleRow(),
                const SizedBox(height: 18),

                // 3. Hero Visual Air Quality Card (Clouds, Sun & PM2.5 Optimal Card)
                _buildHeroCard(),
                const SizedBox(height: 16),

                // 4. Quick Metrics Strip (PM2.5, PM10, Temp, Humid)
                _buildMetricsStrip(),
                const SizedBox(height: 24),

                // 5. Zones Header & List
                _buildZonesSection(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 1. Top Bar
  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 9,
              height: 9,
              decoration: const BoxDecoration(
                color: Color(0xFF1B5E4A),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Home',
              style: TextStyle(
                color: Color(0xFF0F3E32),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(
            color: Color(0xFF0F3E32),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person,
            color: Colors.white,
            size: 20,
          ),
        ),
      ],
    );
  }

  // 2. Title & Live Sync
  Widget _buildTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hawa',
              style: TextStyle(
                color: Color(0xFF0F3E32),
                fontSize: 30,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Air Quality',
              style: TextStyle(
                color: const Color(0xFF0F3E32).withValues(alpha: 0.7),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFD4EEDF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Color(0xFF389B66),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'LIVE SYNC',
                style: TextStyle(
                  color: Color(0xFF0F3E32),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 3. Hero Visual Air Quality Card
  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      height: 235,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFD3EFE0),
            Color(0xFFC0E8D0),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.7),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F3E32).withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background soft wavy curves
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: CustomPaint(
                painter: _WeatherBackgroundPainter(),
              ),
            ),
          ),

          // 3D Sun & Clouds Illustration
          Positioned(
            right: 18,
            top: 36,
            child: _buildCloudSunIllustration(),
          ),

          // Top Action Row (Good Air Today pill & Wind circular button)
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.eco_outlined,
                        color: Color(0xFF0F3E32),
                        size: 15,
                      ),
                      const SizedBox(width: 6),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Good ',
                              style: TextStyle(
                                color: Color(0xFF0F3E32),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            TextSpan(
                              text: 'Air Today',
                              style: TextStyle(
                                color: Color(0xFF5A7D71),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.air,
                    color: Color(0xFF0F3E32),
                    size: 18,
                  ),
                ),
              ],
            ),
          ),

          // Floating Bottom Status Card
          Positioned(
            left: 14,
            right: 14,
            bottom: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F3E32).withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${data.pm25.toInt()}',
                            style: const TextStyle(
                              color: Color(0xFF0F3E32),
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'µg/m³ PM2.5',
                            style: TextStyle(
                              color: Color(0xFF4A6B60),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        '3 of 4 zones are normal',
                        style: TextStyle(
                          color: Color(0xFF7C9C91),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4EEDF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2E9D68),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'OPTIMAL',
                          style: TextStyle(
                            color: Color(0xFF0F3E32),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 3D Soft Cloud & Glowing Sun Illustration
  Widget _buildCloudSunIllustration() {
    return SizedBox(
      width: 145,
      height: 95,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Warm glowing sun
          Positioned(
            left: 20,
            top: 2,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [
                    Color(0xFFFFF0B3),
                    Color(0xFFF9D178),
                    Color(0xFFF2BA50),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF7C566).withValues(alpha: 0.4),
                    blurRadius: 18,
                    spreadRadius: 4,
                  ),
                ],
              ),
            ),
          ),

          // Cloud Puffs Layer (Claymorphic 3D styling)
          Positioned(
            right: 0,
            bottom: 6,
            child: SizedBox(
              width: 125,
              height: 65,
              child: Stack(
                children: [
                  _cloudPuff(38, 38, left: 8, bottom: 2),
                  _cloudPuff(46, 46, left: 32, bottom: 12),
                  _cloudPuff(40, 40, left: 66, bottom: 8),
                  _cloudPuff(34, 34, right: 2, bottom: 2),
                  _cloudPuff(30, 24, left: 24, bottom: 0, isPill: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cloudPuff(double width, double height, {double? left, double? right, double? bottom, bool isPill = false}) {
    return Positioned(
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: isPill ? BorderRadius.circular(20) : null,
          shape: isPill ? BoxShape.rectangle : BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFF6FAF7),
              Color(0xFFE5EDE7),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2C5542).withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
      ),
    );
  }

  // 4. Summary Stats Strip (4 columns: PM2.5, PM10, Temp, Humid)
  Widget _buildMetricsStrip() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F3E32).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _buildMetricItem('${data.pm25.toInt()}', 'PM2.5')),
          _buildVerticalDivider(),
          Expanded(child: _buildMetricItem('${data.pm10.toInt()}', 'PM10')),
          _buildVerticalDivider(),
          Expanded(child: _buildMetricItem('${data.temperature.toInt()}°', 'Temp')),
          _buildVerticalDivider(),
          Expanded(child: _buildMetricItem('${data.humidity.toInt()}%', 'Humid')),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF0F3E32),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF5A7D71),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 28,
      color: const Color(0xFFE2EFE7),
    );
  }

  // 5. Zones Section
  Widget _buildZonesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Zones',
              style: TextStyle(
                color: Color(0xFF0F3E32),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Real-time Readings',
              style: TextStyle(
                color: Color(0xFF6B8A7E),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Zone 01 · Main Gate
        _buildZoneCard(
          icon: Icons.meeting_room_outlined,
          title: 'Zone 01 · Main Gate',
          value: '18 µg/m³',
          status: 'Normal',
          isWarning: false,
          trendIcon: Icons.trending_up,
        ),
        const SizedBox(height: 10),

        // Zone 02 · Workshop
        _buildZoneCard(
          icon: Icons.construction_outlined,
          title: 'Zone 02 · Workshop',
          value: '42 µg/m³',
          status: 'Warning',
          isWarning: true,
          trendIcon: Icons.arrow_upward,
        ),
        const SizedBox(height: 10),

        // Zone 03 · Research Lab
        _buildZoneCard(
          icon: Icons.science_outlined,
          title: 'Zone 03 · Research Lab',
          value: '21 µg/m³',
          status: 'Normal',
          isWarning: false,
          trendIcon: Icons.arrow_forward,
        ),
        const SizedBox(height: 10),

        // Zone 04 · Perimeter
        _buildZoneCard(
          icon: Icons.park_outlined,
          title: 'Zone 04 · Perimeter',
          value: '14 µg/m³',
          status: 'Normal',
          isWarning: false,
          trendIcon: Icons.trending_down,
        ),
      ],
    );
  }

  Widget _buildZoneCard({
    required IconData icon,
    required String title,
    required String value,
    required String status,
    required bool isWarning,
    required IconData trendIcon,
  }) {
    final Color primaryColor = isWarning ? const Color(0xFFD32F2F) : const Color(0xFF0F3E32);
    final Color badgeBg = isWarning ? const Color(0xFFFDE8E8) : const Color(0xFFD4EEDF);
    final Color badgeText = isWarning ? const Color(0xFFD32F2F) : const Color(0xFF0F3E32);
    final Color dotColor = isWarning ? const Color(0xFFD32F2F) : const Color(0xFF2E9D68);
    final Color trendColor = isWarning ? const Color(0xFFD32F2F) : const Color(0xFF2E9D68);
    final Color iconBg = isWarning ? const Color(0xFFFDE8E8) : const Color(0xFFDDF4E6);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F3E32).withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Container
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isWarning ? const Color(0xFFD32F2F) : const Color(0xFF0F3E32),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),

          // Title & Value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF0F3E32),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: TextStyle(
                    color: isWarning ? primaryColor : const Color(0xFF6B8A7E),
                    fontSize: 12,
                    fontWeight: isWarning ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  status,
                  style: TextStyle(
                    color: badgeText,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Trend Icon
          Icon(
            trendIcon,
            color: trendColor,
            size: 18,
          ),
        ],
      ),
    );
  }
}

// Custom Painter for background decorative hill waves
class _WeatherBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = const Color(0xFFE4F5EB).withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final path1 = Path();
    path1.moveTo(0, size.height * 0.45);
    path1.quadraticBezierTo(
      size.width * 0.35,
      size.height * 0.30,
      size.width * 0.75,
      size.height * 0.50,
    );
    path1.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.58,
      size.width,
      size.height * 0.52,
    );
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();

    canvas.drawPath(path1, paint1);

    final paint2 = Paint()
      ..color = const Color(0xFFC7EBD5).withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, size.height * 0.65);
    path2.quadraticBezierTo(
      size.width * 0.4,
      size.height * 0.55,
      size.width,
      size.height * 0.7,
    );
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
