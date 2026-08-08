import 'package:equatable/equatable.dart';

/// Digital Twin virtual state model representing live telemetry of a parking lot
class DigitalTwinModel extends Equatable {
  final String parkingId;
  final int liveOccupiedSlots;
  final int liveTotalSlots;
  final int vehicleInflowRatePerHour; // e.g. 45 vehicles/hr
  final int vehicleOutflowRatePerHour; // e.g. 30 vehicles/hr
  final double currentSurgeMultiplier;
  final String liveTrafficCongestion; // "Clear Flow", "Moderate", "Heavy Traffic"
  final DateTime lastTelemetryUpdate;

  const DigitalTwinModel({
    required this.parkingId,
    required this.liveOccupiedSlots,
    required this.liveTotalSlots,
    required this.vehicleInflowRatePerHour,
    required this.vehicleOutflowRatePerHour,
    required this.currentSurgeMultiplier,
    required this.liveTrafficCongestion,
    required this.lastTelemetryUpdate,
  });

  Map<String, dynamic> toMap() {
    return {
      'parkingId': parkingId,
      'liveOccupiedSlots': liveOccupiedSlots,
      'liveTotalSlots': liveTotalSlots,
      'vehicleInflowRatePerHour': vehicleInflowRatePerHour,
      'vehicleOutflowRatePerHour': vehicleOutflowRatePerHour,
      'currentSurgeMultiplier': currentSurgeMultiplier,
      'liveTrafficCongestion': liveTrafficCongestion,
      'lastTelemetryUpdate': lastTelemetryUpdate.toIso8601String(),
    };
  }

  factory DigitalTwinModel.fromMap(Map<String, dynamic> map, String id) {
    return DigitalTwinModel(
      parkingId: id,
      liveOccupiedSlots: (map['liveOccupiedSlots'] ?? 76).toInt(),
      liveTotalSlots: (map['liveTotalSlots'] ?? 100).toInt(),
      vehicleInflowRatePerHour: (map['vehicleInflowRatePerHour'] ?? 42).toInt(),
      vehicleOutflowRatePerHour: (map['vehicleOutflowRatePerHour'] ?? 28).toInt(),
      currentSurgeMultiplier: (map['currentSurgeMultiplier'] ?? 1.2).toDouble(),
      liveTrafficCongestion: map['liveTrafficCongestion'] ?? 'Clear Flow (15%)',
      lastTelemetryUpdate: DateTime.tryParse(map['lastTelemetryUpdate'] ?? '') ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        parkingId,
        liveOccupiedSlots,
        liveTotalSlots,
        vehicleInflowRatePerHour,
        vehicleOutflowRatePerHour,
        currentSurgeMultiplier,
        liveTrafficCongestion,
        lastTelemetryUpdate,
      ];
}
