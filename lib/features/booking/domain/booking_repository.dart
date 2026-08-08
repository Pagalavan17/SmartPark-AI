import '../../../models/booking_model.dart';

abstract class IBookingRepository {
  Future<BookingModel> createBooking({
    required String spotId,
    required String slotNumber,
    required DateTime startTime,
    required DateTime endTime,
    required double totalAmount,
  });
  Future<BookingModel?> getBookingById(String bookingId);
}
