import '../../models/reservation_model.dart';
import '../../models/parking_lot_model.dart';

/// Independent AI Engine for Adaptive Reservation re-routing & auto-reassignment
class AdaptiveReservationEngine {
  /// Evaluates an active reservation. If the facility becomes overcrowded or unavailable,
  /// automatically finds a better alternative parking lot, updates reservation,
  /// generates new QR pass token, and returns the modified reservation.
  ReservationModel checkAndReassignIfNeeded({
    required ReservationModel currentReservation,
    required List<ParkingLotModel> availableLots,
  }) {
    // If status is already completed/cancelled, return as is
    if (currentReservation.status != 'Active') return currentReservation;

    // Check if target parking lot is full (0 available)
    final targetLot = availableLots.firstWhere(
      (lot) => lot.id == currentReservation.parkingId,
      orElse: () => availableLots.first,
    );

    if (targetLot.availableSlots == 0) {
      // Find best fallback lot with available slots
      final alternativeLot = availableLots.firstWhere(
        (lot) => lot.availableSlots > 5,
        orElse: () => availableLots.first,
      );

      return ReservationModel(
        reservationId: currentReservation.reservationId,
        parkingId: alternativeLot.id,
        parkingName: alternativeLot.name,
        parkingAddress: alternativeLot.address,
        allocatedSlot: 'Slot B-08 (Auto-Reassigned)',
        arrivalTime: currentReservation.arrivalTime,
        durationInHours: currentReservation.durationInHours,
        vehicleType: currentReservation.vehicleType,
        vehicleNumber: currentReservation.vehicleNumber,
        baseRatePerHour: alternativeLot.baseHourlyRate,
        surgeFee: currentReservation.surgeFee,
        serviceFee: currentReservation.serviceFee,
        totalAmount: currentReservation.totalAmount,
        qrCodeToken: 'ADAPTIVE_SMARTPARK_PASS_${alternativeLot.id}_${DateTime.now().millisecondsSinceEpoch}',
        status: 'Adaptive Reassigned',
        createdAt: currentReservation.createdAt,
      );
    }

    return currentReservation;
  }
}
