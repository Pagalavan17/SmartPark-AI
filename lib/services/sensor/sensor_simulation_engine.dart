import 'dart:async';
import 'dart:math';
import '../../models/sensor_data_model.dart';
import 'sensor_event_dispatcher.dart';

/// Real-time Simulation Engine generating hardware sensor telemetry
class SensorSimulationEngine {
  final SensorEventDispatcher dispatcher;
  Timer? _timer;
  final Random _random = Random();

  static const List<SensorType> _sensorTypes = SensorType.values;
  static const List<SensorEventType> _eventTypes = SensorEventType.values;
  static const List<String> _parkingIds = ['spot_metro', 'spot_express', 'spot_phoenix', 'spot_forum'];
  static const List<String> _plates = ['TN 01 AB 1234', 'TN 09 EV 9999', 'TN 07 CK 5555', 'TN 05 XY 8888'];

  SensorSimulationEngine({required this.dispatcher});

  void startSimulation({Duration interval = const Duration(seconds: 4)}) {
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) => _generateSimulatedEvent());
  }

  void stopSimulation() {
    _timer?.cancel();
  }

  void _generateSimulatedEvent() {
    final parkingId = _parkingIds[_random.nextInt(_parkingIds.length)];
    final slotId = 'Slot A-${_random.nextInt(50) + 1}';
    final sensorType = _sensorTypes[_random.nextInt(_sensorTypes.length)];
    final eventType = _eventTypes[_random.nextInt(_eventTypes.length)];
    final plate = _plates[_random.nextInt(_plates.length)];

    final event = SensorDataModel(
      sensorId: 'SNSR-${_random.nextInt(9000) + 1000}',
      parkingId: parkingId,
      slotId: slotId,
      sensorType: sensorType,
      eventType: eventType,
      detectedLicensePlate: plate,
      confidenceScore: (90.0 + _random.nextDouble() * 9.0).roundToDouble(),
      isOnline: _random.nextDouble() > 0.05, // 95% online reliability
      telemetryPayload: {
        'signalStrength': -65 + _random.nextInt(15),
        'batteryLevel': 95 - _random.nextInt(10),
        'barrierStatus': _random.nextBool() ? 'OPEN' : 'CLOSED',
      },
      timestamp: DateTime.now(),
    );

    dispatcher.dispatchEvent(event);
  }
}
