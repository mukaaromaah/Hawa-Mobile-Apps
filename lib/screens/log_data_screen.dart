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
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = ['Semua', 'PM > 35', 'CO2 > 800', 'Fan ON'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sensorProvider = context.watch<SensorProvider>();
    final history = sensorProvider.historyData;
    final isMqttConnected = sensorProvider.isConnectedMqtt;

    // Filter logic
    final filteredHistory = history.where((item) {
      if (_filterMetric == 'PM > 35' && item.pm25 <= 35) return false;
      if (_filterMetric == 'CO2 > 800' && item.co2 <= 800) return false;
      if (_filterMetric == 'Fan ON' && !item.fan) return false;
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
              // ── Header ───────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
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
                                'Log Data Telemetri',
                                style: AppTheme.font(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primaryDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'TPS3R Brakseng · Cloud Supabase & MQTT',
                                style: AppTheme.font(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          // Live Indicator Pill
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: isMqttConnected
                                  ? AppTheme.success.withValues(alpha: 0.12)
                                  : AppTheme.textMuted.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isMqttConnected
                                    ? AppTheme.success.withValues(alpha: 0.3)
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
                                  isMqttConnected ? 'LIVE' : 'OFFLINE',
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
                      const SizedBox(height: 16),

                      // Quick Stats Overview Cards
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              label: 'Total Rekaman',
                              value: '${history.length}',
                              subtitle: 'Sesi Aktif',
                              icon: Icons.receipt_long_rounded,
                              color: AppTheme.primaryDark,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              label: 'Sampling Rate',
                              value: '~2.0s',
                              subtitle: 'ESP32 Dual-Core',
                              icon: Icons.timer_rounded,
                              color: const Color(0xFF0D9488),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              label: 'Rata-rata PM',
                              value: history.isNotEmpty
                                  ? (history.map((e) => e.pm25).reduce((a, b) => a + b) / history.length).toStringAsFixed(1)
                                  : '0',
                              subtitle: 'µg/m³ PM2.5',
                              icon: Icons.grain_rounded,
                              color: AppTheme.accentGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Filter Pills
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
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
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
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                onSelected: (val) {
                                  if (val) {
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

              // ── Log List ──────────────────────────────────────────
              if (filteredHistory.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_rounded, size: 48, color: AppTheme.textMuted),
                        const SizedBox(height: 12),
                        Text(
                          'Belum ada log sesuai filter',
                          style: AppTheme.font(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
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
                        return _LogItemCard(
                          index: filteredHistory.length - index,
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

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.subtitle,
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
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTheme.font(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: AppTheme.font(
              fontSize: 10,
              color: AppTheme.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _LogItemCard extends StatelessWidget {
  final int index;
  final SensorData data;
  final bool isLatest;

  const _LogItemCard({
    required this.index,
    required this.data,
    required this.isLatest,
  });

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final bool isWarn = data.pm25 > 35;
    final bool isCrit = data.pm25 > 100;
    final statusColor = isCrit
        ? AppTheme.error
        : (isWarn ? AppTheme.warning : AppTheme.success);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLatest
              ? AppTheme.primaryDark.withValues(alpha: 0.25)
              : AppTheme.borderLight,
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
          // Row 1: Index + Timestamp + Badge
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
                      '#$index',
                      style: AppTheme.font(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatTime(data.measuredAt),
                    style: AppTheme.font(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                  if (isLatest) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'TERBARU',
                        style: AppTheme.font(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.success,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              // Status Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isCrit ? 'Bahaya' : (isWarn ? 'Perhatian' : 'Normal'),
                  style: AppTheme.font(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Row 2: Grid Metrics (PM1, PM2.5, PM10, Temp, Humid, CO2, Wind, Fan)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MetricItem(label: 'PM1.0', value: '${data.pm1.toStringAsFixed(1)} µg'),
              _MetricItem(
                label: 'PM2.5',
                value: '${data.pm25.toStringAsFixed(1)} µg',
                isHighlight: true,
                color: statusColor,
              ),
              _MetricItem(label: 'PM10', value: '${data.pm10.toStringAsFixed(1)} µg'),
              _MetricItem(label: 'Suhu', value: '${data.temperature.toStringAsFixed(1)}°C'),
              _MetricItem(label: 'CO₂', value: '${data.co2.toInt()} ppm'),
            ],
          ),
          const SizedBox(height: 8),
          Divider(color: AppTheme.borderLight, height: 1),
          const SizedBox(height: 8),

          // Row 3: Wind & Fan
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.navigation_rounded, size: 14, color: AppTheme.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    'Angin: ${data.windSpeed.toStringAsFixed(1)} m/s (${data.windDir}° ${data.windDirectionLabel})',
                    style: AppTheme.font(fontSize: 11, color: AppTheme.textSecondary),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.air_rounded,
                    size: 14,
                    color: data.fan ? AppTheme.success : AppTheme.textMuted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Kipas: ${data.fan ? "ON (Aktif)" : "OFF"}',
                    style: AppTheme.font(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: data.fan ? AppTheme.success : AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlight;
  final Color? color;

  const _MetricItem({
    required this.label,
    required this.value,
    this.isHighlight = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.font(
            fontSize: 10,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTheme.font(
            fontSize: 12,
            fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w600,
            color: color ?? AppTheme.primaryDark,
          ),
        ),
      ],
    );
  }
}
