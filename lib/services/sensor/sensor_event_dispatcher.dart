import 'dart:async';
import '../../models/sensor_data_model.dart';

/// Central Reactive Event Dispatcher broadcasting hardware telemetry events
class SensorEventDispatcher {
  final StreamController<SensorDataModel> _eventStreamController =
      StreamController<SensorDataModel>.broadcast();

  Stream<SensorDataModel> get onSensorEvent => _eventStreamController.stream;

  void dispatchEvent(SensorDataModel event) {
    _eventStreamController.add(event);
  }

  void dispose() {
    _eventStreamController.close();
  }
}
