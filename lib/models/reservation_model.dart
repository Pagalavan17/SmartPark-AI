import 'package:equatable/equatable.dart';

/// Clean Architecture model representing a parking spot reservation
class ReservationModel extends Equatable {
  final String reservationId;
  final String parkingId;
  final String parkingName;
  final String parkingAddress;
  final String allocatedSlot;
  final DateTime arrivalTime;
  final int durationInHours;
  final String vehicleType;
  final String vehicleNumber;
  final double baseRatePerHour;
  final double surgeFee;
  final double serviceFee;
  final double totalAmount;
  final String qrCodeToken;
  final String status; // "Active", "Completed", "Cancelled", "Adaptive Reassigned"
  final DateTime createdAt;

  const ReservationModel({
    required this.reservationId,
    required this.parkingId,
    required this.parkingName,
    required this.parkingAddress,
    required this.allocatedSlot,
    required this.arrivalTime,
    required this.durationInHours,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.baseRatePerHour,
    required this.surgeFee,
    required this.serviceFee,
    required this.totalAmount,
    required this.qrCodeToken,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'reservationId': reservationId,
      'parkingId': parkingId,
      'parkingName': parkingName,
      'parkingAddress': parkingAddress,
      'allocatedSlot': allocatedSlot,
      'arrivalTime': arrivalTime.toIso8601String(),
      'durationInHours': durationInHours,
      'vehicleType': vehicleType,
      'vehicleNumber': vehicleNumber,
      'baseRatePerHour': baseRatePerHour,
      'surgeFee': surgeFee,
      'serviceFee': serviceFee,
      'totalAmount': totalAmount,
      'qrCodeToken': qrCodeToken,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ReservationModel.fromMap(Map<String, dynamic> map, String id) {
    return ReservationModel(
      reservationId: id,
      parkingId: map['parkingId'] ?? '',
      parkingName: map['parkingName'] ?? 'Smart Parking Spot',
      parkingAddress: map['parkingAddress'] ?? '',
      allocatedSlot: map['allocatedSlot'] ?? 'Slot A-01',
      arrivalTime: DateTime.tryParse(map['arrivalTime'] ?? '') ?? DateTime.now(),
      durationInHours: (map['durationInHours'] ?? 2).toInt(),
      vehicleType: map['vehicleType'] ?? 'Car',
      vehicleNumber: map['vehicleNumber'] ?? 'TN 01 AB 1234',
      baseRatePerHour: (map['baseRatePerHour'] ?? 50.0).toDouble(),
      surgeFee: (map['surgeFee'] ?? 0.0).toDouble(),
      serviceFee: (map['serviceFee'] ?? 15.0).toDouble(),
      totalAmount: (map['totalAmount'] ?? 115.0).toDouble(),
      qrCodeToken: map['qrCodeToken'] ?? 'SMARTPARK_PASS_$id',
      status: map['status'] ?? 'Active',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        reservationId,
        parkingId,
        parkingName,
        parkingAddress,
        allocatedSlot,
        arrivalTime,
        durationInHours,
        vehicleType,
        vehicleNumber,
        baseRatePerHour,
        surgeFee,
        serviceFee,
        totalAmount,
        qrCodeToken,
        status,
        createdAt,
      ];
}
