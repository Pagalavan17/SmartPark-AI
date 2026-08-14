import 'dart:async';
import 'package:flutter/foundation.dart';
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

final digitalTwinStreamProvider = StreamProvider.family<DigitalTwinModel?, String>((ref, parkingId) async* {
  final repo = ref.watch(digitalTwinRepositoryProvider);
  final sync = ref.watch(parkingStatusSynchronizerProvider);

  // 1. Initial fetch from repository with 10s timeout
  try {
    final initialTwin = await repo.getDigitalTwinForLot(parkingId).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        throw TimeoutException('Digital Twin telemetry request timed out after 10s');
      },
    );
    yield initialTwin;
  } catch (e, st) {
    debugPrint('digitalTwinStreamProvider initial fetch error for $parkingId: $e');
    debugPrintStack(stackTrace: st);
    rethrow;
  }

  // 2. Yield live updates from in-memory event stream
  try {
    await for (final twin in sync.onDigitalTwinUpdated.where((t) => t.parkingId == parkingId)) {
      yield twin;
    }
  } catch (e, st) {
    debugPrint('digitalTwinStreamProvider live stream update error for $parkingId: $e');
    debugPrintStack(stackTrace: st);
  }
});

final sensorHealthProvider = FutureProvider.family<List<SensorDataModel>, String>((ref, parkingId) {
  final repo = ref.watch(sensorRepositoryProvider);
  return repo.getRecentSensorEvents(parkingId);
});
