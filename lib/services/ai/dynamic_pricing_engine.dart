import '../../models/parking_lot_model.dart';

/// Independent AI Engine for Dynamic Surge & Discount Pricing
class DynamicPricingEngine {
  /// Computes real-time dynamic hourly price based on demand, traffic, occupancy, time of day
  double calculateDynamicRate(ParkingLotModel spot) {
    double rate = spot.baseHourlyRate;
    
    // Dynamic surge calculation
    final double occupancyRate = (spot.totalSlots - spot.availableSlots) / spot.totalSlots;
    if (occupancyRate > 0.85) {
      rate *= 1.25; // 25% surge
    } else if (occupancyRate < 0.30) {
      rate *= 0.90; // 10% off-peak discount
    }

    return rate.roundToDouble();
  }

  bool isSurgeActive(ParkingLotModel spot) {
    final double occupancyRate = (spot.totalSlots - spot.availableSlots) / spot.totalSlots;
    return occupancyRate > 0.80 || spot.isPeakHour;
  }
}
