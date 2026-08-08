import '../../models/parking_lot_model.dart';

/// Independent Explainable AI Service generating natural language reasons for recommendations
class ExplainableAIService {
  List<String> generateExplanationBullets(ParkingLotModel spot) {
    final List<String> bullets = [];

    if (spot.congestionLevel < 0.3) {
      bullets.add('Lowest predicted route traffic');
    } else {
      bullets.add('Moderate traffic flow via direct route');
    }

    if (spot.availableSlots > 0) {
      bullets.add('${spot.availableSlots} parking spaces expected to remain available');
    }

    if (spot.walkingTimeInMins <= 5) {
      bullets.add('Walking distance only ${(spot.distanceInKm * 1000).toInt()} meters');
    }

    if (spot.baseHourlyRate <= 50.0) {
      bullets.add('Competitive parking price (₹${spot.baseHourlyRate.toInt()}/hr)');
    }

    if (spot.isEVChargingAvailable) {
      bullets.add('EV fast-charging station available on site');
    }

    if (spot.isCovered) {
      bullets.add('Covered multi-level weather protected deck');
    }

    if (spot.hasCCTV) {
      bullets.add('24/7 AI CCTV & guard security monitored');
    }

    return bullets;
  }
}
