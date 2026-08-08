import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../constants/app_text_styles.dart';

/// Reusable Parking Spot Card with availability badge & AI match score
class ParkingCard extends StatelessWidget {
  final String title;
  final String address;
  final double rating;
  final double distanceInKm;
  final double hourlyRate;
  final int availableSlots;
  final int totalSlots;
  final double aiMatchScore;
  final VoidCallback onTap;

  const ParkingCard({
    super.key,
    required this.title,
    required this.address,
    required this.rating,
    required this.distanceInKm,
    required this.hourlyRate,
    required this.availableSlots,
    required this.totalSlots,
    required this.aiMatchScore,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isHighAvailability = availableSlots > 5;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.headingSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.auto_awesome, size: 14, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          '${(aiMatchScore * 100).toInt()}% AI Match',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                address,
                style: AppTextStyles.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(rating.toStringAsFixed(1), style: AppTextStyles.bodyMedium),
                      const SizedBox(width: 12),
                      const Icon(Icons.location_on, size: 16, color: AppColors.secondary),
                      const SizedBox(width: 4),
                      Text('${distanceInKm.toStringAsFixed(1)} km', style: AppTextStyles.bodyMedium),
                    ],
                  ),
                  Text(
                    '₹${hourlyRate.toInt()}/hr',
                    style: AppTextStyles.headingSmall.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$availableSlots / $totalSlots slots available',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isHighAvailability ? AppColors.success : AppColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textLight),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
