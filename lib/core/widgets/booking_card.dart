import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../constants/app_text_styles.dart';

/// Reusable Booking Card widget for Active & Past Reservations
class BookingCard extends StatelessWidget {
  final String parkingSpotName;
  final String slotNumber;
  final String dateText;
  final String timeRangeText;
  final String status;
  final VoidCallback onViewQrPass;

  const BookingCard({
    super.key,
    required this.parkingSpotName,
    required this.slotNumber,
    required this.dateText,
    required this.timeRangeText,
    required this.status,
    required this.onViewQrPass,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = status.toLowerCase() == 'active';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(parkingSpotName, style: AppTextStyles.headingSmall),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: (isActive ? AppColors.success : AppColors.textLight).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: AppTextStyles.caption.copyWith(
                      color: isActive ? AppColors.success : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.local_parking, size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Text('Slot: $slotNumber', style: AppTextStyles.bodyMedium),
                const SizedBox(width: 16),
                const Icon(Icons.schedule, size: 16, color: AppColors.secondary),
                const SizedBox(width: 6),
                Text(timeRangeText, style: AppTextStyles.bodyMedium),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(dateText, style: AppTextStyles.bodySmall),
                if (isActive)
                  ElevatedButton.icon(
                    onPressed: onViewQrPass,
                    icon: const Icon(Icons.qr_code, size: 18),
                    label: const Text('View QR Pass'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
