import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';

MqttClient createMqttClient(String broker, String clientId, int port) {
  // HiveMQ Cloud WebSockets URL format
  final String wsUrl = broker.startsWith('ws') ? broker : 'wss://$broker/mqtt';
  final client = MqttBrowserClient(wsUrl, clientId);
  client.port = 8884; // Standard HiveMQ Cloud WebSocket TLS port
  client.websocketProtocols = MqttClientConstants.protocolsSingleDefault;
  client.setProtocolV311();
  return client;
}
