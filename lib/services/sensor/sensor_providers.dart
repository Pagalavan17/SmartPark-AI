import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/digital_twin_model.dart';
import '../../models/sensor_data_model.dart';
import '../../providers/repository_providers.dart';

import 'sensor_event_dispatcher.dart';
import 'sensor_gateway.dart';
import 'sensor_simulation_engine.dart';
import 'sensor_event_service.dart';
import 'parking_status_synchronizer.dart';

final sensorEventDispatcherProvider = Provider<SensorEventDispatcher>((ref) {
  final dispatcher = SensorEventDispatcher();
  ref.onDispose(() => dispatcher.dispose());
  return dispatcher;
});

final sensorGatewayProvider = Provider<SensorGateway>((ref) {
  return SensorGateway(dispatcher: ref.watch(sensorEventDispatcherProvider));
});

final sensorSimulationProvider = Provider<SensorSimulationEngine>((ref) {
  final engine = SensorSimulationEngine(dispatcher: ref.watch(sensorEventDispatcherProvider));
  engine.startSimulation();
  ref.onDispose(() => engine.stopSimulation());
  return engine;
});

final sensorEventServiceProvider = Provider<SensorEventService>((ref) {
  return SensorEventService(
    sensorRepository: ref.watch(sensorRepositoryProvider),
    dispatcher: ref.watch(sensorEventDispatcherProvider),
  );
});

final parkingStatusSynchronizerProvider = Provider<ParkingStatusSynchronizer>((ref) {
  final synchronizer = ParkingStatusSynchronizer(
    dispatcher: ref.watch(sensorEventDispatcherProvider),
    digitalTwinRepository: ref.watch(digitalTwinRepositoryProvider),
    parkingRepository: ref.watch(parkingRepositoryProvider),
  );
  ref.onDispose(() => synchronizer.dispose());
  return synchronizer;
});

final digitalTwinStreamProvider = StreamProvider.family<DigitalTwinModel?, String>((ref, parkingId) {
  final sync = ref.watch(parkingStatusSynchronizerProvider);
  return sync.onDigitalTwinUpdated.where((twin) => twin.parkingId == parkingId);
});

final sensorHealthProvider = FutureProvider.family<List<SensorDataModel>, String>((ref, parkingId) {
  final repo = ref.watch(sensorRepositoryProvider);
  return repo.getRecentSensorEvents(parkingId);
});
