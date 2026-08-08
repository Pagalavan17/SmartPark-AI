import '../../models/digital_twin_model.dart';
import '../../models/parking_lot_model.dart';

/// Independent Digital Twin Service creating virtual telemetry models of physical parking facilities
class ParkingDigitalTwinService {
  DigitalTwinModel getFacilityDigitalTwin(ParkingLotModel parkingLot) {
    final int occupied = parkingLot.totalSlots - parkingLot.availableSlots;
    return DigitalTwinModel(
      parkingId: parkingLot.id,
      liveOccupiedSlots: occupied,
      liveTotalSlots: parkingLot.totalSlots,
      vehicleInflowRatePerHour: (occupied * 0.4).round(),
      vehicleOutflowRatePerHour: (occupied * 0.25).round(),
      currentSurgeMultiplier: parkingLot.isPeakHour ? 1.20 : 1.0,
      liveTrafficCongestion: parkingLot.trafficStatus,
      lastTelemetryUpdate: DateTime.now(),
    );
  }
}
