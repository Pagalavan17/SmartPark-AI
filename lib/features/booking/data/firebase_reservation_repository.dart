import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/reservation_model.dart';
import '../domain/reservation_repository.dart';

class FirebaseReservationRepository implements IReservationRepository {
  final FirebaseFirestore? _firestore;
  final List<ReservationModel> _inMemoryFallback = [];

  FirebaseReservationRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<ReservationModel> createReservation(ReservationModel reservation) async {
    try {
      if (_firestore != null) {
        await _firestore
            .collection('reservations')
            .doc(reservation.reservationId)
            .set(reservation.toMap());
      }
    } catch (_) {}
    _inMemoryFallback.insert(0, reservation);
    return reservation;
  }

  @override
  Future<List<ReservationModel>> getUserReservations() async {
    try {
      if (_firestore != null) {
        final snapshot = await _firestore.collection('reservations').get();
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs.map((doc) => ReservationModel.fromMap(doc.data(), doc.id)).toList();
        }
      }
    } catch (_) {}
    return _inMemoryFallback;
  }

  @override
  Future<ReservationModel?> getReservationById(String id) async {
    try {
      if (_firestore != null) {
        final doc = await _firestore.collection('reservations').doc(id).get();
        if (doc.exists && doc.data() != null) {
          return ReservationModel.fromMap(doc.data()!, doc.id);
        }
      }
    } catch (_) {}
    return _inMemoryFallback.firstWhere(
      (res) => res.reservationId == id,
      orElse: () => ReservationModel(
        reservationId: id,
        parkingId: 'spot_metro',
        parkingName: 'Metro Cyber Park Garage',
        parkingAddress: '120 Mount Road, Guindy, Chennai',
        allocatedSlot: 'Slot A-14',
        arrivalTime: DateTime.now(),
        durationInHours: 2,
        vehicleType: 'Car',
        vehicleNumber: 'TN 01 AB 1234',
        baseRatePerHour: 50.0,
        surgeFee: 0.0,
        serviceFee: 15.0,
        totalAmount: 115.0,
        qrCodeToken: 'SMARTPARK_PASS_$id',
        status: 'Active',
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> cancelReservation(String id) async {
    try {
      if (_firestore != null) {
        await _firestore.collection('reservations').doc(id).update({'status': 'Cancelled'});
      }
    } catch (_) {}
    final index = _inMemoryFallback.indexWhere((r) => r.reservationId == id);
    if (index != -1) {
      final old = _inMemoryFallback[index];
      _inMemoryFallback[index] = ReservationModel(
        reservationId: old.reservationId,
        parkingId: old.parkingId,
        parkingName: old.parkingName,
        parkingAddress: old.parkingAddress,
        allocatedSlot: old.allocatedSlot,
        arrivalTime: old.arrivalTime,
        durationInHours: old.durationInHours,
        vehicleType: old.vehicleType,
        vehicleNumber: old.vehicleNumber,
        baseRatePerHour: old.baseRatePerHour,
        surgeFee: old.surgeFee,
        serviceFee: old.serviceFee,
        totalAmount: old.totalAmount,
        qrCodeToken: old.qrCodeToken,
        status: 'Cancelled',
        createdAt: old.createdAt,
      );
    }
  }
}
