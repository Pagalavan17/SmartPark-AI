import 'dart:convert';
import 'package:equatable/equatable.dart';

/// Analytics & Environmental report model for Admin Dashboard
class AnalyticsReportModel extends Equatable {
  final String reportId;
  final String timeFrame; // "Daily", "Weekly", "Monthly"
  final double totalRevenue;
  final double globalOccupancyRate;
  final int totalReservations;
  final double evChargingEnergyKWh;
  final double co2SavingsKg;
  final double aiPredictionAccuracy;
  final DateTime generatedAt;

  const AnalyticsReportModel({
    required this.reportId,
    required this.timeFrame,
    required this.totalRevenue,
    required this.globalOccupancyRate,
    required this.totalReservations,
    required this.evChargingEnergyKWh,
    required this.co2SavingsKg,
    required this.aiPredictionAccuracy,
    required this.generatedAt,
  });

  AnalyticsReportModel copyWith({
    String? reportId,
    String? timeFrame,
    double? totalRevenue,
    double? globalOccupancyRate,
    int? totalReservations,
    double? evChargingEnergyKWh,
    double? co2SavingsKg,
    double? aiPredictionAccuracy,
    DateTime? generatedAt,
  }) {
    return AnalyticsReportModel(
      reportId: reportId ?? this.reportId,
      timeFrame: timeFrame ?? this.timeFrame,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      globalOccupancyRate: globalOccupancyRate ?? this.globalOccupancyRate,
      totalReservations: totalReservations ?? this.totalReservations,
      evChargingEnergyKWh: evChargingEnergyKWh ?? this.evChargingEnergyKWh,
      co2SavingsKg: co2SavingsKg ?? this.co2SavingsKg,
      aiPredictionAccuracy: aiPredictionAccuracy ?? this.aiPredictionAccuracy,
      generatedAt: generatedAt ?? this.generatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reportId': reportId,
      'timeFrame': timeFrame,
      'totalRevenue': totalRevenue,
      'globalOccupancyRate': globalOccupancyRate,
      'totalReservations': totalReservations,
      'evChargingEnergyKWh': evChargingEnergyKWh,
      'co2SavingsKg': co2SavingsKg,
      'aiPredictionAccuracy': aiPredictionAccuracy,
      'generatedAt': generatedAt.toIso8601String(),
    };
  }

  factory AnalyticsReportModel.fromMap(Map<String, dynamic> map, String id) {
    return AnalyticsReportModel(
      reportId: id,
      timeFrame: map['timeFrame'] ?? 'Daily',
      totalRevenue: (map['totalRevenue'] ?? 12500.0).toDouble(),
      globalOccupancyRate: (map['globalOccupancyRate'] ?? 78.5).toDouble(),
      totalReservations: (map['totalReservations'] ?? 142).toInt(),
      evChargingEnergyKWh: (map['evChargingEnergyKWh'] ?? 450.0).toDouble(),
      co2SavingsKg: (map['co2SavingsKg'] ?? 120.5).toDouble(),
      aiPredictionAccuracy: (map['aiPredictionAccuracy'] ?? 96.8).toDouble(),
      generatedAt: DateTime.tryParse(map['generatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory AnalyticsReportModel.fromJson(String source, String id) =>
      AnalyticsReportModel.fromMap(json.decode(source), id);

  @override
  List<Object?> get props => [
        reportId,
        timeFrame,
        totalRevenue,
        globalOccupancyRate,
        totalReservations,
        evChargingEnergyKWh,
        co2SavingsKg,
        aiPredictionAccuracy,
        generatedAt,
      ];
}
