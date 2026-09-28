import 'package:flutter/material.dart';
import 'package:hawa_mobile/models/sensor_data.dart';
import 'package:hawa_mobile/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Menggunakan data awal dari model mock
  final SensorData data = SensorData.mockSample;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.softGreen,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppTheme.primaryGreen,
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 600));
            setState(() {});
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Lokasi & Status
                _buildHeaderLocation(),
                const SizedBox(height: 16),

                // Kartu Utama Ringkasan Kualitas Udara (Hero Card)
                _buildAirQualityHeroCard(),
                const SizedBox(height: 20),

                // Particulate Matter (PM1, PM2.5, PM10)
                const Text(
                  'Partikulat Udara (PM)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                const SizedBox(height: 10),
                _buildParticulateRow(),
                const SizedBox(height: 20),

                // Parameter Lingkungan & Cuaca
                const Text(
                  'Kondisi Lingkungan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                const SizedBox(height: 10),
                _buildEnvironmentGrid(),
                const SizedBox(height: 20),

                // Status Perangkat Aktuator (Exhaust Fan)
                _buildActuatorCard(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 1. Header Lokasi & Waktu
  Widget _buildHeaderLocation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, size: 18, color: AppTheme.primaryGreen.withValues(alpha: 0.8)),
                const SizedBox(width: 4),
                const Text(
                  'TPS Brakseng',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              'Bumiaji, Kota Batu • Pemantauan Real-time',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.primaryGreen.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
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
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'Live',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryGreen,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 2. Kartu Utama Kualitas Udara
  Widget _buildAirQualityHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Indeks Kualitas Udara',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.accentGreen.withValues(alpha: 0.5)),
                ),
                child: Text(
                  data.airQualityCategory,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data.pm25.toStringAsFixed(1),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 8),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'µg/m³ (PM2.5)',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle_outline, color: AppTheme.accentGreen, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Kondisi udara di area TPS terpantau aman dan layak.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 3. Baris 3 Nilai Partikulat (PM1, PM2.5, PM10)
  Widget _buildParticulateRow() {
    return Row(
      children: [
        Expanded(child: _buildMiniMetricCard('PM 1.0', '${data.pm1}', 'µg/m³', Icons.grain)),
        const SizedBox(width: 10),
        Expanded(child: _buildMiniMetricCard('PM 2.5', '${data.pm25}', 'µg/m³', Icons.blur_on)),
        const SizedBox(width: 10),
        Expanded(child: _buildMiniMetricCard('PM 10', '${data.pm10}', 'µg/m³', Icons.cloud_queue)),
      ],
    );
  }

  Widget _buildMiniMetricCard(String title, String value, String unit, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryGreen),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryGreen.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryGreen,
            ),
          ),
          Text(
            unit,
            style: TextStyle(
              fontSize: 9,
              color: AppTheme.primaryGreen.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  // 4. Grid Kondisi Lingkungan (Suhu, Kelembapan, Angin, CO2)
  Widget _buildEnvironmentGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.6,
      children: [
        _buildEnvCard(
          'Suhu Udara',
          '${data.temperature}°C',
          Icons.thermostat_outlined,
          Colors.orangeAccent,
        ),
        _buildEnvCard(
          'Kelembapan',
          '${data.humidity}%',
          Icons.water_drop_outlined,
          Colors.blueAccent,
        ),
        _buildEnvCard(
          'Kecepatan Angin',
          '${data.windSpeed} m/s (${data.windDirectionLabel})',
          Icons.air,
          Colors.teal,
        ),
        _buildEnvCard(
          'Kadar CO₂',
          '${data.co2.toInt()} ppm',
          Icons.co2_outlined,
          Colors.indigoAccent,
        ),
      ],
    );
  }

  Widget _buildEnvCard(String label, String value, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryGreen.withValues(alpha: 0.7),
                ),
              ),
              Icon(icon, size: 18, color: iconColor),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }

  // 5. Status Aktuator Kipas (Exhaust Fan)
  Widget _buildActuatorCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: data.fan ? AppTheme.softGreen : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.mode_fan_off_outlined,
                  color: data.fan ? AppTheme.primaryGreen : Colors.grey,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Exhaust Fan TPS',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    data.fan ? 'Status: Aktif (Menyala Otomatis)' : 'Status: Siaga (Mati)',
                    style: TextStyle(
                      fontSize: 11,
                      color: data.fan ? Colors.green.shade700 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: data.fan ? Colors.green.shade50 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: data.fan ? Colors.green.shade300 : Colors.grey.shade300,
              ),
            ),
            child: Text(
              data.fan ? 'ON' : 'OFF',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: data.fan ? Colors.green.shade800 : Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
