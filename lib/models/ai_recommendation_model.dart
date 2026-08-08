import 'package:equatable/equatable.dart';

class AIRecommendationModel extends Equatable {
  final String spotId;
  final String spotName;
  final double confidenceScore;
  final String reasoning;
  final double estimatedTimeSavedInMinutes;

  const AIRecommendationModel({
    required this.spotId,
    required this.spotName,
    required this.confidenceScore,
    required this.reasoning,
    required this.estimatedTimeSavedInMinutes,
  });

  @override
  List<Object?> get props => [
        spotId,
        spotName,
        confidenceScore,
        reasoning,
        estimatedTimeSavedInMinutes,
      ];
}
