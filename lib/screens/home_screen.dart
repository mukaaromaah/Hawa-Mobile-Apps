import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hawa_mobile/models/sensor_data.dart';
import 'package:hawa_mobile/providers/sensor_provider.dart';
import 'package:hawa_mobile/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sensorProvider = context.watch<SensorProvider>();
    final data = sensorProvider.currentData;
    final isMqttConnected = sensorProvider.isConnectedMqtt;
    final pm25Value = data.pm25.toInt();
    final tempValue = data.temperature.toStringAsFixed(1);
    final humidValue = data.humidity.toInt();
    final windSpeed = data.windSpeed.toStringAsFixed(1);
    final co2Value = data.co2.toInt();
    final fanOn = data.fan;

    final bool isCritical = data.status == AirQualityStatus.critical;
    final bool isWarning = data.status == AirQualityStatus.warning;
    final String statusLabel = isCritical ? 'Berbahaya' : (isWarning ? 'Perhatian' : 'Baik');
    final Color statusColor = isCritical
        ? AppTheme.error
        : (isWarning ? AppTheme.warning : AppTheme.success);

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
        onRefresh: () => sensorProvider.init(),
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
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Location Pill
                    _LocationPill(),
                    // Avatar + Status
                    Row(
                      children: [
                        // MQTT dot
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: isMqttConnected ? AppTheme.success : AppTheme.textMuted,
                            shape: BoxShape.circle,
                            boxShadow: isMqttConnected
                                ? [BoxShadow(color: AppTheme.success.withValues(alpha: 0.5), blurRadius: 6, spreadRadius: 1)]
                                : null,
                          ),
                        ),
                        // Avatar
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryDark,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.person_rounded, color: Colors.white, size: 20),
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
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // ── Hero PM2.5 Card ──────────────────────────────
                _HeroCard(
                  pm25Value: pm25Value,
                  statusLabel: statusLabel,
                  statusColor: statusColor,
                  isCritical: isCritical,
                  isWarning: isWarning,
                  temp: tempValue,
                  humid: '$humidValue%',
                  wind: '$windSpeed m/s',
                ),
                const SizedBox(height: 20),

                // ── Quick Highlights (Fan + CO2) ─────────────────
                Row(
                  children: [
                    Expanded(
                      child: _HighlightCard(
                        icon: Icons.air_rounded,
                        title: 'Exhaust Fan',
                        value: fanOn ? 'ON' : 'OFF',
                        valueColor: fanOn ? AppTheme.success : AppTheme.textMuted,
                        subtitle: fanOn ? 'Aktif' : 'Mati',
                        accentColor: fanOn ? AppTheme.successContainer : const Color(0xFFF0F0F0),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _HighlightCard(
                        icon: Icons.co2_rounded,
                        title: 'Karbon (CO₂)',
                        value: '$co2Value',
                        valueColor: co2Value > 1000 ? AppTheme.error : AppTheme.primaryDark,
                        subtitle: 'ppm',
                        accentColor: co2Value > 1000 ? AppTheme.errorContainer : AppTheme.mintContainer,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // ── Section Header: Zona Monitoring ──────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Zona Monitoring',
                      style: AppTheme.font(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Lihat Semua →',
                        style: AppTheme.font(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // ── Zone Cards (only 2 primary) ───────────────────
                _ZoneCard(
                  zoneName: 'Zona 01 · Gerbang Utama',
                  icon: Icons.door_front_door_outlined,
                  pm25: pm25Value,
                  status: data.status,
                ),
                const SizedBox(height: 12),
                _ZoneCard(
                  zoneName: 'Zona 02 · Workshop',
                  icon: Icons.handyman_outlined,
                  pm25: 42,
                  status: AirQualityStatus.warning,
                ),
                const SizedBox(height: 20),

                // ── Last Update ───────────────────────────────────
                Center(
                  child: Text(
                    'Diperbarui: ${_formatTime(data.measuredAt)}',
                    style: AppTheme.font(
                      fontSize: 11,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inSeconds < 60) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} mnt lalu';
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Location Pill Widget
// ──────────────────────────────────────────────────────────────────────────────

class _LocationPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.9),
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
              Icon(
                Icons.location_on_rounded,
                color: AppTheme.primaryDark,
                size: 14,
              ),
              const SizedBox(width: 5),
              Text(
                'TPS Brakseng, Batu',
                style: AppTheme.font(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
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
  final int pm25Value;
  final String statusLabel;
  final Color statusColor;
  final bool isCritical;
  final bool isWarning;
  final String temp;
  final String humid;
  final String wind;

  const _HeroCard({
    required this.pm25Value,
    required this.statusLabel,
    required this.statusColor,
    required this.isCritical,
    required this.isWarning,
    required this.temp,
    required this.humid,
    required this.wind,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
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
              color: Colors.white.withValues(alpha: 0.9),
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
              // Label PM2.5
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'PM 2.5 · Udara Ambien',
                    style: AppTheme.font(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondary,
                    ),
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
                          statusLabel,
                          style: AppTheme.font(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Big Number
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$pm25Value',
                    style: AppTheme.font(
                      fontSize: 58,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryDark,
                      height: 0.9,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      'µg/m³',
                      style: AppTheme.font(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Divider
              Divider(color: AppTheme.primaryDark.withValues(alpha: 0.06), height: 1),
              const SizedBox(height: 16),
              // Bottom stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _HeroStat(icon: Icons.thermostat_rounded, label: 'Suhu', value: '$temp°C'),
                  _HeroStat(icon: Icons.water_drop_outlined, label: 'Lembab', value: humid),
                  _HeroStat(icon: Icons.air_rounded, label: 'Angin', value: wind),
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

  const _HeroStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppTheme.mintContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.primaryDark, size: 16),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTheme.font(
                fontSize: 10,
                color: AppTheme.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: AppTheme.font(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryDark,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Quick Highlight Card (Fan, CO2)
// ──────────────────────────────────────────────────────────────────────────────

class _HighlightCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color valueColor;
  final String subtitle;
  final Color accentColor;

  const _HighlightCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.valueColor,
    required this.subtitle,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.95),
                accentColor.withValues(alpha: 0.55),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.9),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryDark.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: valueColor, size: 20),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: AppTheme.font(
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: AppTheme.font(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: valueColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    subtitle,
                    style: AppTheme.font(
                      fontSize: 11,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Zone Card
// ──────────────────────────────────────────────────────────────────────────────

class _ZoneCard extends StatelessWidget {
  final String zoneName;
  final IconData icon;
  final int pm25;
  final AirQualityStatus status;

  const _ZoneCard({
    required this.zoneName,
    required this.icon,
    required this.pm25,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCritical = status == AirQualityStatus.critical;
    final bool isWarning = status == AirQualityStatus.warning;
    final String statusText = isCritical ? 'Kritis' : (isWarning ? 'Waspada' : 'Normal');
    final Color statusColor = isCritical
        ? AppTheme.error
        : (isWarning ? AppTheme.warning : AppTheme.success);
    final Color bgContainer = isCritical
        ? AppTheme.errorContainer
        : (isWarning ? AppTheme.warningContainer : AppTheme.mintContainer);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.9),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryDark.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: bgContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: statusColor, size: 22),
              ),
              const SizedBox(width: 14),
              // Zone Name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      zoneName,
                      style: AppTheme.font(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'PM2.5: $pm25 µg/m³',
                      style: AppTheme.font(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusText,
                  style: AppTheme.font(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
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
