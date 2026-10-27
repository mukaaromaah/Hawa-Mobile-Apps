import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hawa_mobile/models/sensor_data.dart';
import 'package:hawa_mobile/providers/sensor_provider.dart';
import 'package:hawa_mobile/screens/profile_screen.dart';
import 'package:hawa_mobile/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<int>? onNavigateToTab;

  const HomeScreen({super.key, this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    final sensorProvider = context.watch<SensorProvider>();
    final data = sensorProvider.currentData;
    final history = sensorProvider.historyData;
    final isMqttConnected = sensorProvider.isConnectedMqtt;

    final pm25Value = data.pm25.toInt();
    final tempValue = data.temperature.toStringAsFixed(1);
    final humidValue = data.humidity.toInt();
    final windSpeed = data.windSpeed.toStringAsFixed(1);
    final co2Value = data.co2.toInt();
    final fanOn = data.fan;

    final bool isCritical = data.status == AirQualityStatus.critical;
    final bool isWarning = data.status == AirQualityStatus.warning;
    final String statusLabel = isCritical ? 'Berbahaya' : (isWarning ? 'Perhatian' : 'Normal');
    final Color statusColor = isCritical
        ? AppTheme.error
        : (isWarning ? AppTheme.warning : AppTheme.success);

    final bool hasAlert = isWarning || isCritical || co2Value > 800;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE8F5EE), // Mint hijau lembut
            Color(0xFFF7FAF8), // Off-white sejuk
            Color(0xFFEDF7F2), // Hijau sangat muda
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
            // ─── App Bar ──────────────────────────────────────────
            SliverToBoxAdapter(
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Location Pill
                      const _LocationPill(),

                      // Actions: Telemetry Info + Alert Bell + Avatar
                      Row(
                        children: [
                          // Info System Button
                          IconButton(
                            onPressed: () => _showSystemInfoSheet(context, data, isMqttConnected),
                            icon: const Icon(Icons.info_outline_rounded, color: AppTheme.primaryDark, size: 22),
                            tooltip: 'Informasi Telemetri',
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white.withValues(alpha: 0.8),
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(8),
                            ),
                          ),
                          const SizedBox(width: 6),

                          // Alert Bell Button
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              IconButton(
                                onPressed: () => _showAlertSheet(context, data, hasAlert),
                                icon: Icon(
                                  hasAlert ? Icons.notifications_active_rounded : Icons.notifications_outlined,
                                  color: hasAlert ? AppTheme.warning : AppTheme.primaryDark,
                                  size: 22,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.white.withValues(alpha: 0.8),
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(8),
                                ),
                              ),
                              if (hasAlert)
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: Container(
                                    width: 9,
                                    height: 9,
                                    decoration: const BoxDecoration(
                                      color: AppTheme.error,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 8),

                          // Profile Avatar
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: const Duration(milliseconds: 300),
                                  pageBuilder: (context, animation, secondaryAnimation) => const ProfileScreen(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0.05, 0),
                                        end: Offset.zero,
                                      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
                                      child: FadeTransition(opacity: animation, child: child),
                                    );
                                  },
                                ),
                              );
                            },
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryDark,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryDark.withValues(alpha: 0.15),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.person_rounded, color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ─── Body Content ─────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── Hero PM2.5 Card ──────────────────────────────
                  _HeroCard(
                    pm1Value: data.pm1,
                    pm25Value: pm25Value,
                    pm10Value: data.pm10,
                    statusLabel: statusLabel,
                    statusColor: statusColor,
                    isCritical: isCritical,
                    isWarning: isWarning,
                    temp: tempValue,
                    humid: '$humidValue%',
                    wind: '$windSpeed m/s',
                    isLive: isMqttConnected,
                  ),
                  const SizedBox(height: 16),

                  // ── Highlights Row: Fan Status & CO2 ───────────────
                  Row(
                    children: [
                      Expanded(
                        child: _HighlightCard(
                          icon: Icons.air_rounded,
                          title: 'Sistem Kipas',
                          value: fanOn ? 'AKTIF' : 'STANDBY',
                          valueColor: fanOn ? AppTheme.success : AppTheme.textMuted,
                          subtitle: fanOn ? 'Exhaust On' : 'Otomatis',
                          accentColor: fanOn ? AppTheme.successContainer : const Color(0xFFF0F0F0),
                          isSpinning: fanOn,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _HighlightCard(
                          icon: Icons.co2_rounded,
                          title: 'Gas Karbon (CO₂)',
                          value: '$co2Value',
                          valueColor: co2Value > 1000 ? AppTheme.error : AppTheme.primaryDark,
                          subtitle: 'ppm · ${co2Value > 1000 ? "Tinggi" : "Normal"}',
                          accentColor: co2Value > 1000 ? AppTheme.errorContainer : AppTheme.mintContainer,
                          isSpinning: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Wind Direction & Compass Card ─────────────────
                  _WindCompassCard(
                    windSpeed: data.windSpeed,
                    windDir: data.windDir,
                    windDirLabel: data.windDirectionLabel,
                  ),
                  const SizedBox(height: 16),

                  // ── Real-Time Streaming Chart (15 points) ─────────
                  _RealtimeMiniChart(
                    history: history,
                    onTapViewAll: () => onNavigateToTab?.call(1),
                  ),
                  const SizedBox(height: 16),

                  // ── Telemetry Hardware Card ───────────────────────
                  _HardwareSpecsCard(
                    isMqttConnected: isMqttConnected,
                    measuredAt: data.measuredAt,
                    onTapDetails: () => _showSystemInfoSheet(context, data, isMqttConnected),
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
                    color: hasAlert ? AppTheme.warning : AppTheme.success,
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
                    desc: 'Nilai saat ini: ${data.pm25.toStringAsFixed(1)} µg/m³ (Batas aman: 35 µg/m³).',
                    color: AppTheme.warning,
                  ),
                if (data.co2 > 800)
                  _AlertRow(
                    title: 'Konsentrasi Gas Karbon (CO₂) Meningkat',
                    desc: 'Nilai saat ini: ${data.co2.toInt()} ppm (Batas normal: 800 ppm).',
                    color: AppTheme.warning,
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
                  const Icon(Icons.hub_rounded, color: AppTheme.primaryDark, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    'Spesifikasi Node & Telemetri',
                    style: AppTheme.font(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.primaryDark),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _DetailRow(label: 'Node Hardware', value: 'ESP32 Dual-Core (FreeRTOS)'),
              _DetailRow(label: 'Lokasi Alat', value: 'TPS3R Brakseng, Bumiaji, Kota Batu'),
              _DetailRow(label: 'Protokol', value: 'MQTT over TLS (Port 8883)'),
              _DetailRow(label: 'Broker', value: 'HiveMQ Cloud'),
              _DetailRow(label: 'Topik MQTT', value: 'tpa/monitor/data'),
              _DetailRow(label: 'Sampling Rate', value: '~2000 ms (2 detik)'),
              _DetailRow(label: 'Penyimpanan', value: 'Cloud Supabase'),
              _DetailRow(label: 'Status Kipas', value: data.fan ? 'Aktif (Relay ON)' : 'Standby (Relay OFF)'),
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
                  child: Text('Mengerti', style: AppTheme.font(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
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
          Text(value, style: AppTheme.font(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primaryDark)),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Location Pill Widget
// ──────────────────────────────────────────────────────────────────────────────

class _LocationPill extends StatelessWidget {
  const _LocationPill();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryDark.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.location_on_rounded,
                color: AppTheme.primaryDark,
                size: 15,
              ),
              const SizedBox(width: 5),
              Text(
                'TPS3R Brakseng, Batu',
                style: AppTheme.font(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Hero Card
// ──────────────────────────────────────────────────────────────────────────────

class _HeroCard extends StatelessWidget {
  final double pm1Value;
  final int pm25Value;
  final double pm10Value;
  final String statusLabel;
  final Color statusColor;
  final bool isCritical;
  final bool isWarning;
  final String temp;
  final String humid;
  final String wind;
  final bool isLive;

  const _HeroCard({
    required this.pm1Value,
    required this.pm25Value,
    required this.pm10Value,
    required this.statusLabel,
    required this.statusColor,
    required this.isCritical,
    required this.isWarning,
    required this.temp,
    required this.humid,
    required this.wind,
    required this.isLive,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.95),
                AppTheme.mintContainer.withValues(alpha: 0.45),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryDark.withValues(alpha: 0.07),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Category + Status Pill
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: isLive ? AppTheme.success : AppTheme.textMuted,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isLive ? 'LIVE MONITOR · PM2.5' : 'OFFLINE SNAPSHOT · PM2.5',
                        style: AppTheme.font(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textSecondary,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  // Status pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          statusLabel.toUpperCase(),
                          style: AppTheme.font(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Big Number + Sub-metrics
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$pm25Value',
                    style: AppTheme.font(
                      fontSize: 56,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primaryDark,
                      height: 0.9,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'µg/m³',
                      style: AppTheme.font(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // PM1.0 and PM10 sub-tags
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.borderLight),
                        ),
                        child: Text(
                          'PM1.0: ${pm1Value.toStringAsFixed(1)} µg/m³',
                          style: AppTheme.font(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primaryDark),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.borderLight),
                        ),
                        child: Text(
                          'PM10: ${pm10Value.toStringAsFixed(1)} µg/m³',
                          style: AppTheme.font(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primaryDark),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Divider
              Divider(color: AppTheme.primaryDark.withValues(alpha: 0.08), height: 1),
              const SizedBox(height: 14),

              // Bottom Stats: Temp, Humid, Wind
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _HeroStat(icon: Icons.thermostat_rounded, label: 'Suhu', value: '$temp°C'),
                  _HeroStat(icon: Icons.water_drop_outlined, label: 'Kelembaban', value: humid),
                  _HeroStat(icon: Icons.air_rounded, label: 'Kecepatan', value: wind),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _HeroStat({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.primaryDark),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTheme.font(fontSize: 10, color: AppTheme.textSecondary)),
            Text(value, style: AppTheme.font(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.primaryDark)),
          ],
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Highlight Card
// ──────────────────────────────────────────────────────────────────────────────

class _HighlightCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color valueColor;
  final String subtitle;
  final Color accentColor;
  final bool isSpinning;

  const _HighlightCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.valueColor,
    required this.subtitle,
    required this.accentColor,
    required this.isSpinning,
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
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppTheme.primaryDark, size: 20),
              ),
              if (isSpinning)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'RUNNING',
                    style: AppTheme.font(fontSize: 9, fontWeight: FontWeight.w800, color: AppTheme.success),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTheme.font(fontSize: 11, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTheme.font(fontSize: 18, fontWeight: FontWeight.w800, color: valueColor),
          ),
          Text(
            subtitle,
            style: AppTheme.font(fontSize: 11, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Wind Compass Card
// ──────────────────────────────────────────────────────────────────────────────

class _WindCompassCard extends StatelessWidget {
  final double windSpeed;
  final int windDir;
  final String windDirLabel;

  const _WindCompassCard({
    required this.windSpeed,
    required this.windDir,
    required this.windDirLabel,
  });

  @override
  Widget build(BuildContext context) {
    final double angleRad = (windDir * math.pi) / 180.0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Visual Compass Rose
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: AppTheme.mintContainer.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.borderLight, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    'U',
                    style: AppTheme.font(fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.primaryDark),
                  ),
                ),
              ),
              // Needle pointing to wind direction
              Transform.rotate(
                angle: angleRad,
                child: SizedBox(
                  width: 68,
                  height: 68,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.navigation_rounded, size: 24, color: AppTheme.primaryDark),
                      const SizedBox(height: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Arah & Kecepatan Angin',
                  style: AppTheme.font(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${windSpeed.toStringAsFixed(2)} m/s',
                      style: AppTheme.font(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.primaryDark),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.mintContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '$windDir° $windDirLabel',
                        style: AppTheme.font(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.primaryDark),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Mendukung analisis penyebaran aroma & partikel',
                  style: AppTheme.font(fontSize: 10, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Realtime Mini Chart Card (15 points)
// ──────────────────────────────────────────────────────────────────────────────

class _RealtimeMiniChart extends StatelessWidget {
  final List<SensorData> history;
  final VoidCallback onTapViewAll;

  const _RealtimeMiniChart({required this.history, required this.onTapViewAll});

  @override
  Widget build(BuildContext context) {
    final recent = history.take(15).toList();
    final points = recent.map((e) => e.pm25).toList().reversed.toList();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.show_chart_rounded, size: 18, color: AppTheme.primaryDark),
                  const SizedBox(width: 6),
                  Text(
                    'Grafik Real-Time (15 Titik)',
                    style: AppTheme.font(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.primaryDark),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onTapViewAll,
                child: Text(
                  'Lihat Tren →',
                  style: AppTheme.font(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primaryDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Mini line canvas
          SizedBox(
            height: 90,
            width: double.infinity,
            child: points.isEmpty
                ? Center(child: Text('Menunggu data...', style: AppTheme.font(fontSize: 11, color: AppTheme.textMuted)))
                : CustomPaint(
                    painter: _MiniSparklinePainter(
                      points: points,
                      lineColor: AppTheme.primaryDark,
                    ),
                  ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('15 sampling lalu', style: AppTheme.font(fontSize: 9, color: AppTheme.textMuted)),
              Text('Live MQTT (~2s)', style: AppTheme.font(fontSize: 9, fontWeight: FontWeight.w600, color: AppTheme.success)),
              Text('Sekarang', style: AppTheme.font(fontSize: 9, color: AppTheme.textMuted)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniSparklinePainter extends CustomPainter {
  final List<double> points;
  final Color lineColor;

  _MiniSparklinePainter({required this.points, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final double min = points.reduce((a, b) => a < b ? a : b);
    final double max = points.reduce((a, b) => a > b ? a : b);
    final double range = (max - min) == 0 ? 1.0 : (max - min);

    final stepX = size.width / (points.length > 1 ? points.length - 1 : 1);

    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final x = i * stepX;
      final norm = (points[i] - min) / range;
      final y = size.height - (norm * (size.height - 16)) - 8;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, paint);

    // Latest dot
    if (points.isNotEmpty) {
      final lastX = (points.length - 1) * stepX;
      final lastNorm = (points.last - min) / range;
      final lastY = size.height - (lastNorm * (size.height - 16)) - 8;

      canvas.drawCircle(Offset(lastX, lastY), 4, Paint()..color = AppTheme.success);
    }
  }

  @override
  bool shouldRepaint(covariant _MiniSparklinePainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Hardware Specs Card
// ──────────────────────────────────────────────────────────────────────────────

class _HardwareSpecsCard extends StatelessWidget {
  final bool isMqttConnected;
  final DateTime measuredAt;
  final VoidCallback onTapDetails;

  const _HardwareSpecsCard({
    required this.isMqttConnected,
    required this.measuredAt,
    required this.onTapDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'INFORMASI TELEMETRI PERANGKAT',
                style: AppTheme.font(fontSize: 10, fontWeight: FontWeight.w700, color: AppTheme.textSecondary, letterSpacing: 0.8),
              ),
              GestureDetector(
                onTap: onTapDetails,
                child: Text(
                  'Detail →',
                  style: AppTheme.font(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primaryDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _TeleItem(label: 'Node', value: 'ESP32 Dual-Core'),
              _TeleItem(label: 'OS', value: 'FreeRTOS'),
              _TeleItem(label: 'Sampling', value: '~2000 ms'),
              _TeleItem(label: 'Broker', value: 'HiveMQ TLS'),
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

  const _TeleItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTheme.font(fontSize: 10, color: AppTheme.textSecondary)),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTheme.font(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.primaryDark),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
