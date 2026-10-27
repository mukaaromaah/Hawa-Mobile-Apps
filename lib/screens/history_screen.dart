import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hawa_mobile/providers/sensor_provider.dart';
import 'package:hawa_mobile/theme/app_theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedMetric = 'PM2.5';
  String _selectedTime = 'Realtime';

  final List<String> _timePeriods = ['Realtime', '1 Jam', '24 Jam', '7 Hari'];

  final List<({String label, IconData icon, Color color})> _metrics = [
    (label: 'PM2.5', icon: Icons.grain_rounded, color: AppTheme.primaryDark),
    (label: 'PM10', icon: Icons.blur_on_rounded, color: const Color(0xFFF59E0B)),
    (label: 'PM1.0', icon: Icons.scatter_plot_rounded, color: const Color(0xFF3B82F6)),
    (label: 'CO₂', icon: Icons.co2_rounded, color: const Color(0xFF8B5CF6)),
    (label: 'Suhu', icon: Icons.thermostat_rounded, color: const Color(0xFFEF4444)),
    (label: 'Kelembaban', icon: Icons.water_drop_rounded, color: const Color(0xFF06B6D4)),
  ];

  @override
  Widget build(BuildContext context) {
    final sensorProvider = context.watch<SensorProvider>();
    final history = sensorProvider.historyData;

    // Extract values based on metric
    List<double> values = [];
    String unit = 'µg/m³';
    if (_selectedMetric == 'PM2.5') {
      values = history.map((e) => e.pm25).toList();
      unit = 'µg/m³';
    } else if (_selectedMetric == 'PM10') {
      values = history.map((e) => e.pm10).toList();
      unit = 'µg/m³';
    } else if (_selectedMetric == 'PM1.0') {
      values = history.map((e) => e.pm1).toList();
      unit = 'µg/m³';
    } else if (_selectedMetric == 'CO₂') {
      values = history.map((e) => e.co2).toList();
      unit = 'ppm';
    } else if (_selectedMetric == 'Suhu') {
      values = history.map((e) => e.temperature).toList();
      unit = '°C';
    } else if (_selectedMetric == 'Kelembaban') {
      values = history.map((e) => e.humidity).toList();
      unit = '%';
    }

    if (values.isEmpty) values = [0.0];

    final double latestVal = values.first;
    final double maxVal = values.reduce((a, b) => a > b ? a : b);
    final double minVal = values.reduce((a, b) => a < b ? a : b);
    final double avgVal = values.reduce((a, b) => a + b) / values.length;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ───────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tren & Analisis',
                        style: AppTheme.font(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Grafik Parameter TPS3R Brakseng',
                        style: AppTheme.font(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.mintContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.show_chart_rounded, size: 14, color: AppTheme.primaryDark),
                        const SizedBox(width: 4),
                        Text(
                          '${history.length} Poin',
                          style: AppTheme.font(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // ── Metric Chip Selector ──────────────────────────────
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: _metrics.map((metric) {
                    final isSelected = _selectedMetric == metric.label;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedMetric = metric.label);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.primaryDark : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? AppTheme.primaryDark : AppTheme.borderLight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: isSelected ? 0.08 : 0.02),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                metric.icon,
                                size: 16,
                                color: isSelected ? Colors.white : metric.color,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                metric.label,
                                style: AppTheme.font(
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  color: isSelected ? Colors.white : AppTheme.primaryDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // ── Timeframe Segmented Bar ───────────────────────────
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: Row(
                  children: _timePeriods.map((period) {
                    final isSelected = _selectedTime == period;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedTime = period);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.mintContainer : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            period,
                            textAlign: TextAlign.center,
                            style: AppTheme.font(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? AppTheme.primaryDark : AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // ── Main Chart Card ───────────────────────────────────
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.borderLight),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryDark.withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'NILAI SAAT INI ($_selectedMetric)',
                              style: AppTheme.font(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textSecondary,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  latestVal.toStringAsFixed(1),
                                  style: AppTheme.font(
                                    fontSize: 34,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.primaryDark,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  unit,
                                  style: AppTheme.font(
                                    fontSize: 13,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.mintContainer,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            _metrics.firstWhere((m) => m.label == _selectedMetric).icon,
                            color: AppTheme.primaryDark,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Custom Line Chart
                    SizedBox(
                      height: 180,
                      width: double.infinity,
                      child: CustomPaint(
                        painter: _TrendChartPainter(
                          values: values.reversed.toList(),
                          lineColor: AppTheme.primaryDark,
                          gradientColor: AppTheme.accentGreen,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Chart Bottom Legend
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Data Sebelumnya',
                          style: AppTheme.font(fontSize: 10, color: AppTheme.textMuted),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppTheme.primaryDark,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Live Stream',
                              style: AppTheme.font(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.primaryDark),
                            ),
                          ],
                        ),
                        Text(
                          'Sekarang',
                          style: AppTheme.font(fontSize: 10, color: AppTheme.textMuted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Statistics Grid ───────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _StatMetricBox(
                      title: 'Rata-rata',
                      value: '${avgVal.toStringAsFixed(1)} $unit',
                      icon: Icons.functions_rounded,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatMetricBox(
                      title: 'Puncak Tertinggi',
                      value: '${maxVal.toStringAsFixed(1)} $unit',
                      icon: Icons.arrow_upward_rounded,
                      color: AppTheme.error,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatMetricBox(
                      title: 'Titik Terendah',
                      value: '${minVal.toStringAsFixed(1)} $unit',
                      icon: Icons.arrow_downward_rounded,
                      color: AppTheme.success,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Air Quality Guidance Box ───────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline_rounded, size: 18, color: AppTheme.primaryDark),
                        const SizedBox(width: 8),
                        Text(
                          'Standar Baku Mutu Kualitas Udara',
                          style: AppTheme.font(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _StandardRow(
                      label: 'Baik (0 - 35 µg/m³)',
                      color: AppTheme.success,
                      desc: 'Kualitas udara sangat sehat untuk seluruh aktivitas di TPS3R.',
                    ),
                    const SizedBox(height: 8),
                    _StandardRow(
                      label: 'Perhatian (36 - 75 µg/m³)',
                      color: AppTheme.warning,
                      desc: 'Mulai timbul polusi partikulat, disarankan mengaktifkan exhaust fan.',
                    ),
                    const SizedBox(height: 8),
                    _StandardRow(
                      label: 'Berbahaya (> 75 µg/m³)',
                      color: AppTheme.error,
                      desc: 'Kadar polusi tinggi, exhaust fan wajib aktif otomatis.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatMetricBox extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatMetricBox({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(height: 6),
          Text(
            title,
            style: AppTheme.font(
              fontSize: 10,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTheme.font(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryDark,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _StandardRow extends StatelessWidget {
  final String label;
  final Color color;
  final String desc;

  const _StandardRow({
    required this.label,
    required this.color,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.font(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              Text(
                desc,
                style: AppTheme.font(
                  fontSize: 10,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TrendChartPainter extends CustomPainter {
  final List<double> values;
  final Color lineColor;
  final Color gradientColor;

  _TrendChartPainter({
    required this.values,
    required this.lineColor,
    required this.gradientColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final double min = values.reduce((a, b) => a < b ? a : b);
    final double max = values.reduce((a, b) => a > b ? a : b);
    final double range = (max - min) == 0 ? 1.0 : (max - min);

    // Draw grid lines
    final gridPaint = Paint()
      ..color = AppTheme.borderLight.withValues(alpha: 0.8)
      ..strokeWidth = 1.0;

    for (int i = 0; i <= 3; i++) {
      final y = size.height * (i / 3);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final double stepX = size.width / (values.length > 1 ? values.length - 1 : 1);

    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < values.length; i++) {
      final x = i * stepX;
      final normalized = (values[i] - min) / range;
      final y = size.height - (normalized * (size.height - 24)) - 12;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        final prevX = (i - 1) * stepX;
        final prevNorm = (values[i - 1] - min) / range;
        final prevY = size.height - (prevNorm * (size.height - 24)) - 12;

        final controlX1 = prevX + (x - prevX) / 2;
        final controlX2 = prevX + (x - prevX) / 2;

        path.cubicTo(controlX1, prevY, controlX2, y, x, y);
        fillPath.cubicTo(controlX1, prevY, controlX2, y, x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Fill Gradient
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          gradientColor.withValues(alpha: 0.28),
          gradientColor.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    // Stroke line
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, linePaint);

    // Draw latest point dot
    if (values.isNotEmpty) {
      final lastX = (values.length - 1) * stepX;
      final lastNorm = (values.last - min) / range;
      final lastY = size.height - (lastNorm * (size.height - 24)) - 12;

      final dotPaint = Paint()..color = lineColor;
      final whitePaint = Paint()..color = Colors.white;

      canvas.drawCircle(Offset(lastX, lastY), 5.5, whitePaint);
      canvas.drawCircle(Offset(lastX, lastY), 4.0, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TrendChartPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.lineColor != lineColor;
  }
}
