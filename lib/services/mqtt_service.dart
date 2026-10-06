import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:hawa_mobile/models/sensor_data.dart';

class MqttService {
  final String broker;
  final int port;
  final String clientId;
  final String topic;
  final String username;
  final String password;

  MqttServerClient? _client;
  final StreamController<SensorData> _sensorDataController = StreamController<SensorData>.broadcast();

  Stream<SensorData> get sensorStream => _sensorDataController.stream;

  MqttService({
    this.broker = 'b846d696536846c98fd91529e90260aa.s1.eu.hivemq.cloud',
    this.port = 8883,
    String? clientId,
    this.topic = 'tpa/monitor/data',
    this.username = 'tpsbrakseng',
    this.password = 'YudiTolol123',
  }) : clientId = clientId ?? 'hawa_mobile_${DateTime.now().millisecondsSinceEpoch}';

  Future<bool> connect() async {
    if (kIsWeb) {
      debugPrint('ℹ️ [MQTT] Flutter Web mode: MqttServerClient uses raw sockets. Use Mobile/Emulator for full TLS MQTT connection.');
      return false;
    }

    _client = MqttServerClient(broker, clientId);
    _client!.port = port;
    _client!.secure = true; // HiveMQ Cloud requires TLS/SSL
    _client!.logging(on: false);
    _client!.keepAlivePeriod = 30;
    _client!.autoReconnect = true;
    _client!.onDisconnected = _onDisconnected;
    _client!.onConnected = _onConnected;

    final connMess = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .authenticateAs(username, password)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    _client!.connectionMessage = connMess;

    try {
      debugPrint('🔄 [MQTT] Connecting to HiveMQ Cloud ($broker:$port)...');
      await _client!.connect();
    } catch (e) {
      debugPrint('❌ [MQTT] Connection exception: $e');
      _client!.disconnect();
      return false;
    }

    if (_client!.connectionStatus != null &&
        _client!.connectionStatus!.state == MqttConnectionState.connected) {
      debugPrint('✅ [MQTT] Connected successfully to HiveMQ Cloud! Subscribing to $topic...');
      _client!.subscribe(topic, MqttQos.atMostOnce);
      _listenToMessages();
      return true;
    } else {
      debugPrint('⚠️ [MQTT] Connection status: ${_client!.connectionStatus?.state}');
      _client!.disconnect();
      return false;
    }
  }

  void _listenToMessages() {
    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      if (c == null || c.isEmpty) return;

      final recMess = c[0].payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      try {
        debugPrint('📩 [MQTT] Telemetry received: $payload');
        final Map<String, dynamic> json = jsonDecode(payload);
        final sensorData = SensorData.fromJson(json);
        _sensorDataController.add(sensorData);
      } catch (e) {
        debugPrint('⚠️ [MQTT] Error parsing payload: $e');
      }
    });
  }

  void _onConnected() {
    debugPrint('🟢 [MQTT] Connected event triggered');
  }

  void _onDisconnected() {
    debugPrint('🔴 [MQTT] Disconnected event triggered');
  }

  void disconnect() {
    _client?.disconnect();
    _sensorDataController.close();
  }
}
