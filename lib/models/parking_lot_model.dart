import 'dart:convert';
import 'package:equatable/equatable.dart';

/// Clean Architecture model representing a Parking Facility / Lot
class ParkingLotModel extends Equatable {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double distanceInKm;
  final int walkingTimeInMins;
  final int driveTimeInMins;
  final double baseHourlyRate;
  final double currentHourlyRate;
  final bool isPeakHour;
  final double peakSurgeMultiplier;
  final int totalSlots;
  final int availableSlots;
  final double rating;
  final int reviewCount;
  final double securityRating;
  final List<String> imageUrls;
  final double aiMatchScore; // 0 to 100
  final double aiConfidence; // 0 to 100 (%)
  final String aiReasoningSummary;
  final String trafficStatus;
  final double congestionLevel; // 0.0 to 1.0
  final bool isEVChargingAvailable;
  final bool hasCCTV;
  final bool isCovered;
  final List<String> accessibilityFeatures;
  final String operatingHours;
  final List<String> amenities;
  final List<String> availableVehicleTypes;

  const ParkingLotModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distanceInKm,
    required this.walkingTimeInMins,
    required this.driveTimeInMins,
    required this.baseHourlyRate,
    required this.currentHourlyRate,
    required this.isPeakHour,
    required this.peakSurgeMultiplier,
    required this.totalSlots,
    required this.availableSlots,
    required this.rating,
    required this.reviewCount,
    required this.securityRating,
    required this.imageUrls,
    required this.aiMatchScore,
    required this.aiConfidence,
    required this.aiReasoningSummary,
    required this.trafficStatus,
    required this.congestionLevel,
    required this.isEVChargingAvailable,
    required this.hasCCTV,
    required this.isCovered,
    required this.accessibilityFeatures,
    required this.operatingHours,
    required this.amenities,
    required this.availableVehicleTypes,
  });

  ParkingLotModel copyWith({
    String? id,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    double? distanceInKm,
    int? walkingTimeInMins,
    int? driveTimeInMins,
    double? baseHourlyRate,
    double? currentHourlyRate,
    bool? isPeakHour,
    double? peakSurgeMultiplier,
    int? totalSlots,
    int? availableSlots,
    double? rating,
    int? reviewCount,
    double? securityRating,
    List<String>? imageUrls,
    double? aiMatchScore,
    double? aiConfidence,
    String? aiReasoningSummary,
    String? trafficStatus,
    double? congestionLevel,
    bool? isEVChargingAvailable,
    bool? hasCCTV,
    bool? isCovered,
    List<String>? accessibilityFeatures,
    String? operatingHours,
    List<String>? amenities,
    List<String>? availableVehicleTypes,
  }) {
    return ParkingLotModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distanceInKm: distanceInKm ?? this.distanceInKm,
      walkingTimeInMins: walkingTimeInMins ?? this.walkingTimeInMins,
      driveTimeInMins: driveTimeInMins ?? this.driveTimeInMins,
      baseHourlyRate: baseHourlyRate ?? this.baseHourlyRate,
      currentHourlyRate: currentHourlyRate ?? this.currentHourlyRate,
      isPeakHour: isPeakHour ?? this.isPeakHour,
      peakSurgeMultiplier: peakSurgeMultiplier ?? this.peakSurgeMultiplier,
      totalSlots: totalSlots ?? this.totalSlots,
      availableSlots: availableSlots ?? this.availableSlots,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      securityRating: securityRating ?? this.securityRating,
      imageUrls: imageUrls ?? this.imageUrls,
      aiMatchScore: aiMatchScore ?? this.aiMatchScore,
      aiConfidence: aiConfidence ?? this.aiConfidence,
      aiReasoningSummary: aiReasoningSummary ?? this.aiReasoningSummary,
      trafficStatus: trafficStatus ?? this.trafficStatus,
      congestionLevel: congestionLevel ?? this.congestionLevel,
      isEVChargingAvailable: isEVChargingAvailable ?? this.isEVChargingAvailable,
      hasCCTV: hasCCTV ?? this.hasCCTV,
      isCovered: isCovered ?? this.isCovered,
      accessibilityFeatures: accessibilityFeatures ?? this.accessibilityFeatures,
      operatingHours: operatingHours ?? this.operatingHours,
      amenities: amenities ?? this.amenities,
      availableVehicleTypes: availableVehicleTypes ?? this.availableVehicleTypes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'distanceInKm': distanceInKm,
      'walkingTimeInMins': walkingTimeInMins,
      'driveTimeInMins': driveTimeInMins,
      'baseHourlyRate': baseHourlyRate,
      'currentHourlyRate': currentHourlyRate,
      'isPeakHour': isPeakHour,
      'peakSurgeMultiplier': peakSurgeMultiplier,
      'totalSlots': totalSlots,
      'availableSlots': availableSlots,
      'rating': rating,
      'reviewCount': reviewCount,
      'securityRating': securityRating,
      'imageUrls': imageUrls,
      'aiMatchScore': aiMatchScore,
      'aiConfidence': aiConfidence,
      'aiReasoningSummary': aiReasoningSummary,
      'trafficStatus': trafficStatus,
      'congestionLevel': congestionLevel,
      'isEVChargingAvailable': isEVChargingAvailable,
      'hasCCTV': hasCCTV,
      'isCovered': isCovered,
      'accessibilityFeatures': accessibilityFeatures,
      'operatingHours': operatingHours,
      'amenities': amenities,
      'availableVehicleTypes': availableVehicleTypes,
    };
  }

  factory ParkingLotModel.fromMap(Map<String, dynamic> map, String id) {
    return ParkingLotModel(
      id: id,
      name: map['name'] ?? 'Parking Lot',
      address: map['address'] ?? '',
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      distanceInKm: (map['distanceInKm'] ?? 0.0).toDouble(),
      walkingTimeInMins: (map['walkingTimeInMins'] ?? 0).toInt(),
      driveTimeInMins: (map['driveTimeInMins'] ?? 0).toInt(),
      baseHourlyRate: (map['baseHourlyRate'] ?? 50.0).toDouble(),
      currentHourlyRate: (map['currentHourlyRate'] ?? 50.0).toDouble(),
      isPeakHour: map['isPeakHour'] ?? false,
      peakSurgeMultiplier: (map['peakSurgeMultiplier'] ?? 1.0).toDouble(),
      totalSlots: (map['totalSlots'] ?? 100).toInt(),
      availableSlots: (map['availableSlots'] ?? 0).toInt(),
      rating: (map['rating'] ?? 4.5).toDouble(),
      reviewCount: (map['reviewCount'] ?? 0).toInt(),
      securityRating: (map['securityRating'] ?? 4.8).toDouble(),
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      aiMatchScore: (map['aiMatchScore'] ?? 90.0).toDouble(),
      aiConfidence: (map['aiConfidence'] ?? 95.0).toDouble(),
      aiReasoningSummary: map['aiReasoningSummary'] ?? '',
      trafficStatus: map['trafficStatus'] ?? 'Normal Traffic',
      congestionLevel: (map['congestionLevel'] ?? 0.2).toDouble(),
      isEVChargingAvailable: map['isEVChargingAvailable'] ?? false,
      hasCCTV: map['hasCCTV'] ?? true,
      isCovered: map['isCovered'] ?? true,
      accessibilityFeatures: List<String>.from(map['accessibilityFeatures'] ?? []),
      operatingHours: map['operatingHours'] ?? '24/7 Open',
      amenities: List<String>.from(map['amenities'] ?? []),
      availableVehicleTypes: List<String>.from(map['availableVehicleTypes'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory ParkingLotModel.fromJson(String source, String id) =>
      ParkingLotModel.fromMap(json.decode(source), id);

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        latitude,
        longitude,
        distanceInKm,
        walkingTimeInMins,
        driveTimeInMins,
        baseHourlyRate,
        currentHourlyRate,
        isPeakHour,
        peakSurgeMultiplier,
        totalSlots,
        availableSlots,
        rating,
        reviewCount,
        securityRating,
        imageUrls,
        aiMatchScore,
        aiConfidence,
        aiReasoningSummary,
        trafficStatus,
        congestionLevel,
        isEVChargingAvailable,
        hasCCTV,
        isCovered,
        accessibilityFeatures,
        operatingHours,
        amenities,
        availableVehicleTypes,
      ];
}
