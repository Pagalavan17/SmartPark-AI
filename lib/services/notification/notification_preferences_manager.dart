import 'package:equatable/equatable.dart';

/// User Notification Preferences configuration model
class NotificationPreferencesModel extends Equatable {
  final bool enableReservationAlerts;
  final bool enableAIRecommendations;
  final bool enableTrafficAlerts;
  final bool enablePricingAlerts;
  final bool enablePromotions;
  final bool enableSound;
  final bool enableVibration;

  const NotificationPreferencesModel({
    this.enableReservationAlerts = true,
    this.enableAIRecommendations = true,
    this.enableTrafficAlerts = true,
    this.enablePricingAlerts = true,
    this.enablePromotions = false,
    this.enableSound = true,
    this.enableVibration = true,
  });

  NotificationPreferencesModel copyWith({
    bool? enableReservationAlerts,
    bool? enableAIRecommendations,
    bool? enableTrafficAlerts,
    bool? enablePricingAlerts,
    bool? enablePromotions,
    bool? enableSound,
    bool? enableVibration,
  }) {
    return NotificationPreferencesModel(
      enableReservationAlerts: enableReservationAlerts ?? this.enableReservationAlerts,
      enableAIRecommendations: enableAIRecommendations ?? this.enableAIRecommendations,
      enableTrafficAlerts: enableTrafficAlerts ?? this.enableTrafficAlerts,
      enablePricingAlerts: enablePricingAlerts ?? this.enablePricingAlerts,
      enablePromotions: enablePromotions ?? this.enablePromotions,
      enableSound: enableSound ?? this.enableSound,
      enableVibration: enableVibration ?? this.enableVibration,
    );
  }

  @override
  List<Object?> get props => [
        enableReservationAlerts,
        enableAIRecommendations,
        enableTrafficAlerts,
        enablePricingAlerts,
        enablePromotions,
        enableSound,
        enableVibration,
      ];
}
