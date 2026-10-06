import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hawa_mobile/models/sensor_data.dart';
import 'package:hawa_mobile/services/api_service.dart';
import 'package:hawa_mobile/services/mqtt_service.dart';

class SensorProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final MqttService _mqttService = MqttService();

  SensorData _currentData = SensorData.mockSample;
  List<SensorData> _historyData = [SensorData.mockSample];
  bool _isLoading = true;
  bool _isConnectedMqtt = false;

  SensorData get currentData => _currentData;
  List<SensorData> get historyData => _historyData;
  bool get isLoading => _isLoading;
  bool get isConnectedMqtt => _isConnectedMqtt;

  SensorProvider() {
    init();
  }

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    // 1. Initial snapshot from REST API
    _currentData = await _apiService.fetchLatestSensorData();
    _historyData = await _apiService.fetchHistoryData();
    _isLoading = false;
    notifyListeners();

    // 2. Connect to real-time MQTT Stream
    _isConnectedMqtt = await _mqttService.connect();
    notifyListeners();

    _mqttService.sensorStream.listen((newData) {
      _currentData = newData;
      _historyData.insert(0, newData);
      if (_historyData.length > 50) {
        _historyData.removeLast();
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _mqttService.disconnect();
    super.dispose();
  }
}
