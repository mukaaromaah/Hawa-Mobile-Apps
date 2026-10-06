import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hawa_mobile/models/sensor_data.dart';

class ApiService {
  final String baseUrl;

  ApiService({this.baseUrl = 'http://localhost:5000/api'});

  Future<SensorData> fetchLatestSensorData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tps-brakseng/latest'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return SensorData.fromJson(json['data'] ?? json);
      } else {
        return SensorData.mockSample;
      }
    } catch (_) {
      // Return realistic mock sample if backend is offline
      return SensorData.mockSample;
    }
  }

  Future<List<SensorData>> fetchHistoryData({int limit = 20}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tps-brakseng/history?limit=$limit'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> list = body['data'] ?? [];
        if (list.isNotEmpty) {
          return list.map((json) => SensorData.fromJson(json)).toList();
        }
      }
    } catch (_) {
      // Fallback
    }
    return [SensorData.mockSample];
  }
}
