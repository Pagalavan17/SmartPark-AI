import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/digital_twin_model.dart';
import 'digital_twin_repository.dart';

class FirebaseDigitalTwinRepository implements IDigitalTwinRepository {
  final FirebaseFirestore? _firestore;

  FirebaseDigitalTwinRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<DigitalTwinModel?> getDigitalTwinForLot(String parkingId) async {
    try {
      if (_firestore != null) {
        final doc = await _firestore.collection('digital_twins').doc(parkingId).get();
        if (doc.exists && doc.data() != null) {
          return DigitalTwinModel.fromMap(doc.data()!, doc.id);
        }
      }
    } catch (_) {}
    return DigitalTwinModel(
      parkingId: parkingId,
      liveOccupiedSlots: 76,
      liveTotalSlots: 100,
      vehicleInflowRatePerHour: 42,
      vehicleOutflowRatePerHour: 28,
      currentSurgeMultiplier: 1.20,
      liveTrafficCongestion: 'Clear Flow (15%)',
      lastTelemetryUpdate: DateTime.now(),
    );
  }

  @override
  Stream<DigitalTwinModel?> streamDigitalTwinForLot(String parkingId) {
    if (_firestore == null) return Stream.value(null);
    return _firestore.collection('digital_twins').doc(parkingId).snapshots().map((doc) {
      if (doc.exists && doc.data() != null) {
        return DigitalTwinModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    });
  }

  @override
  Future<void> updateDigitalTwinTelemetry(DigitalTwinModel digitalTwin) async {
    try {
      if (_firestore != null) {
        await _firestore
            .collection('digital_twins')
            .doc(digitalTwin.parkingId)
            .set(digitalTwin.toMap());
      }
    } catch (_) {}
  }
}
