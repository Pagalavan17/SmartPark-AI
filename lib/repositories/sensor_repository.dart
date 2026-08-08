import '../models/sensor_data_model.dart';

abstract class ISensorRepository {
  Future<void> recordSensorEvent(SensorDataModel event);
  Future<List<SensorDataModel>> getRecentSensorEvents(String parkingId);
  Stream<List<SensorDataModel>> streamSensorEvents(String parkingId);
}
