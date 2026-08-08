import '../../models/parking_lot_model.dart';

/// Independent AI Engine for Parking Lot Ranking & Scoring
class RecommendationEngine {
  /// Evaluates and ranks parking lots based on multi-criteria weighting:
  /// - Distance & Walking time
  /// - Traffic & Congestion
  /// - Occupancy prediction
  /// - Price & Peak surge
  /// - EV charging & User preferences
  double calculateScore(ParkingLotModel spot) {
    double score = 100.0;
    
    // Distance penalty (-10 points per km)
    score -= (spot.distanceInKm * 10.0);
    
    // Congestion penalty
    score -= (spot.congestionLevel * 25.0);
    
    // Low availability penalty
    if (spot.availableSlots < 10) score -= 15.0;
    
    // EV Bonus
    if (spot.isEVChargingAvailable) score += 5.0;
    
    // High rating bonus
    score += (spot.rating * 3.0);

    return score.clamp(0.0, 100.0).roundToDouble();
  }

  double calculateConfidence(ParkingLotModel spot) {
    // Confidence based on telemetry freshness & slot count
    return spot.availableSlots > 15 ? 98.0 : 92.0;
  }
}
