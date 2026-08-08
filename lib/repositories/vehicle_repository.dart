import '../models/vehicle_model.dart';

abstract class IVehicleRepository {
  Future<List<VehicleModel>> getUserVehicles(String userId);
  Future<void> addVehicle(String userId, VehicleModel vehicle);
  Future<void> deleteVehicle(String userId, String vehicleId);
}
