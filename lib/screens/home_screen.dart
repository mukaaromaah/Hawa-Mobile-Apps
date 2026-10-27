import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hawa_mobile/models/sensor_data.dart';
import 'package:hawa_mobile/providers/sensor_provider.dart';
import 'package:hawa_mobile/screens/profile_screen.dart';
import 'package:hawa_mobile/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<int>? onNavigateToTab;

  const HomeScreen({super.key, this.onNavigateToTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _fanAnimController;
  int _activeChartTabIndex = 0; // 0: Partikulat, 1: Gas & Suhu, 2: Kecepatan Angin

  @override
  void initState() {
    super.initState();
    _fanAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
  }

  @override
  void dispose() {
    _fanAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sensorProvider = context.watch<SensorProvider>();
    final data = sensorProvider.currentData;
    final history = sensorProvider.historyData;
    final isMqttConnected = sensorProvider.isConnectedMqtt;

    // Control fan animation
    if (data.fan && !_fanAnimController.isAnimating) {
      _fanAnimController.repeat();
    } else if (!data.fan && _fanAnimController.isAnimating) {
      _fanAnimController.stop();
    }

    final bool isCritical = data.status == AirQualityStatus.critical;
    final bool isWarning = data.status == AirQualityStatus.warning;
    final String statusLabel = isCritical ? 'BERBAHAYA' : (isWarning ? 'SEDANG' : 'BAIK');
    final Color statusColor = isCritical
        ? AppTheme.error
        : (isWarning ? const Color(0xFFF59E0B) : AppTheme.success);

    final bool hasAlert = isWarning || isCritical || data.co2 > 800;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE8F5EE), // Mint lembut
            Color(0xFFF7FAF8), // Off-white
            Color(0xFFEDF7F2), // Pale forest
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
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
            // ── Top Header Bar ────────────────────────────────────
            SliverToBoxAdapter(
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row 1: Brand & Actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TPA BRAKSENG MONITOR',
                                style: AppTheme.font(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.primaryDark,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Stasiun Pemantauan Kualitas Udara & Lingkungan IoT',
                                style: AppTheme.font(
                                  fontSize: 11,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          // Actions: Bell & Avatar
                          Row(
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  IconButton(
                                    onPressed: () => _showAlertSheet(context, data, hasAlert),
                                    icon: Icon(
                                      hasAlert ? Icons.notifications_active_rounded : Icons.notifications_outlined,
                                      color: hasAlert ? const Color(0xFFF59E0B) : AppTheme.primaryDark,
                                      size: 22,
                                    ),
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.white.withValues(alpha: 0.85),
                                      shape: const CircleBorder(),
                                      padding: const EdgeInsets.all(8),
                                    ),
                                  ),
                                  if (hasAlert)
                                    Positioned(
                                      top: 6,
                                      right: 6,
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
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration: const Duration(milliseconds: 300),
                                      pageBuilder: (context, anim, secAnim) => const ProfileScreen(),
                                      transitionsBuilder: (context, anim, secAnim, child) {
                                        return FadeTransition(opacity: anim, child: child);
                                      },
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryDark,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.primaryDark.withValues(alpha: 0.15),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(Icons.person_rounded, color: Colors.white, size: 18),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Row 2: Status Bar Ribbon (Uptime, Topic, Status)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.borderLight),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryDark.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.timer_outlined, size: 14, color: AppTheme.textSecondary),
                                const SizedBox(width: 4),
                                Text(
                                  'Uptime: 18:12:08',
                                  style: AppTheme.font(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primaryDark),
                                ),
                              ],
                            ),
                            Container(width: 1, height: 12, color: AppTheme.borderLight),
                            Row(
                              children: [
                                const Icon(Icons.tag_rounded, size: 14, color: AppTheme.textSecondary),
                                const SizedBox(width: 4),
                                Text(
                                  'tpa/monitor/data',
                                  style: AppTheme.font(fontSize: 11, color: AppTheme.textSecondary),
                                ),
                              ],
                            ),
                            Container(width: 1, height: 12, color: AppTheme.borderLight),
                            // MQTT Connected badge
                            Row(
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    color: isMqttConnected ? AppTheme.success : AppTheme.textMuted,
                                    shape: BoxShape.circle,
                                    boxShadow: isMqttConnected
                                        ? [BoxShadow(color: AppTheme.success.withValues(alpha: 0.6), blurRadius: 6, spreadRadius: 1)]
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  isMqttConnected ? 'CONNECTED' : 'OFFLINE',
                                  style: AppTheme.font(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: isMqttConnected ? AppTheme.success : AppTheme.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Body Cards List ───────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 110),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── Card 1: PARTIKULAT UDARA (PMS5003) ────────────
                  _ParticulateCard(
                    pm1: data.pm1,
                    pm25: data.pm25,
                    pm10: data.pm10,
                    statusLabel: statusLabel,
                    statusColor: statusColor,
                  ),
                  const SizedBox(height: 14),

                  // ── Card 2: GAS & SUHU (SCD41/SHT31) ──────────────
                  _GasAndClimateCard(
                    temperature: data.temperature,
                    humidity: data.humidity,
                    co2: data.co2,
                  ),
                  const SizedBox(height: 14),

                  // ── Card 3 & 4: Angin & Kipas Grid ─────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Arah & Kecepatan Angin
                      Expanded(
                        child: _WindCompassMiniCard(
                          windSpeed: data.windSpeed,
                          windDir: data.windDir,
                          windDirLabel: data.windDirectionLabel,
                          windSpeedKmh: data.windSpeedKmh,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Sirkulasi Udara (Kipas)
                      Expanded(
                        child: _FanCirculationCard(
                          fanOn: data.fan,
                          animController: _fanAnimController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // ── Card 5: TREN GRAFIK REAL-TIME ─────────────────
                  _RealtimeChartCard(
                    history: history,
                    activeTab: _activeChartTabIndex,
                    onTabChanged: (index) {
                      HapticFeedback.selectionClick();
                      setState(() => _activeChartTabIndex = index);
                    },
                    onTapViewDetails: () => widget.onNavigateToTab?.call(1),
                  ),
                  const SizedBox(height: 14),

                  // ── Card 6: DETAIL PERANGKAT ───────────────────────
                  _DeviceDetailCard(
                    isMqttConnected: isMqttConnected,
                    onTapMore: () => _showSystemInfoSheet(context, data, isMqttConnected),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAlertSheet(BuildContext context, SensorData data, bool hasAlert) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    hasAlert ? Icons.warning_amber_rounded : Icons.check_circle_outline_rounded,
                    color: hasAlert ? const Color(0xFFF59E0B) : AppTheme.success,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Peringatan Ambang Batas',
                    style: AppTheme.font(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.primaryDark),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (!hasAlert)
                Text(
                  'Seluruh parameter di TPS3R Brakseng saat ini berada dalam rentang normal dan aman.',
                  style: AppTheme.font(fontSize: 13, color: AppTheme.textSecondary),
                )
              else ...[
                if (data.pm25 > 35)
                  _AlertRow(
                    title: 'Konsentrasi Partikulat PM2.5 Tinggi',
                    desc: 'Nilai: ${data.pm25.toStringAsFixed(1)} µg/m³ (Batas aman: 35 µg/m³).',
                    color: const Color(0xFFF59E0B),
                  ),
                if (data.co2 > 800)
                  _AlertRow(
                    title: 'Konsentrasi Gas Karbon (CO₂) Meningkat',
                    desc: 'Nilai: ${data.co2.toInt()} ppm (Batas normal: 800 ppm).',
                    color: const Color(0xFFF59E0B),
                  ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryDark,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text('Tutup', style: AppTheme.font(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSystemInfoSheet(BuildContext context, SensorData data, bool isMqttConnected) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.memory_rounded, color: AppTheme.primaryDark, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    'Detail Perangkat & Telemetri',
                    style: AppTheme.font(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.primaryDark),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _DetailRow(label: 'Lokasi Stasiun', value: 'TPS Brakseng, Bumiaji, Batu'),
              _DetailRow(label: 'Arsitektur', value: 'ESP32 Dual-Core (FreeRTOS)'),
              _DetailRow(label: 'Pembagian Core', value: 'Core 0: MQTT/OTA | Core 1: Sensors'),
              _DetailRow(label: 'Server Host', value: 'b846d696536846c98fd91529e90260aa.s1.eu.hivemq.cloud'),
              _DetailRow(label: 'Interval Baca', value: '2000 ms (~2 detik)'),
              _DetailRow(label: 'MQTT Session', value: 'Clean Session (TLS Port 8883)'),
              _DetailRow(label: 'Database Cloud', value: 'Cloud Supabase (78,018 data)'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryDark,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text('Tutup', style: AppTheme.font(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Card 1: PARTIKULAT UDARA (PMS5003)
// ──────────────────────────────────────────────────────────────────────────────

class _ParticulateCard extends StatelessWidget {
  final double pm1;
  final double pm25;
  final double pm10;
  final String statusLabel;
  final Color statusColor;

  const _ParticulateCard({
    required this.pm1,
    required this.pm25,
    required this.pm10,
    required this.statusLabel,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Header: Name & Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PARTIKULAT UDARA (PMS5003)',
                style: AppTheme.font(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  statusLabel,
                  style: AppTheme.font(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Main PM2.5 Large Display
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${pm25.toInt()}',
                style: AppTheme.font(
                  fontSize: 52,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primaryDark,
                  height: 0.9,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'µg/m³',
                style: AppTheme.font(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                'PM 2.5 (Debu Halus)',
                style: AppTheme.font(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Sub-bars for PM 1.0 & PM 10
          _SubParticulateRow(
            label: 'PM 1.0 (Partikel Sangat Halus)',
            value: '${pm1.toInt()} µg/m³',
            barColor: const Color(0xFF3B82F6), // Blue
            fraction: (pm1 / 100).clamp(0.05, 1.0),
          ),
          const SizedBox(height: 10),
          _SubParticulateRow(
            label: 'PM 10 (Debu Kasar)',
            value: '${pm10.toInt()} µg/m³',
            barColor: const Color(0xFFF59E0B), // Yellow/Amber
            fraction: (pm10 / 150).clamp(0.05, 1.0),
          ),
        ],
      ),
    );
  }
}

class _SubParticulateRow extends StatelessWidget {
  final String label;
  final String value;
  final Color barColor;
  final double fraction;

  const _SubParticulateRow({
    required this.label,
    required this.value,
    required this.barColor,
    required this.fraction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTheme.font(fontSize: 11, color: AppTheme.textSecondary)),
            Text(value, style: AppTheme.font(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.primaryDark)),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 5,
            backgroundColor: const Color(0xFFE5E7EB),
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Card 2: GAS & SUHU (SCD41/SHT31)
// ──────────────────────────────────────────────────────────────────────────────

class _GasAndClimateCard extends StatelessWidget {
  final double temperature;
  final double humidity;
  final double co2;

  const _GasAndClimateCard({
    required this.temperature,
    required this.humidity,
    required this.co2,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCo2High = co2 > 800;
    final co2Color = isCo2High ? const Color(0xFFF59E0B) : AppTheme.success;

    return Container(
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
          Text(
            'GAS & SUHU (SCD41/SHT31)',
            style: AppTheme.font(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 16),

          // Temp & Humidity Row
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.thermostat_rounded, size: 20, color: Color(0xFFEF4444)),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('SUHU', style: AppTheme.font(fontSize: 10, color: AppTheme.textSecondary)),
                        Text(
                          '${temperature.toStringAsFixed(1)} °C',
                          style: AppTheme.font(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.primaryDark),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 36, color: AppTheme.borderLight),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.water_drop_rounded, size: 20, color: Color(0xFF06B6D4)),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('KELEMBABAN', style: AppTheme.font(fontSize: 10, color: AppTheme.textSecondary)),
                        Text(
                          '${humidity.toInt()} %',
                          style: AppTheme.font(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.primaryDark),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Divider(color: AppTheme.borderLight, height: 1),
          const SizedBox(height: 14),

          // CO2 Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'KADAR CO₂ (KARBONDIOKSIDA)',
                style: AppTheme.font(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: co2Color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isCo2High ? 'Tinggi' : 'Normal',
                  style: AppTheme.font(fontSize: 10, fontWeight: FontWeight.w700, color: co2Color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${co2.toInt()}',
                style: AppTheme.font(fontSize: 32, fontWeight: FontWeight.w800, color: AppTheme.primaryDark),
              ),
              const SizedBox(width: 6),
              Text(
                'ppm',
                style: AppTheme.font(fontSize: 13, color: AppTheme.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (co2 / 1200).clamp(0.1, 1.0),
              minHeight: 5,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation<Color>(co2Color),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Card 3: ARAH & KECEPATAN ANGIN
// ──────────────────────────────────────────────────────────────────────────────

class _WindCompassMiniCard extends StatelessWidget {
  final double windSpeed;
  final int windDir;
  final String windDirLabel;
  final double windSpeedKmh;

  const _WindCompassMiniCard({
    required this.windSpeed,
    required this.windDir,
    required this.windDirLabel,
    required this.windSpeedKmh,
  });

  @override
  Widget build(BuildContext context) {
    final double angleRad = (windDir * math.pi) / 180.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryDark.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ARAH & KEC. ANGIN',
            style: AppTheme.font(fontSize: 10, fontWeight: FontWeight.w700, color: AppTheme.textSecondary, letterSpacing: 0.6),
          ),
          const SizedBox(height: 12),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Compass Circle
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: AppTheme.mintContainer.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.borderLight, width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      'U',
                      style: AppTheme.font(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.primaryDark),
                    ),
                  ),
                ),
                // Rotating needle
                Transform.rotate(
                  angle: angleRad,
                  child: SizedBox(
                    width: 68,
                    height: 68,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.navigation_rounded, size: 24, color: AppTheme.primaryDark),
                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text('KECEPATAN ANGIN', style: AppTheme.font(fontSize: 9, color: AppTheme.textSecondary)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                windSpeed.toStringAsFixed(2),
                style: AppTheme.font(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.primaryDark),
              ),
              const SizedBox(width: 4),
              Text('m/s', style: AppTheme.font(fontSize: 11, color: AppTheme.textSecondary)),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'Arah: $windDir° (${windSpeedKmh.toStringAsFixed(1)} km/h)',
            style: AppTheme.font(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Card 4: SIRKULASI UDARA (KIPAS)
// ──────────────────────────────────────────────────────────────────────────────

class _FanCirculationCard extends StatelessWidget {
  final bool fanOn;
  final AnimationController animController;

  const _FanCirculationCard({
    required this.fanOn,
    required this.animController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryDark.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SIRKULASI UDARA (KIPAS)',
            style: AppTheme.font(fontSize: 10, fontWeight: FontWeight.w700, color: AppTheme.textSecondary, letterSpacing: 0.6),
          ),
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: fanOn ? const Color(0xFFE0F2FE) : const Color(0xFFF3F4F6),
                shape: BoxShape.circle,
                border: Border.all(
                  color: fanOn ? const Color(0xFF38BDF8) : AppTheme.borderLight,
                  width: 1.5,
                ),
              ),
              child: RotationTransition(
                turns: animController,
                child: Icon(
                  Icons.mode_fan_off_rounded,
                  size: 32,
                  color: fanOn ? const Color(0xFF0284C7) : AppTheme.textMuted,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            fanOn ? 'AKTIF (MEMOMPA)' : 'STANDBY (MATI)',
            style: AppTheme.font(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: fanOn ? AppTheme.success : AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Kipas berputar otomatis terjadwal untuk proses intake/exhaust.',
            style: AppTheme.font(fontSize: 9, color: AppTheme.textSecondary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Card 5: TREN GRAFIK REAL-TIME
// ──────────────────────────────────────────────────────────────────────────────

class _RealtimeChartCard extends StatelessWidget {
  final List<SensorData> history;
  final int activeTab; // 0: PM, 1: Gas & Suhu, 2: Kecepatan Angin
  final ValueChanged<int> onTabChanged;
  final VoidCallback onTapViewDetails;

  const _RealtimeChartCard({
    required this.history,
    required this.activeTab,
    required this.onTabChanged,
    required this.onTapViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final recent = history.take(15).toList().reversed.toList();

    return Container(
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
          // Header & Mode Tabs
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TREN GRAFIK REAL-TIME',
                style: AppTheme.font(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              GestureDetector(
                onTap: onTapViewDetails,
                child: Text(
                  'Lihat Semua →',
                  style: AppTheme.font(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primaryDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 3-Toggle Tabs (Partikulat, Gas & Suhu, Kecepatan Angin)
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                _TabButton(
                  title: 'Partikulat (PM)',
                  isSelected: activeTab == 0,
                  onTap: () => onTabChanged(0),
                ),
                _TabButton(
                  title: 'Gas & Suhu',
                  isSelected: activeTab == 1,
                  onTap: () => onTabChanged(1),
                ),
                _TabButton(
                  title: 'Kec. Angin',
                  isSelected: activeTab == 2,
                  onTap: () => onTabChanged(2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Chart Legends
          if (activeTab == 0) ...[
            Row(
              children: const [
                _ChartLegendDot(color: Color(0xFF3B82F6), label: 'PM 1.0'),
                SizedBox(width: 14),
                _ChartLegendDot(color: Color(0xFFEF4444), label: 'PM 2.5'),
                SizedBox(width: 14),
                _ChartLegendDot(color: Color(0xFFF59E0B), label: 'PM 10'),
              ],
            ),
          ] else if (activeTab == 1) ...[
            Row(
              children: const [
                _ChartLegendDot(color: Color(0xFF8B5CF6), label: 'CO₂'),
                SizedBox(width: 14),
                _ChartLegendDot(color: Color(0xFFEF4444), label: 'Suhu (°C)'),
                SizedBox(width: 14),
                _ChartLegendDot(color: Color(0xFF06B6D4), label: 'Lembab (%)'),
              ],
            ),
          ] else ...[
            Row(
              children: const [
                _ChartLegendDot(color: Color(0xFF10B981), label: 'Kecepatan Angin (m/s)'),
              ],
            ),
          ],
          const SizedBox(height: 16),

          // Canvas Chart
          SizedBox(
            height: 130,
            width: double.infinity,
            child: CustomPaint(
              painter: _MultiLineChartPainter(
                data: recent,
                mode: activeTab,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Live Buffer (15)', style: AppTheme.font(fontSize: 10, color: AppTheme.textMuted)),
              Text('Interval ~2000ms', style: AppTheme.font(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.success)),
              Text('Sekarang', style: AppTheme.font(fontSize: 10, color: AppTheme.textMuted)),
            ],
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({required this.title, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(13),
            boxShadow: isSelected
                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 4, offset: const Offset(0, 2))]
                : null,
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTheme.font(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppTheme.primaryDark : AppTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _ChartLegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _ChartLegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(label, style: AppTheme.font(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.primaryDark)),
      ],
    );
  }
}

class _MultiLineChartPainter extends CustomPainter {
  final List<SensorData> data;
  final int mode; // 0: PM, 1: Gas/Suhu, 2: Angin

  _MultiLineChartPainter({required this.data, required this.mode});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    // Grid lines
    final gridPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 0.8;

    for (int i = 0; i <= 3; i++) {
      final y = size.height * (i / 3);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final double stepX = size.width / (data.length > 1 ? data.length - 1 : 1);

    if (mode == 0) {
      // PM1, PM2.5, PM10
      _drawLine(canvas, size, stepX, data.map((e) => e.pm1).toList(), const Color(0xFF3B82F6), 0, 80);
      _drawLine(canvas, size, stepX, data.map((e) => e.pm25).toList(), const Color(0xFFEF4444), 0, 80);
      _drawLine(canvas, size, stepX, data.map((e) => e.pm10).toList(), const Color(0xFFF59E0B), 0, 80);
    } else if (mode == 1) {
      // CO2 (scaled), Temp, Humidity
      _drawLine(canvas, size, stepX, data.map((e) => e.temperature).toList(), const Color(0xFFEF4444), 10, 40);
      _drawLine(canvas, size, stepX, data.map((e) => e.humidity).toList(), const Color(0xFF06B6D4), 40, 100);
      _drawLine(canvas, size, stepX, data.map((e) => e.co2 / 10).toList(), const Color(0xFF8B5CF6), 30, 100);
    } else {
      // Wind speed
      _drawLine(canvas, size, stepX, data.map((e) => e.windSpeed).toList(), const Color(0xFF10B981), 0, 5);
    }
  }

  void _drawLine(Canvas canvas, Size size, double stepX, List<double> values, Color color, double min, double max) {
    if (values.isEmpty) return;
    final range = (max - min) == 0 ? 1.0 : (max - min);

    final path = Path();
    for (int i = 0; i < values.length; i++) {
      final x = i * stepX;
      final norm = ((values[i] - min) / range).clamp(0.0, 1.0);
      final y = size.height - (norm * (size.height - 16)) - 8;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MultiLineChartPainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.mode != mode;
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Card 6: DETAIL PERANGKAT
// ──────────────────────────────────────────────────────────────────────────────

class _DeviceDetailCard extends StatelessWidget {
  final bool isMqttConnected;
  final VoidCallback onTapMore;

  const _DeviceDetailCard({required this.isMqttConnected, required this.onTapMore});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Text(
                'DETAIL PERANGKAT',
                style: AppTheme.font(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              GestureDetector(
                onTap: onTapMore,
                child: Text(
                  'Selengkapnya →',
                  style: AppTheme.font(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primaryDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _DeviceFieldRow(label: 'Lokasi:', value: 'TPS Brakseng'),
          _DeviceFieldRow(label: 'Arsitektur:', value: 'ESP32 Dual-Core (FreeRTOS)'),
          _DeviceFieldRow(label: 'Pembagian Core:', value: 'Core 0: MQTT/OTA | Core 1: Sensors'),
          _DeviceFieldRow(label: 'Server Host:', value: 'b846d696536846c98fd9152...'),
          _DeviceFieldRow(label: 'Interval Baca:', value: '2000 ms'),
          _DeviceFieldRow(label: 'MQTT Session:', value: 'Clean Session'),
        ],
      ),
    );
  }
}

class _DeviceFieldRow extends StatelessWidget {
  final String label;
  final String value;

  const _DeviceFieldRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTheme.font(fontSize: 11, color: AppTheme.textSecondary)),
          Flexible(
            child: Text(
              value,
              style: AppTheme.font(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.primaryDark),
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertRow extends StatelessWidget {
  final String title;
  final String desc;
  final Color color;

  const _AlertRow({required this.title, required this.desc, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTheme.font(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 4),
          Text(desc, style: AppTheme.font(fontSize: 11, color: AppTheme.primaryDark)),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTheme.font(fontSize: 12, color: AppTheme.textSecondary)),
          Flexible(
            child: Text(
              value,
              style: AppTheme.font(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primaryDark),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
