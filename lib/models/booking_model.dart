import 'package:equatable/equatable.dart';

class BookingModel extends Equatable {
  final String bookingId;
  final String parkingSpotId;
  final String parkingSpotName;
  final String slotNumber;
  final DateTime startTime;
  final DateTime endTime;
  final double totalAmount;
  final String qrToken;
  final String status; // active, completed, cancelled

  const BookingModel({
    required this.bookingId,
    required this.parkingSpotId,
    required this.parkingSpotName,
    required this.slotNumber,
    required this.startTime,
    required this.endTime,
    required this.totalAmount,
    required this.qrToken,
    required this.status,
  });

  @override
  List<Object?> get props => [
        bookingId,
        parkingSpotId,
        parkingSpotName,
        slotNumber,
        startTime,
        endTime,
        totalAmount,
        qrToken,
        status,
      ];
}
