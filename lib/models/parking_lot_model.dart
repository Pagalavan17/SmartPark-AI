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

  static dynamic _getValue(Map<String, dynamic> map, List<String> possibleKeys) {
    for (final key in possibleKeys) {
      if (map.containsKey(key) && map[key] != null) {
        return map[key];
      }
    }
    final mapLower = {
      for (var entry in map.entries) entry.key.toString().trim().toLowerCase(): entry.value
    };
    for (final key in possibleKeys) {
      final keyLower = key.trim().toLowerCase();
      if (mapLower.containsKey(keyLower) && mapLower[keyLower] != null) {
        return mapLower[keyLower];
      }
    }
    return null;
  }

  static double _toDouble(dynamic val, [double defaultValue = 0.0]) {
    if (val == null) return defaultValue;
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val) ?? defaultValue;
    return defaultValue;
  }

  static int _toInt(dynamic val, [int defaultValue = 0]) {
    if (val == null) return defaultValue;
    if (val is num) return val.toInt();
    if (val is String) return int.tryParse(val) ?? defaultValue;
    return defaultValue;
  }

  static bool _toBool(dynamic val, [bool defaultValue = false]) {
    if (val == null) return defaultValue;
    if (val is bool) return val;
    if (val is String) return val.toLowerCase() == 'true';
    if (val is num) return val != 0;
    return defaultValue;
  }

  static List<String> _toListOfStrings(dynamic val) {
    if (val == null) return [];
    if (val is List) return val.map((e) => e.toString()).toList();
    return [];
  }

  factory ParkingLotModel.fromMap(Map<String, dynamic> map, String id) {
    final nameVal = _getValue(map, ['name', 'title', 'parkingName']);
    final addressVal = _getValue(map, ['address', 'location', 'parkingAddress']);
    final latVal = _getValue(map, ['latitude', 'lat']);
    final lngVal = _getValue(map, ['longitude', 'lng', 'long']);
    final distVal = _getValue(map, ['distanceInKm', 'distance_in_km', 'distance', 'distanceKm']);
    final walkVal = _getValue(map, ['walkingTimeInMins', 'walking_time_in_mins', 'walkingTime', 'walking_time']);
    final driveVal = _getValue(map, ['driveTimeInMins', 'drive_time_in_mins', 'driveTime', 'drive_time']);
    final baseRateVal = _getValue(map, ['baseHourlyRate', 'base_hourly_rate', 'hourlyRate', 'hourly_rate', 'currentHourlyRate', 'pricePerHour', 'price']);
    final currentRateVal = _getValue(map, ['currentHourlyRate', 'current_hourly_rate', 'baseHourlyRate', 'base_hourly_rate', 'hourlyRate', 'hourly_rate', 'pricePerHour', 'price']);
    final peakVal = _getValue(map, ['isPeakHour', 'is_peak_hour', 'peakHour']);
    final peakMultVal = _getValue(map, ['peakSurgeMultiplier', 'peak_surge_multiplier', 'surgeMultiplier']);
    final totalSlotsVal = _getValue(map, ['totalSlots', 'total_slots', 'totalSpots', 'total_spots', 'total', 'capacity']);
    final availSlotsVal = _getValue(map, ['availableSlots', 'available_slots', 'availableSpots', 'available_spots', 'available', 'slots_available']);
    final ratingVal = _getValue(map, ['rating', 'stars', 'rate']);
    final reviewCountVal = _getValue(map, ['reviewCount', 'review_count', 'reviews']);
    final securityRatingVal = _getValue(map, ['securityRating', 'security_rating']);
    final imageUrlsVal = _getValue(map, ['imageUrls', 'image_urls', 'images']);
    final aiScoreVal = _getValue(map, ['aiMatchScore', 'ai_match_score', 'aiScore', 'matchScore']);
    final aiConfVal = _getValue(map, ['aiConfidence', 'ai_confidence']);
    final aiSummaryVal = _getValue(map, ['aiReasoningSummary', 'ai_reasoning_summary', 'aiReasoning', 'aiSummary']);
    final trafficVal = _getValue(map, ['trafficStatus', 'traffic_status', 'traffic']);
    final congestionVal = _getValue(map, ['congestionLevel', 'congestion_level', 'congestion']);
    final evVal = _getValue(map, ['isEVChargingAvailable', 'is_ev_charging_available', 'isEVCharging', 'evCharging', 'ev_charging', 'ev']);
    final cctvVal = _getValue(map, ['hasCCTV', 'has_cctv', 'cctv']);
    final coveredVal = _getValue(map, ['isCovered', 'is_covered', 'covered']);
    final accessVal = _getValue(map, ['accessibilityFeatures', 'accessibility_features', 'accessibility']);
    final hoursVal = _getValue(map, ['operatingHours', 'operating_hours', 'hours']);
    final amenitiesVal = _getValue(map, ['amenities', 'features']);
    final vehiclesVal = _getValue(map, ['availableVehicleTypes', 'available_vehicle_types', 'vehicleTypes']);

    return ParkingLotModel(
      id: id,
      name: (nameVal as String?) ?? 'Parking Lot',
      address: (addressVal as String?) ?? '',
      latitude: _toDouble(latVal),
      longitude: _toDouble(lngVal),
      distanceInKm: _toDouble(distVal),
      walkingTimeInMins: _toInt(walkVal),
      driveTimeInMins: _toInt(driveVal),
      baseHourlyRate: _toDouble(baseRateVal),
      currentHourlyRate: _toDouble(currentRateVal),
      isPeakHour: _toBool(peakVal),
      peakSurgeMultiplier: _toDouble(peakMultVal, 1.0),
      totalSlots: _toInt(totalSlotsVal),
      availableSlots: _toInt(availSlotsVal),
      rating: _toDouble(ratingVal),
      reviewCount: _toInt(reviewCountVal),
      securityRating: _toDouble(securityRatingVal, 4.8),
      imageUrls: _toListOfStrings(imageUrlsVal),
      aiMatchScore: _toDouble(aiScoreVal, 90.0),
      aiConfidence: _toDouble(aiConfVal, 95.0),
      aiReasoningSummary: (aiSummaryVal as String?) ??
          'Highly suitable parking location with good availability.',
      trafficStatus: (trafficVal as String?) ?? 'Normal Traffic',
      congestionLevel: _toDouble(congestionVal),
      isEVChargingAvailable: _toBool(evVal),
      hasCCTV: _toBool(cctvVal),
      isCovered: _toBool(coveredVal),
      accessibilityFeatures: _toListOfStrings(accessVal),
      operatingHours: (hoursVal as String?) ?? '24/7 Open',
      amenities: _toListOfStrings(amenitiesVal),
      availableVehicleTypes: _toListOfStrings(vehiclesVal),
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
