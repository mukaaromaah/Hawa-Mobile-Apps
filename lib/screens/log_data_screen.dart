import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hawa_mobile/models/sensor_data.dart';
import 'package:hawa_mobile/providers/sensor_provider.dart';
import 'package:hawa_mobile/theme/app_theme.dart';

class LogDataScreen extends StatefulWidget {
  const LogDataScreen({super.key});

  @override
  State<LogDataScreen> createState() => _LogDataScreenState();
}

class _LogDataScreenState extends State<LogDataScreen> {
  String _filterMetric = 'Semua';
  final List<String> _filters = ['Semua', 'PM 2.5 > 35', 'CO₂ > 800', 'Kipas Aktif'];

  @override
  Widget build(BuildContext context) {
    final sensorProvider = context.watch<SensorProvider>();
    final history = sensorProvider.historyData;
    final isMqttConnected = sensorProvider.isConnectedMqtt;

    // Filter logic
    final filteredHistory = history.where((item) {
      if (_filterMetric == 'PM 2.5 > 35' && item.pm25 <= 35) return false;
      if (_filterMetric == 'CO₂ > 800' && item.co2 <= 800) return false;
      if (_filterMetric == 'Kipas Aktif' && !item.fan) return false;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppTheme.primaryDark,
          backgroundColor: Colors.white,
          onRefresh: () async {
            HapticFeedback.lightImpact();
            await sensorProvider.init();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // ── Header Section ────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Live Sync pill
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.storage_rounded, size: 20, color: AppTheme.primaryDark),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        'Data Log Historis',
                                        style: AppTheme.font(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: AppTheme.primaryDark,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Total Terekam: 78,018 data (Cloud Supabase)',
                                  style: AppTheme.font(
                                    fontSize: 12,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Live Sync Indicator
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: isMqttConnected
                                  ? const Color(0xFFE5F7ED)
                                  : const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isMqttConnected
                                    ? const Color(0xFF86EFAC)
                                    : AppTheme.borderLight,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: isMqttConnected ? AppTheme.success : AppTheme.textMuted,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  isMqttConnected ? 'Live Sync' : 'Offline',
                                  style: AppTheme.font(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: isMqttConnected ? AppTheme.success : AppTheme.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Action Toolbar: Refresh & Ekspor CSV
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                HapticFeedback.lightImpact();
                                await sensorProvider.init();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Data log berhasil diperbarui', style: AppTheme.font(fontSize: 12)),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.refresh_rounded, size: 16),
                              label: Text('Refresh', style: AppTheme.font(fontSize: 12, fontWeight: FontWeight.w600)),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.primaryDark,
                                backgroundColor: Colors.white,
                                side: BorderSide(color: AppTheme.borderLight),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                HapticFeedback.selectionClick();
                                final rows = history.take(10).map((e) =>
                                    '${e.measuredAt.toIso8601String()},${e.pm1},${e.pm25},${e.pm10},${e.temperature},${e.humidity},${e.co2},${e.windSpeed},${e.fan ? 1 : 0}'
                                ).join('\n');
                                final csvPreview = 'Waktu,PM1.0,PM2.5,PM10,Suhu,Kelembaban,CO2,Angin,Kipas\n$rows';
                                Clipboard.setData(ClipboardData(text: csvPreview));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: AppTheme.primaryDark,
                                    content: Text('Log CSV disalin ke clipboard!', style: AppTheme.font(fontSize: 12, color: Colors.white)),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.file_download_outlined, size: 16, color: Colors.white),
                              label: Text('Ekspor (CSV)', style: AppTheme.font(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryDark,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Filter Chips Row
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: _filters.map((filter) {
                            final isSelected = _filterMetric == filter;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(
                                  filter,
                                  style: AppTheme.font(
                                    fontSize: 11,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: isSelected ? Colors.white : AppTheme.primaryDark,
                                  ),
                                ),
                                selected: isSelected,
                                selectedColor: AppTheme.primaryDark,
                                backgroundColor: Colors.white,
                                side: BorderSide(
                                  color: isSelected ? AppTheme.primaryDark : AppTheme.borderLight,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                onSelected: (val) {
                                  if (val) {
                                    HapticFeedback.selectionClick();
                                    setState(() => _filterMetric = filter);
                                  }
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Log Items List ────────────────────────────────────
              if (filteredHistory.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.inbox_rounded, size: 44, color: AppTheme.textMuted),
                        const SizedBox(height: 10),
                        Text(
                          'Tidak ada data sesuai filter saat ini',
                          style: AppTheme.font(fontSize: 13, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = filteredHistory[index];
                        final isFirst = index == 0;
                        return _TelemetryCard(
                          recordNumber: filteredHistory.length - index,
                          data: item,
                          isLatest: isFirst,
                        );
                      },
                      childCount: filteredHistory.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TelemetryCard extends StatelessWidget {
  final int recordNumber;
  final SensorData data;
  final bool isLatest;

  const _TelemetryCard({
    required this.recordNumber,
    required this.data,
    required this.isLatest,
  });

  String _formatDateTime(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year.toString();
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    return '$d/$m/$y, $h.$min.$s';
  }

  @override
  Widget build(BuildContext context) {
    final bool isWarn = data.pm25 > 35;
    final bool isCrit = data.pm25 > 75;
    final pmColor = isCrit
        ? AppTheme.error
        : (isWarn ? const Color(0xFFF59E0B) : AppTheme.success);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isLatest ? AppTheme.primaryDark.withValues(alpha: 0.3) : AppTheme.borderLight,
          width: isLatest ? 1.4 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: No, Timestamp, Fan status badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.mintContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '#$recordNumber',
                      style: AppTheme.font(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDateTime(data.measuredAt),
                    style: AppTheme.font(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                ],
              ),
              // Fan status badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: data.fan ? const Color(0xFFE5F7ED) : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.mode_fan_off_rounded,
                      size: 12,
                      color: data.fan ? AppTheme.success : AppTheme.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      data.fan ? 'Aktif' : 'Mati',
                      style: AppTheme.font(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: data.fan ? AppTheme.success : AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Row 2: Particulates (PM1.0, PM2.5, PM10)
          Row(
            children: [
              _TeleItem(label: 'PM 1.0', value: '${data.pm1.toInt()} µg/m³'),
              _TeleItem(
                label: 'PM 2.5',
                value: '${data.pm25.toInt()} µg/m³',
                highlightColor: pmColor,
              ),
              _TeleItem(label: 'PM 10', value: '${data.pm10.toInt()} µg/m³'),
            ],
          ),
          const SizedBox(height: 8),
          Divider(color: AppTheme.borderLight, height: 1),
          const SizedBox(height: 8),

          // Row 3: Climate & Wind
          Row(
            children: [
              _TeleItem(label: 'Suhu', value: '${data.temperature.toStringAsFixed(1)}°C'),
              _TeleItem(label: 'Kelembaban', value: '${data.humidity.toInt()}%'),
              _TeleItem(label: 'CO₂', value: '${data.co2.toInt()} ppm'),
              _TeleItem(label: 'Angin', value: '${data.windSpeed.toStringAsFixed(2)} m/s (${data.windDir}°)'),
            ],
          ),
        ],
      ),
    );
  }
}

class _TeleItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? highlightColor;

  const _TeleItem({
    required this.label,
    required this.value,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTheme.font(fontSize: 10, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTheme.font(
              fontSize: 12,
              fontWeight: highlightColor != null ? FontWeight.w800 : FontWeight.w600,
              color: highlightColor ?? AppTheme.primaryDark,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
