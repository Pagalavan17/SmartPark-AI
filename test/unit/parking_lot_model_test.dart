import 'package:flutter_test/flutter_test.dart';
import 'package:smartpark_ai/models/parking_lot_model.dart';

void main() {
  group('ParkingLotModel.fromMap', () {
    test('parses cit_main_gate Firestore data correctly', () {
      final firestoreData = {
        'name': 'CIT Main Gate Parking',
        'address': 'Chennai Institute of Technology',
        'latitude': 12.9715,
        'longitude': 80.0434,
        'distanceInKm': 0.5,
        'walkingTimeInMins': 6,
        'driveTimeInMins': 2,
        'baseHourlyRate': 40.0,
        'currentHourlyRate': 40.0,
        'isPeakHour': false,
        'peakSurgeMultiplier': 1.0,
        'totalSlots': 100,
        'availableSlots': 72,
        'rating': 4.5,
        'reviewCount': 0,
        'securityRating': 4.8,
        'imageUrls': <dynamic>[],
        'aiMatchScore': 90.0,
        'aiConfidence': 95.0,
        'aiReasoningSummary':
            'Highly suitable parking location with good availability.',
        'trafficStatus': 'Normal Traffic',
        'congestionLevel': 0.2,
        'isEVChargingAvailable': true,
        'hasCCTV': true,
        'isCovered': true,
        'accessibilityFeatures': <dynamic>[
          'Wheelchair Accessible',
          'Elevator Access'
        ],
      };

      final lot = ParkingLotModel.fromMap(firestoreData, 'cit_main_gate');

      expect(lot.id, equals('cit_main_gate'));
      expect(lot.name, equals('CIT Main Gate Parking'));
      expect(lot.latitude, equals(12.9715));
      expect(lot.longitude, equals(80.0434));
      expect(lot.availableSlots, equals(72));
      expect(lot.totalSlots, equals(100));
      expect(lot.baseHourlyRate, equals(40.0));
      expect(lot.currentHourlyRate, equals(40.0));
      expect(lot.aiMatchScore, equals(90.0));
      expect(lot.distanceInKm, equals(0.5));
      expect(lot.rating, equals(4.5));
      expect(lot.isEVChargingAvailable, equals(true));
      expect(lot.isCovered, equals(true));
      expect(lot.hasCCTV, equals(true));
    });

    test('handles missing or null fields gracefully without crashing', () {
      final minimalMap = <String, dynamic>{
        'name': 'Minimal Lot',
      };

      final lot = ParkingLotModel.fromMap(minimalMap, 'min_lot');
      expect(lot.id, equals('min_lot'));
      expect(lot.name, equals('Minimal Lot'));
      expect(lot.availableSlots, equals(0));
      expect(lot.totalSlots, equals(0));
    });

    test('handles integer numbers for double fields', () {
      final intMap = <String, dynamic>{
        'name': 'Int Lot',
        'baseHourlyRate': 40,
        'currentHourlyRate': 40,
        'totalSlots': 100,
        'availableSlots': 72,
        'rating': 4,
        'securityRating': 5,
        'aiMatchScore': 90,
        'aiConfidence': 95,
        'congestionLevel': 0,
      };

      final lot = ParkingLotModel.fromMap(intMap, 'int_lot');
      expect(lot.baseHourlyRate, equals(40.0));
      expect(lot.rating, equals(4.0));
    });
  });
}
