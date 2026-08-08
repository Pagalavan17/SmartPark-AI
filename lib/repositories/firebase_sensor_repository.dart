import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sensor_data_model.dart';
import 'sensor_repository.dart';

class FirebaseSensorRepository implements ISensorRepository {
  final FirebaseFirestore? _firestore;
  final List<SensorDataModel> _fallbackEvents = [];

  FirebaseSensorRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> recordSensorEvent(SensorDataModel event) async {
    try {
      if (_firestore != null) {
        await _firestore
            .collection('sensor_events')
            .doc(event.sensorId)
            .set(event.toMap());
      }
    } catch (_) {}
    _fallbackEvents.insert(0, event);
  }

  @override
  Future<List<SensorDataModel>> getRecentSensorEvents(String parkingId) async {
    try {
      if (_firestore != null) {
        final snapshot = await _firestore
            .collection('sensor_events')
            .where('parkingId', isEqualTo: parkingId)
            .limit(20)
            .get();
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs
              .map((doc) => SensorDataModel.fromMap(doc.data(), doc.id))
              .toList();
        }
      }
    } catch (_) {}
    return _fallbackEvents.where((e) => e.parkingId == parkingId).toList();
  }

  @override
  Stream<List<SensorDataModel>> streamSensorEvents(String parkingId) {
    if (_firestore == null) return Stream.value(_fallbackEvents);
    return _firestore
        .collection('sensor_events')
        .where('parkingId', isEqualTo: parkingId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SensorDataModel.fromMap(doc.data(), doc.id))
            .toList());
  }
}
