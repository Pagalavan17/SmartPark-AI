import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehicle_model.dart';
import 'vehicle_repository.dart';

class FirebaseVehicleRepository implements IVehicleRepository {
  final FirebaseFirestore? _firestore;
  final List<VehicleModel> _fallback = const [
    // CAR (6)
    VehicleModel(id: 'car_001', registrationNumber: 'TN 07 CK 5555', modelName: 'Honda City', type: 'Car', isDefault: true),
    VehicleModel(id: 'car_002', registrationNumber: 'TN 22 AB 4521', modelName: 'Hyundai i20', type: 'Car'),
    VehicleModel(id: 'car_003', registrationNumber: 'TN 01 CQ 7823', modelName: 'Maruti Suzuki Swift', type: 'Car'),
    VehicleModel(id: 'car_004', registrationNumber: 'TN 09 BH 3210', modelName: 'Tata Altroz', type: 'Car'),
    VehicleModel(id: 'car_005', registrationNumber: 'TN 10 DE 6742', modelName: 'Volkswagen Virtus', type: 'Car'),
    VehicleModel(id: 'car_006', registrationNumber: 'TN 18 FG 9087', modelName: 'Toyota Glanza', type: 'Car'),

    // BIKE (6)
    VehicleModel(id: 'bike_001', registrationNumber: 'TN 05 RE 8888', modelName: 'Royal Enfield Classic 350', type: 'Bike'),
    VehicleModel(id: 'bike_002', registrationNumber: 'TN 11 YM 4522', modelName: 'Yamaha MT-15', type: 'Bike'),
    VehicleModel(id: 'bike_003', registrationNumber: 'TN 14 AC 6731', modelName: 'Honda Activa 6G', type: 'Bike'),
    VehicleModel(id: 'bike_004', registrationNumber: 'TN 22 AP 3819', modelName: 'TVS Apache RTR 160', type: 'Bike'),
    VehicleModel(id: 'bike_005', registrationNumber: 'TN 09 BP 7294', modelName: 'Bajaj Pulsar NS200', type: 'Bike'),
    VehicleModel(id: 'bike_006', registrationNumber: 'TN 01 KT 5566', modelName: 'KTM Duke 200', type: 'Bike'),

    // SUV (6)
    VehicleModel(id: 'suv_001', registrationNumber: 'TN 01 AB 1234', modelName: 'Hyundai Creta', type: 'SUV'),
    VehicleModel(id: 'suv_002', registrationNumber: 'TN 22 KS 4567', modelName: 'Kia Seltos', type: 'SUV'),
    VehicleModel(id: 'suv_003', registrationNumber: 'TN 09 NX 2345', modelName: 'Tata Nexon', type: 'SUV'),
    VehicleModel(id: 'suv_004', registrationNumber: 'TN 10 MX 6789', modelName: 'Mahindra XUV700', type: 'SUV'),
    VehicleModel(id: 'suv_005', registrationNumber: 'TN 18 UH 3456', modelName: 'Toyota Urban Cruiser Hyryder', type: 'SUV'),
    VehicleModel(id: 'suv_006', registrationNumber: 'TN 07 MH 7890', modelName: 'MG Hector', type: 'SUV'),

    // EV (6)
    VehicleModel(id: 'ev_001', registrationNumber: 'TN 09 EV 9999', modelName: 'Tata Nexon EV', type: 'EV'),
    VehicleModel(id: 'ev_002', registrationNumber: 'TN 01 TE 4321', modelName: 'Tata Tiago EV', type: 'EV'),
    VehicleModel(id: 'ev_003', registrationNumber: 'TN 22 CE 7654', modelName: 'MG Comet EV', type: 'EV'),
    VehicleModel(id: 'ev_004', registrationNumber: 'TN 10 HI 2468', modelName: 'Hyundai Ioniq 5', type: 'EV'),
    VehicleModel(id: 'ev_005', registrationNumber: 'TN 18 BA 1357', modelName: 'BYD Atto 3', type: 'EV'),
    VehicleModel(id: 'ev_006', registrationNumber: 'TN 07 XE 8642', modelName: 'Mahindra XUV400 EV', type: 'EV'),
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
