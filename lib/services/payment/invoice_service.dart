import '../../models/payment_transaction_model.dart';
import '../../models/reservation_model.dart';

/// Digital Receipt & Invoice Generator for SmartPark AI
class InvoiceService {
  String generateInvoiceText(PaymentTransactionModel tx, ReservationModel reservation) {
    final buffer = StringBuffer();
    buffer.writeln('========================================');
    buffer.writeln('          SMARTPARK AI INVOICE          ');
    buffer.writeln('========================================');
    buffer.writeln('Transaction ID : ${tx.transactionId}');
    buffer.writeln('Reservation ID : ${tx.reservationId}');
    buffer.writeln('Date & Time    : ${tx.timestamp}');
    buffer.writeln('Payment Method : ${tx.paymentMethod}');
    buffer.writeln('Status         : ${tx.status}');
    buffer.writeln('----------------------------------------');
    buffer.writeln('Facility       : ${reservation.parkingName}');
    buffer.writeln('Address        : ${reservation.parkingAddress}');
    buffer.writeln('Slot Allocated : ${reservation.allocatedSlot}');
    buffer.writeln('Vehicle        : ${reservation.vehicleNumber} (${reservation.vehicleType})');
    buffer.writeln('----------------------------------------');
    buffer.writeln('Base Fee       : ₹${reservation.baseRatePerHour * reservation.durationInHours}');
    buffer.writeln('Surge Fee      : ₹${reservation.surgeFee}');
    buffer.writeln('Service Fee    : ₹${reservation.serviceFee}');
    buffer.writeln('TOTAL PAID     : ₹${tx.amount}');
    buffer.writeln('========================================');
    buffer.writeln('Thank you for choosing SmartPark AI!');
    return buffer.toString();
  }
}
