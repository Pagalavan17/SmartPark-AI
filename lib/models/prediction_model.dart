import 'package:equatable/equatable.dart';

/// Model representing multi-horizon AI prediction analytics for a parking facility
class PredictionModel extends Equatable {
  final String parkingId;
  final double currentOccupancyPercentage;
  final double predictedOccupancy15Min;
  final double predictedOccupancy30Min;
  final double predictedOccupancy1Hour;
  final double predictedOccupancy2Hours;
  final String bestArrivalTime;
  final int predictedWaitingTimeMins;
  final String trafficTrend; // "Increasing", "Decreasing", "Stable"
  final String demandTrend; // "High Demand 🔥", "Moderate Demand", "Low Demand"
  final String dynamicPricingTrend; // "Price rising in 30m", "Stable", "Off-peak discount"
  final List<double> hourlyOccupancyTrend; // Data points for visual charts (12-24 hours)

  const PredictionModel({
    required this.parkingId,
    required this.currentOccupancyPercentage,
    required this.predictedOccupancy15Min,
    required this.predictedOccupancy30Min,
    required this.predictedOccupancy1Hour,
    required this.predictedOccupancy2Hours,
    required this.bestArrivalTime,
    required this.predictedWaitingTimeMins,
    required this.trafficTrend,
    required this.demandTrend,
    required this.dynamicPricingTrend,
    required this.hourlyOccupancyTrend,
  });

  Map<String, dynamic> toMap() {
    return {
      'parkingId': parkingId,
      'currentOccupancyPercentage': currentOccupancyPercentage,
      'predictedOccupancy15Min': predictedOccupancy15Min,
      'predictedOccupancy30Min': predictedOccupancy30Min,
      'predictedOccupancy1Hour': predictedOccupancy1Hour,
      'predictedOccupancy2Hours': predictedOccupancy2Hours,
      'bestArrivalTime': bestArrivalTime,
      'predictedWaitingTimeMins': predictedWaitingTimeMins,
      'trafficTrend': trafficTrend,
      'demandTrend': demandTrend,
      'dynamicPricingTrend': dynamicPricingTrend,
      'hourlyOccupancyTrend': hourlyOccupancyTrend,
    };
  }

  factory PredictionModel.fromMap(Map<String, dynamic> map, String id) {
    return PredictionModel(
      parkingId: id,
      currentOccupancyPercentage: (map['currentOccupancyPercentage'] ?? 75.0).toDouble(),
      predictedOccupancy15Min: (map['predictedOccupancy15Min'] ?? 80.0).toDouble(),
      predictedOccupancy30Min: (map['predictedOccupancy30Min'] ?? 85.0).toDouble(),
      predictedOccupancy1Hour: (map['predictedOccupancy1Hour'] ?? 92.0).toDouble(),
      predictedOccupancy2Hours: (map['predictedOccupancy2Hours'] ?? 70.0).toDouble(),
      bestArrivalTime: map['bestArrivalTime'] ?? '10:15 AM (Low congestion window)',
      predictedWaitingTimeMins: (map['predictedWaitingTimeMins'] ?? 2).toInt(),
      trafficTrend: map['trafficTrend'] ?? 'Increasing ↗',
      demandTrend: map['demandTrend'] ?? 'High Demand 🔥',
      dynamicPricingTrend: map['dynamicPricingTrend'] ?? 'Price rising in 45m 📈',
      hourlyOccupancyTrend: List<double>.from(
        (map['hourlyOccupancyTrend'] as List?)?.map((e) => (e as num).toDouble()) ??
            [40, 45, 60, 75, 82, 90, 88, 76, 65, 50, 42, 38],
      ),
    );
  }

  @override
  List<Object?> get props => [
        parkingId,
        currentOccupancyPercentage,
        predictedOccupancy15Min,
        predictedOccupancy30Min,
        predictedOccupancy1Hour,
        predictedOccupancy2Hours,
        bestArrivalTime,
        predictedWaitingTimeMins,
        trafficTrend,
        demandTrend,
        dynamicPricingTrend,
        hourlyOccupancyTrend,
      ];
}
