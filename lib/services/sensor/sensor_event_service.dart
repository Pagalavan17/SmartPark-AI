import '../../models/sensor_data_model.dart';
import '../../repositories/sensor_repository.dart';
import 'sensor_event_dispatcher.dart';

/// Business logic service processing sensor events and saving to repository
class SensorEventService {
  final ISensorRepository sensorRepository;
  final SensorEventDispatcher dispatcher;

  SensorEventService({
    required this.sensorRepository,
    required this.dispatcher,
  }) {
    dispatcher.onSensorEvent.listen(_handleEvent);
  }

  void _handleEvent(SensorDataModel event) async {
    await sensorRepository.recordSensorEvent(event);
  }
}
