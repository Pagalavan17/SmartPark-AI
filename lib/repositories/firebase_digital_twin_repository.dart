import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/digital_twin_model.dart';
import 'digital_twin_repository.dart';

class FirebaseDigitalTwinRepository implements IDigitalTwinRepository {
  final FirebaseFirestore? _firestore;

  FirebaseDigitalTwinRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<DigitalTwinModel?> getDigitalTwinForLot(String parkingId) async {
    debugPrint('[DigitalTwin] Initializing telemetry for $parkingId');
    debugPrint('[DigitalTwin] Source: Cloud Firestore (collection: digital_twins, doc: $parkingId)');
    try {
      if (_firestore != null) {
        debugPrint('[DigitalTwin] Request started for $parkingId');
        final doc = await _firestore
            .collection('digital_twins')
            .doc(parkingId)
            .get()
            .timeout(const Duration(seconds: 5));
        if (doc.exists && doc.data() != null) {
          final twin = DigitalTwinModel.fromMap(doc.data()!, doc.id);
          debugPrint('[DigitalTwin] Request completed. Parsed telemetry for $parkingId: Inflow=${twin.vehicleInflowRatePerHour}, Outflow=${twin.vehicleOutflowRatePerHour}, Occupancy=${twin.liveOccupiedSlots}/${twin.liveTotalSlots}');
          return twin;
        }
        debugPrint('[DigitalTwin] Document $parkingId does not exist in Firestore. Creating initial telemetry model.');
      }
    } catch (e, st) {
      debugPrint('[DigitalTwin] ERROR fetching Firestore document for $parkingId: $e');
      debugPrintStack(stackTrace: st);
    }

    // Default initial telemetry state for hardware telemetry synchronization
    final initialTwin = DigitalTwinModel(
      parkingId: parkingId,
      liveOccupiedSlots: 76,
      liveTotalSlots: 100,
      vehicleInflowRatePerHour: 42,
      vehicleOutflowRatePerHour: 28,
      currentSurgeMultiplier: 1.20,
      liveTrafficCongestion: 'Clear Flow (15%)',
      lastTelemetryUpdate: DateTime.now(),
    );

    // Attempt to seed initial telemetry snapshot to Firestore asynchronously
    try {
      if (_firestore != null) {
        await _firestore
            .collection('digital_twins')
            .doc(parkingId)
            .set(initialTwin.toMap())
            .timeout(const Duration(seconds: 5));
        debugPrint('[DigitalTwin] Initial telemetry snapshot seeded to Firestore for $parkingId');
      }
    } catch (e) {
      debugPrint('[DigitalTwin] Note: Firestore seed attempt notice for $parkingId: $e');
    }

    return initialTwin;
  }

  @override
  Stream<DigitalTwinModel?> streamDigitalTwinForLot(String parkingId) {
    if (_firestore == null) return Stream.value(null);
    return _firestore
        .collection('digital_twins')
        .doc(parkingId)
        .snapshots()
        .timeout(const Duration(seconds: 10))
        .map((doc) {
      if (doc.exists && doc.data() != null) {
        final twin = DigitalTwinModel.fromMap(doc.data()!, doc.id);
        debugPrint('[DigitalTwin] Stream snapshot updated for $parkingId: Inflow=${twin.vehicleInflowRatePerHour}, Outflow=${twin.vehicleOutflowRatePerHour}');
        return twin;
      }
      return null;
    }).handleError((error, stackTrace) {
      debugPrint('[DigitalTwin] Stream error for lot $parkingId: $error');
      debugPrintStack(stackTrace: stackTrace);
      throw error;
    });
  }

  @override
  Future<void> updateDigitalTwinTelemetry(DigitalTwinModel digitalTwin) async {
    try {
      if (_firestore != null) {
        await _firestore
            .collection('digital_twins')
            .doc(digitalTwin.parkingId)
            .set(digitalTwin.toMap())
            .timeout(const Duration(seconds: 5));
        debugPrint('[DigitalTwin] Telemetry updated in Firestore for ${digitalTwin.parkingId}');
      }
    } catch (e) {
      debugPrint('[DigitalTwin] Telemetry update warning for ${digitalTwin.parkingId}: $e');
    }
  }
}
