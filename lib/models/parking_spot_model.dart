import 'package:equatable/equatable.dart';

class ParkingSpotModel extends Equatable {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double hourlyRate;
  final int totalSlots;
  final int availableSlots;
  final double rating;
  final String imageUrl;
  final bool isEVChargingAvailable;
  final double aiMatchScore;

  const ParkingSpotModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.hourlyRate,
    required this.totalSlots,
    required this.availableSlots,
    required this.rating,
    required this.imageUrl,
    required this.isEVChargingAvailable,
    required this.aiMatchScore,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        latitude,
        longitude,
        hourlyRate,
        totalSlots,
        availableSlots,
        rating,
        imageUrl,
        isEVChargingAvailable,
        aiMatchScore,
      ];
}
