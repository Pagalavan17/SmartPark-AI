import '../../../models/booking_model.dart';

abstract class IHistoryRepository {
  Future<List<BookingModel>> getUserBookingHistory(String userId);
}
