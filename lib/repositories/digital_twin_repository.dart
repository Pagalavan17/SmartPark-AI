import '../models/digital_twin_model.dart';

abstract class IDigitalTwinRepository {
  Future<DigitalTwinModel?> getDigitalTwinForLot(String parkingId);
  Stream<DigitalTwinModel?> streamDigitalTwinForLot(String parkingId);
  Future<void> updateDigitalTwinTelemetry(DigitalTwinModel digitalTwin);
}
