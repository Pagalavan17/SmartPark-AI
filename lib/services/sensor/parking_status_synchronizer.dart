import 'dart:async';
import '../../models/digital_twin_model.dart';
import '../../models/sensor_data_model.dart';
import '../../repositories/digital_twin_repository.dart';
import '../../features/parking/domain/parking_repository.dart';
import 'sensor_event_dispatcher.dart';

/// Live Status Synchronizer converting hardware telemetry events into Digital Twin state
class ParkingStatusSynchronizer {
  final SensorEventDispatcher dispatcher;
  final IDigitalTwinRepository digitalTwinRepository;
  final IParkingRepository parkingRepository;

  final StreamController<DigitalTwinModel> _twinStreamController =
      StreamController<DigitalTwinModel>.broadcast();

  Stream<DigitalTwinModel> get onDigitalTwinUpdated => _twinStreamController.stream;

  ParkingStatusSynchronizer({
    required this.dispatcher,
    required this.digitalTwinRepository,
    required this.parkingRepository,
  }) {
    dispatcher.onSensorEvent.listen(_processTelemetryEvent);
  }

  void _processTelemetryEvent(SensorDataModel event) async {
    final currentTwin = await digitalTwinRepository.getDigitalTwinForLot(event.parkingId);
    if (currentTwin == null) return;

    int newOccupied = currentTwin.liveOccupiedSlots;
    int inflowDelta = 0;
    int outflowDelta = 0;

    if (event.eventType == SensorEventType.vehicleEntry || event.eventType == SensorEventType.slotOccupied) {
      newOccupied = (newOccupied + 1).clamp(0, currentTwin.liveTotalSlots);
      inflowDelta = 1;
    } else if (event.eventType == SensorEventType.vehicleExit || event.eventType == SensorEventType.slotVacated) {
      newOccupied = (newOccupied - 1).clamp(0, currentTwin.liveTotalSlots);
      outflowDelta = 1;
    }

    final updatedTwin = DigitalTwinModel(
      parkingId: currentTwin.parkingId,
      liveOccupiedSlots: newOccupied,
      liveTotalSlots: currentTwin.liveTotalSlots,
      vehicleInflowRatePerHour: (currentTwin.vehicleInflowRatePerHour + inflowDelta).clamp(0, 500),
      vehicleOutflowRatePerHour: (currentTwin.vehicleOutflowRatePerHour + outflowDelta).clamp(0, 500),
      currentSurgeMultiplier: newOccupied > (currentTwin.liveTotalSlots * 0.85) ? 1.25 : 1.0,
      liveTrafficCongestion: newOccupied > (currentTwin.liveTotalSlots * 0.8) ? 'Heavy Traffic' : 'Clear Flow',
      lastTelemetryUpdate: DateTime.now(),
    );

    await digitalTwinRepository.updateDigitalTwinTelemetry(updatedTwin);
    _twinStreamController.add(updatedTwin);
  }

  void dispose() {
    _twinStreamController.close();
  }
}
