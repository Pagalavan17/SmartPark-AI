import '../../models/sensor_data_model.dart';
import 'sensor_event_dispatcher.dart';

/// Sensor Gateway Layer abstracting IoT, CCTV, ANPR, RFID, and Barrier Gate hardware
class SensorGateway {
  final SensorEventDispatcher dispatcher;

  SensorGateway({required this.dispatcher});

  /// Manual ingestion hook for external hardware gateways (REST / MQTT / WebSockets)
  void ingestHardwarePayload(Map<String, dynamic> rawPayload) {
    final event = SensorDataModel.fromMap(
      rawPayload,
      rawPayload['sensorId'] ?? 'EXT-SNSR-${DateTime.now().millisecondsSinceEpoch}',
    );
    dispatcher.dispatchEvent(event);
  }
}
