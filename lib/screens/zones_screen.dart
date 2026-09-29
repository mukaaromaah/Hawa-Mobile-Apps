import 'package:flutter/material.dart';
import 'package:hawa_mobile/theme/app_theme.dart';

class ZonesScreen extends StatefulWidget {
  const ZonesScreen({super.key});

  @override
  State<ZonesScreen> createState() => _ZonesScreenState();
}

class _ZonesScreenState extends State<ZonesScreen> {
  static const List<Map<String, dynamic>> _zones = [
    {'id': 1, 'name': 'Zone 01', 'location': 'Main Gate', 'pm25': 18, 'pm10': 22, 'temp': 26, 'humidity': 60, 'status': 'Normal', 'icon': Icons.door_front_door_outlined},
    {'id': 2, 'name': 'Zone 02', 'location': 'Workshop', 'pm25': 42, 'pm10': 38, 'temp': 24, 'humidity': 58, 'status': 'Warning', 'icon': Icons.handyman_outlined},
    {'id': 3, 'name': 'Zone 03', 'location': 'Research Lab', 'pm25': 21, 'pm10': 25, 'temp': 22, 'humidity': 55, 'status': 'Normal', 'icon': Icons.science_outlined},
    {'id': 4, 'name': 'Zone 04', 'location': 'Perimeter', 'pm25': 14, 'pm10': 18, 'temp': 28, 'humidity': 62, 'status': 'Normal', 'icon': Icons.park_outlined},
  ];

  int? _selectedZoneId;

