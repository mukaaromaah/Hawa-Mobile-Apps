class SensorData {
  final double pm1;
  final double pm25;
  final double pm10;
  final double co2;
  final double temperature;
  final double humidity;
  final double windSpeed;
  final int windDir;
  final bool fan;
  final DateTime measuredAt;

  const SensorData({
    required this.pm1,
    required this.pm25,
    required this.pm10,
    required this.co2,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.windDir,
    required this.fan,
    required this.measuredAt,
  });

  // Kategori Kualitas Udara berdasarkan PM2.5
  String get airQualityCategory {
    if (pm25 <= 15) return 'Baik (Good)';
    if (pm25 <= 55) return 'Sedang (Moderate)';
    if (pm25 <= 150) return 'Tidak Sehat (Unhealthy)';
    return 'Berbahaya (Hazardous)';
  }

  // Arah mata angin dari derajat (0-360)
  String get windDirectionLabel {
    const directions = ['U', 'TL', 'T', 'TG', 'S', 'BD', 'B', 'BL'];
    int index = ((windDir + 22.5) % 360 ~/ 45);
    return directions[index];
  }

  // Mock data awal (berdasarkan data tipikal TPS Brakseng)
  static SensorData get mockSample => SensorData(
    pm1: 8.5,
    pm25: 18.2,
    pm10: 24.6,
    co2: 432.0,
    temperature: 24.8,
    humidity: 78.0,
    windSpeed: 2.4,
    windDir: 135,
    fan: true,
    measuredAt: DateTime.now().subtract(const Duration(minutes: 2)),
  );
}
