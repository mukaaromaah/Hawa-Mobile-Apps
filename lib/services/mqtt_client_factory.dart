import 'package:mqtt_client/mqtt_client.dart';
import 'mqtt_client_factory_stub.dart'
    if (dart.library.io) 'mqtt_client_factory_io.dart'
    if (dart.library.js_interop) 'mqtt_client_factory_web.dart'
    if (dart.library.html) 'mqtt_client_factory_web.dart';

abstract class MqttClientFactory {
  static MqttClient create(String broker, String clientId, int port) {
    return createMqttClient(broker, clientId, port);
  }
}
