import 'package:flutter/material.dart';
import 'package:hawa_mobile/theme/app_theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedTime = '24H';
  String _selectedMetric = 'PM2.5';

  final List<String> _timePeriods = ['1H', '6H', '24H', '7D'];

  final List<Map<String, dynamic>> _metrics = [
    {'label': 'PM2.5', 'icon': Icons.blur_on},
    {'label': 'PM10', 'icon': Icons.grain},
    {'label': 'Temp', 'icon': Icons.thermostat},
    {'label': 'Humidity', 'icon': Icons.water_drop},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 100, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Bar: Dropdown & Calendar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      builder: (_) => _ZoneSelectorSheet(),
                    );
                  },
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF18352A).withValues(alpha: 0.05),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: AppTheme.primary, size: 18),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Zone 02 — Workshop',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.onSurface),
                          ),
                        ),
                        const Icon(Icons.expand_more, color: Color(0xFF404942), size: 18),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainerLowest,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF18352A).withValues(alpha: 0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.calendar_today, color: AppTheme.onSurface, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Time Range Segmented Selector
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: _timePeriods.map((period) {
                final isSelected = _selectedTime == period;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTime = period),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryContainer : Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: isSelected
                            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 4, offset: const Offset(0, 2))]
                            : null,
                      ),
                      child: Text(
                        period,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? Colors.white : const Color(0xFF404942),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Large Focal Chart Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF18352A).withValues(alpha: 0.06),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
              ],
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
                        const Text(
                          'AIR PARTICLE DENSITY',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF404942), letterSpacing: 1.0),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              _selectedMetric == 'PM2.5'
                                  ? '42'
                                  : _selectedMetric == 'PM10'
                                      ? '38'
                                      : _selectedMetric == 'Temp'
                                          ? '24°'
                                          : '58',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primary,
                                height: 1.2,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _selectedMetric == 'Temp' ? '°C' : _selectedMetric == 'Humidity' ? '%' : 'µg/m³',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF404942)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFBFEDCF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppTheme.secondary, shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          const Text('Moderate', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF002112))),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Chart area with custom painter
                SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: _ChartPainter(),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 14,
                        height: 14,
                        margin: const EdgeInsets.only(top: 22, right: 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFE9A23B), width: 3),
                        ),
                      ),
                    ),
                  ),
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

          // Metric Selector Bubbles
          Row(
            children: _metrics.map((m) {
              final label = m['label'] as String;
              final icon = m['icon'] as IconData;
              final isSelected = _selectedMetric == label;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedMetric = label),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryContainer : AppTheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isSelected
                          ? null
                          : [BoxShadow(color: const Color(0xFF18352A).withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Column(
                      children: [
                        Icon(icon, size: 20, color: isSelected ? Colors.white : const Color(0xFF404942)),
                        const SizedBox(height: 4),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? Colors.white : const Color(0xFF404942),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Trend Summary Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(color: AppTheme.surfaceContainerLowest, shape: BoxShape.circle),
                        child: const Icon(Icons.trending_up, color: AppTheme.secondary, size: 22),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text('Increasing', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.primary)),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: AppTheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(12)),
                                  child: const Text('+32%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.error)),
                                ),
                              ],
                            ),
                            const Text(
                              'Recorded spike in the last 6 hours',
                              style: TextStyle(fontSize: 11, color: Color(0xFF404942)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(color: AppTheme.surfaceContainer, shape: BoxShape.circle),
                  child: const Icon(Icons.north_east, color: AppTheme.primary, size: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Zone Context Preview
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: const Color(0xFF18352A).withValues(alpha: 0.04), blurRadius: 16, offset: const Offset(0, 4))],
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(color: AppTheme.surfaceContainer, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.precision_manufacturing, color: AppTheme.primary, size: 28),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Workshop Ventilation', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.onSurface)),
                      Text(
                        'HVAC active: Circulation running at 78% speed',
                        style: TextStyle(fontSize: 11, color: Color(0xFF404942)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ZoneSelectorSheet extends StatelessWidget {
  final List<String> zones = ['Zone 01 — Main Gate', 'Zone 02 — Workshop', 'Zone 03 — Research Lab', 'Zone 04 — Perimeter'];

  _ZoneSelectorSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Zone', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.onSurface)),
          const SizedBox(height: 16),
          ...zones.map((zone) => InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: AppTheme.primary, size: 20),
                      const SizedBox(width: 12),
                      Text(zone, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.onSurface)),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Grid lines
    final gridPaint = Paint()
      ..color = const Color(0xFFC9EAD9).withValues(alpha: 0.6)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (final y in [h * 0.15, h * 0.45, h * 0.75]) {
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
    }

    // Area gradient fill
    final path = Path()
      ..moveTo(0, h * 0.72)
      ..cubicTo(w * 0.15, h * 0.65, w * 0.25, h * 0.78, w * 0.4, h * 0.56)
      ..cubicTo(w * 0.55, h * 0.36, w * 0.65, h * 0.52, w * 0.75, h * 0.33)
      ..cubicTo(w * 0.85, h * 0.16, w * 0.92, h * 0.08, w, h * 0.18)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    final gradient = LinearGradient(
      colors: [const Color(0xFFE9A23B).withValues(alpha: 0.35), const Color(0xFFE9A23B).withValues(alpha: 0.0)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    final fillPaint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // Line stroke
    final linePath = Path()
      ..moveTo(0, h * 0.72)
      ..cubicTo(w * 0.15, h * 0.65, w * 0.25, h * 0.78, w * 0.4, h * 0.56)
      ..cubicTo(w * 0.55, h * 0.36, w * 0.65, h * 0.52, w * 0.75, h * 0.33)
      ..cubicTo(w * 0.85, h * 0.16, w * 0.92, h * 0.08, w, h * 0.18);

    final linePaint = Paint()
      ..color = const Color(0xFFE9A23B)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(_) => false;
}
