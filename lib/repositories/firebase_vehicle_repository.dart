import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehicle_model.dart';
import 'vehicle_repository.dart';

class FirebaseVehicleRepository implements IVehicleRepository {
  final FirebaseFirestore? _firestore;
  final List<VehicleModel> _fallback = const [
    VehicleModel(id: 'v_1', registrationNumber: 'TN 01 AB 1234', modelName: 'Hyundai Creta', type: 'SUV', isDefault: true),
    VehicleModel(id: 'v_2', registrationNumber: 'TN 09 EV 9999', modelName: 'Tata Nexon EV', type: 'EV', isDefault: false),
  ];

  FirebaseVehicleRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<VehicleModel>> getUserVehicles(String userId) async {
    try {
      if (_firestore != null) {
        final snapshot = await _firestore.collection('vehicles').where('userId', isEqualTo: userId).get();
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs.map((doc) => VehicleModel.fromMap(doc.data(), doc.id)).toList();
        }
      }
    } catch (_) {}
    return _fallback;
  }

  @override
  Future<void> addVehicle(String userId, VehicleModel vehicle) async {
    try {
      if (_firestore != null) {
        await _firestore.collection('vehicles').doc(vehicle.id).set({
          ...vehicle.toMap(),
          'userId': userId,
        });
      }
    } catch (_) {}
  }

  @override
  Future<void> deleteVehicle(String userId, String vehicleId) async {
    try {
      if (_firestore != null) {
        await _firestore.collection('vehicles').doc(vehicleId).delete();
      }
    } catch (_) {}
  }
}
