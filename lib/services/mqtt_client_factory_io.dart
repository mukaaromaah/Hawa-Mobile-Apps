import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

MqttClient createMqttClient(String broker, String clientId, int port) {
  final client = MqttServerClient(broker, clientId);
  client.port = port;
  client.secure = true;
  return client;
}
