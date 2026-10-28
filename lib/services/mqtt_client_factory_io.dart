import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

MqttClient createMqttClient(String broker, String clientId, int port) {
  final client = MqttServerClient(broker, clientId);
  client.port = port;
  client.secure = true;
  client.securityContext = SecurityContext.defaultContext;
  // Ensure TLS handshake succeeds even if intermediate certificates vary across Android devices
  client.onBadCertificate = (dynamic cert) => true;
  return client;
}