  @override
  Widget build(BuildContext context) {
    if (_selectedZoneId != null) {
      final zone = _zones.firstWhere((z) => z['id'] == _selectedZoneId);
      return _ZoneDetailView(zone: zone, onBack: () => setState(() => _selectedZoneId = null));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 100, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Zones',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: AppTheme.onSurface, letterSpacing: -0.5),
                  ),
                  Text(
                    'Monitor each zone',
                    style: TextStyle(fontSize: 14, color: Color(0xFF404942)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AppTheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppTheme.primaryContainer, shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    const Text('4 Active', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Zone Cards — tappable
          ..._zones.map((zone) {
            final isWarning = zone['status'] == 'Warning';
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ZoneListCard(
                zone: zone,
                isWarning: isWarning,
                onTap: () => setState(() => _selectedZoneId = zone['id']),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ZoneListCard extends StatefulWidget {
  final Map<String, dynamic> zone;
  final bool isWarning;
  final VoidCallback onTap;

  const _ZoneListCard({required this.zone, required this.isWarning, required this.onTap});

  @override
  State<_ZoneListCard> createState() => _ZoneListCardState();
}

class _ZoneListCardState extends State<_ZoneListCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.97).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final z = widget.zone;
    final isWarning = widget.isWarning;
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: isWarning ? Border.all(color: AppTheme.error.withValues(alpha: 0.2)) : null,
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isWarning ? AppTheme.errorContainer.withValues(alpha: 0.4) : AppTheme.surfaceContainerLow,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(z['icon'] as IconData, color: isWarning ? AppTheme.onErrorContainer : AppTheme.primary, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${z['name']} · ${z['location']}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.onSurface),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            '${z['pm25']}',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isWarning ? AppTheme.onErrorContainer : AppTheme.primary),
                          ),
                          const Text(' µg/m³ PM2.5', style: TextStyle(fontSize: 11, color: Color(0xFF404942))),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isWarning ? AppTheme.errorContainer : AppTheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isWarning ? AppTheme.error : AppTheme.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          z['status'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isWarning ? AppTheme.onErrorContainer : AppTheme.primaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right, color: Color(0xFFC0C9BF), size: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Full Zone Detail View (replaces the screen body)
class _ZoneDetailView extends StatelessWidget {
  final Map<String, dynamic> zone;
  final VoidCallback onBack;

  const _ZoneDetailView({required this.zone, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final isWarning = zone['status'] == 'Warning';

    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80), // Space for AppBar

          // Back button + Zone title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: onBack,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(color: AppTheme.surfaceContainerLow, shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back, color: AppTheme.onSurface, size: 22),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFBFEDCF).withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(zone['icon'] as IconData, color: AppTheme.primary, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(zone['name'] as String, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppTheme.onSurface)),
                      Text('${zone['location']} Indoor Area', style: const TextStyle(fontSize: 14, color: Color(0xFF404942))),
                    ],
                  ),
                ],
              ),
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(color: AppTheme.surfaceContainer, shape: BoxShape.circle),
                child: const Icon(Icons.more_vert, color: AppTheme.primary, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Status Pill
          if (isWarning)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.errorContainer.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppTheme.error, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  const Text('WARNING · MODERATE ELEVATION',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.onErrorContainer, letterSpacing: 0.5)),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: AppTheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(24)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppTheme.primaryContainer, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  const Text('NORMAL · AIR QUALITY GOOD',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.primary, letterSpacing: 0.5)),
                ],
              ),
            ),
          const SizedBox(height: 16),

          // Primary Hero Card with Chart
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: const Color(0xFF18352A).withValues(alpha: 0.06), blurRadius: 30, offset: const Offset(0, 8))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('PARTICULATE MATTER', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF404942), letterSpacing: 1.0)),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '${zone['pm25']}',
                              style: const TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color: AppTheme.primary, height: 1.1, letterSpacing: -1),
                            ),
                            const SizedBox(width: 6),
                            const Text('µg/m³', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF404942))),
                          ],
                        ),
                        const Text('Fine respirable dust (PM2.5)', style: TextStyle(fontSize: 13, color: Color(0xFF404942))),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isWarning ? AppTheme.errorContainer.withValues(alpha: 0.4) : AppTheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(isWarning ? Icons.trending_up : Icons.trending_flat,
                              color: isWarning ? AppTheme.onErrorContainer : AppTheme.primaryContainer, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            isWarning ? '+35%' : '-2%',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isWarning ? AppTheme.onErrorContainer : AppTheme.primaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('TREND (LAST 12H)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF404942), letterSpacing: 0.5)),
                    Text('Threshold 35 µg/m³', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: isWarning ? AppTheme.error : const Color(0xFF404942))),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: CustomPaint(painter: _ZoneChartPainter(isWarning: isWarning)),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('06:00', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF404942))),
                    const Text('12:00', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF404942))),
                    const Text('18:00', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF404942))),
                    const Text('Now', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Data Bubbles Row
          Row(
            children: [
              _DataBubble(label: 'PM10', icon: Icons.grain, value: '${zone['pm10']}', unit: 'µg'),
              const SizedBox(width: 12),
              _DataBubble(label: 'Temp', icon: Icons.device_thermostat, value: '${zone['temp']}°', unit: 'C'),
              const SizedBox(width: 12),
              _DataBubble(label: 'Humidity', icon: Icons.water_drop, value: '${zone['humidity']}', unit: '%'),
            ],
          ),
          const SizedBox(height: 16),

          // Adaptive Monitoring Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: const Color(0xFF18352A).withValues(alpha: 0.05), blurRadius: 30, offset: const Offset(0, 8))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.dynamic_form, color: AppTheme.primary, size: 20),
                        const SizedBox(width: 8),
                        const Text('Adaptive Monitoring', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.onSurface)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppTheme.surfaceContainer, borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        children: [
                          Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppTheme.secondary, shape: BoxShape.circle)),
                          const SizedBox(width: 4),
                          const Text('Normal ', style: TextStyle(fontSize: 11, color: Color(0xFF404942))),
                          const Icon(Icons.arrow_forward, size: 10, color: Color(0xFF404942)),
                          const SizedBox(width: 4),
                          Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppTheme.error, shape: BoxShape.circle)),
                          const SizedBox(width: 4),
                          const Text('Boosted', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.error)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Sample rate automatically elevated due to particulate acceleration in the workshop bay.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF404942)),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: AppTheme.surfaceContainerLow, borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          children: [
                            Container(
                              width: 36, height: 36,
                              decoration: const BoxDecoration(color: AppTheme.surfaceContainerLowest, shape: BoxShape.circle),
                              child: const Icon(Icons.sensors, color: AppTheme.primary, size: 20),
                            ),
                            const SizedBox(width: 10),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('SENSING', style: TextStyle(fontSize: 10, color: Color(0xFF404942), letterSpacing: 0.5)),
                                Text('1 min', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: AppTheme.surfaceContainerLow, borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          children: [
                            Container(
                              width: 36, height: 36,
                              decoration: const BoxDecoration(color: AppTheme.surfaceContainerLowest, shape: BoxShape.circle),
                              child: const Icon(Icons.cell_tower, color: AppTheme.primary, size: 20),
                            ),
                            const SizedBox(width: 10),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('TRANSMIT', style: TextStyle(fontSize: 10, color: Color(0xFF404942), letterSpacing: 0.5)),
                                Text('2 min', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Ventilation Recommendation Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerHigh.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 56, height: 56,
                  decoration: const BoxDecoration(color: AppTheme.surfaceContainer, shape: BoxShape.circle),
                  child: const Icon(Icons.eco, color: AppTheme.primary, size: 28),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ventilation Recommendation', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.primary)),
                      SizedBox(height: 2),
                      Text(
                        'Cycle overhead intake fans for 15 minutes to clear particulate buildup.',
                        style: TextStyle(fontSize: 13, color: Color(0xFF404942)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 36, height: 36,
                  decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.air, color: Colors.white, size: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DataBubble extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final String unit;

  const _DataBubble({required this.label, required this.icon, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: const Color(0xFF18352A).withValues(alpha: 0.04), blurRadius: 16, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Container(
              width: 32, height: 32,
              decoration: const BoxDecoration(color: AppTheme.surfaceContainer, shape: BoxShape.circle),
              child: Icon(icon, color: AppTheme.primary, size: 16),
            ),
            const SizedBox(height: 8),
            Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF404942), letterSpacing: 0.5)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                const SizedBox(width: 2),
                Text(unit, style: const TextStyle(fontSize: 10, color: Color(0xFF404942))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ZoneChartPainter extends CustomPainter {
  final bool isWarning;
  const _ZoneChartPainter({required this.isWarning});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final color = isWarning ? const Color(0xFFE9A23B) : const Color(0xFF205C3A);

    // Grid
    final gridPaint = Paint()
      ..color = const Color(0xFFC9EAD9).withValues(alpha: 0.6)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    for (final y in [h * 0.2, h * 0.5, h * 0.8]) {
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
    }

    // Threshold line (at ~y=55 scaled)
    if (isWarning) {
      final threshPaint = Paint()
        ..color = const Color(0xFFE9A23B).withValues(alpha: 0.6)
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke;
      final dashY = h * 0.46;
      double x = 0;
      while (x < w) {
        canvas.drawLine(Offset(x, dashY), Offset(x + 6, dashY), threshPaint);
        x += 10;
      }
    }

    // Area
    final path = isWarning
        ? (Path()
            ..moveTo(0, h * 0.72)
            ..quadraticBezierTo(w * 0.25, h * 0.6, w * 0.5, h * 0.5)
            ..quadraticBezierTo(w * 0.75, h * 0.33, w, h * 0.15)
            ..lineTo(w, h)
            ..lineTo(0, h)
            ..close())
        : (Path()
            ..moveTo(0, h * 0.7)
            ..quadraticBezierTo(w * 0.3, h * 0.6, w * 0.5, h * 0.65)
            ..quadraticBezierTo(w * 0.7, h * 0.7, w, h * 0.55)
            ..lineTo(w, h)
            ..lineTo(0, h)
            ..close());

    final gradient = LinearGradient(
      colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0.0)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    canvas.drawPath(path, Paint()..shader = gradient.createShader(Rect.fromLTWH(0, 0, w, h)));

    // Line
    final linePath = isWarning
        ? (Path()
            ..moveTo(0, h * 0.72)
            ..quadraticBezierTo(w * 0.25, h * 0.6, w * 0.5, h * 0.5)
            ..quadraticBezierTo(w * 0.75, h * 0.33, w, h * 0.15))
        : (Path()
            ..moveTo(0, h * 0.7)
            ..quadraticBezierTo(w * 0.3, h * 0.6, w * 0.5, h * 0.65)
            ..quadraticBezierTo(w * 0.7, h * 0.7, w, h * 0.55));

    canvas.drawPath(
      linePath,
      Paint()
        ..color = color
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );

    // Dot
    final dotY = isWarning ? h * 0.15 : h * 0.55;
    canvas.drawCircle(Offset(w, dotY), 5, Paint()..color = AppTheme.primaryContainer);
    canvas.drawCircle(Offset(w, dotY), 8, Paint()..color = AppTheme.primaryContainer.withValues(alpha: 0.25));
  }

  @override
  bool shouldRepaint(_) => false;
}
