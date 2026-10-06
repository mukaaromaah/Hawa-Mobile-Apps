enum AirQualityStatus {
  normal,
  warning,
  critical,
}

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

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      pm1: (json['pm1'] as num?)?.toDouble() ?? 0.0,
      pm25: (json['pm25'] as num?)?.toDouble() ?? 0.0,
      pm10: (json['pm10'] as num?)?.toDouble() ?? 0.0,
      co2: (json['co2'] as num?)?.toDouble() ?? 0.0,
      temperature: (json['temperature'] as num?)?.toDouble() ?? (json['temp'] as num?)?.toDouble() ?? 0.0,
      humidity: (json['humidity'] as num?)?.toDouble() ?? 0.0,
      windSpeed: (json['windSpeed'] as num?)?.toDouble() ?? (json['wind_speed'] as num?)?.toDouble() ?? 0.0,
      windDir: (json['windDir'] as num?)?.toInt() ?? (json['wind_dir'] as num?)?.toInt() ?? 0,
      fan: json['fan'] is bool ? json['fan'] : (json['fan'] == 1 || json['fan'] == '1' || json['fan'] == 'on'),
      measuredAt: () {
        final rawTime = json['measured_at'] ?? json['measuredAt'] ?? json['timestamp'];
        if (rawTime == null) return DateTime.now();
        if (rawTime is num) {
          final int val = rawTime.toInt();
          // If in seconds (10 digits), convert to milliseconds
          final int ms = val < 10000000000 ? val * 1000 : val;
          return DateTime.fromMillisecondsSinceEpoch(ms);
        }
        return DateTime.tryParse(rawTime.toString()) ?? DateTime.now();
      }(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pm1': pm1,
      'pm25': pm25,
      'pm10': pm10,
      'co2': co2,
      'temperature': temperature,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'windDir': windDir,
      'fan': fan,
      'measuredAt': measuredAt.toIso8601String(),
    };
  }

  // Kategori Kualitas Udara berdasarkan PM2.5
  String get airQualityCategory {
    if (pm25 <= 35) return 'Baik (Good)';
    if (pm25 <= 75) return 'Sedang (Moderate)';
    if (pm25 <= 150) return 'Tidak Sehat (Unhealthy)';
    return 'Berbahaya (Hazardous)';
  }

  // Status prioritas zona
  AirQualityStatus get status {
    if (pm25 > 100) return AirQualityStatus.critical;
    if (pm25 > 35) return AirQualityStatus.warning;
    return AirQualityStatus.normal;
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
