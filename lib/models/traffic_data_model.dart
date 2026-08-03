import 'package:equatable/equatable.dart';

class TrafficDataModel extends Equatable {
  final String routeId;
  final double congestionLevel; // 0.0 (clear) to 1.0 (heavy)
  final int estimatedTimeInMinutes;
  final double delayInMinutes;
  final String trafficStatusText;

  const TrafficDataModel({
    required this.routeId,
    required this.congestionLevel,
    required this.estimatedTimeInMinutes,
    required this.delayInMinutes,
    required this.trafficStatusText,
  });

  @override
  List<Object?> get props => [
        routeId,
        congestionLevel,
        estimatedTimeInMinutes,
        delayInMinutes,
        trafficStatusText,
      ];
}
