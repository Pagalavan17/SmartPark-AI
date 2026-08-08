import '../../../models/reservation_model.dart';

abstract class IReservationRepository {
  Future<ReservationModel> createReservation(ReservationModel reservation);
  Future<List<ReservationModel>> getUserReservations();
  Future<ReservationModel?> getReservationById(String id);
  Future<void> cancelReservation(String id);
}
