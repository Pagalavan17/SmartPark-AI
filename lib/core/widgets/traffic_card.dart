import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../constants/app_text_styles.dart';

/// Reusable Traffic Prediction Card Widget
class TrafficCard extends StatelessWidget {
  final String routeName;
  final String statusText;
  final double delayInMins;
  final double congestionLevel; // 0.0 to 1.0

  const TrafficCard({
    super.key,
    required this.routeName,
    required this.statusText,
    required this.delayInMins,
    required this.congestionLevel,
  });

  @override
  Widget build(BuildContext context) {
    final isHeavy = congestionLevel > 0.6;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (isHeavy ? AppColors.warning : AppColors.success).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isHeavy ? Icons.traffic : Icons.directions_car,
                color: isHeavy ? AppColors.warning : AppColors.success,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(routeName, style: AppTextStyles.headingSmall),
                  const SizedBox(height: 4),
                  Text(
                    '$statusText (${delayInMins > 0 ? "+${delayInMins.toInt()} mins" : "No delay"})',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
