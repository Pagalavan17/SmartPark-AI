import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/secondary_button.dart';

/// Payment Success Confirmation Screen
class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          child: Column(
            children: [
              const Spacer(),
              // Animated Success Icon Badge
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: 72,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: 24),
              Text('Payment Successful! 🎉', style: AppTextStyles.headingLarge),
              const SizedBox(height: 6),
              Text(
                'Your parking slot has been reserved successfully.',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Transaction Details Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildDetailRow('Booking ID', '#SP-982341'),
                      const Divider(height: 20),
                      _buildDetailRow('Parking Spot', 'Metro Cyber Park'),
                      const Divider(height: 20),
                      _buildDetailRow('Slot Number', 'Slot A-14'),
                      const Divider(height: 20),
                      _buildDetailRow('Amount Paid', '₹213.00'),
                      const Divider(height: 20),
                      _buildDetailRow('Transaction ID', 'TXN-87623491'),
                      const Divider(height: 20),
                      _buildDetailRow('Payment Method', 'Google Pay (UPI)'),
                    ],
                  ),
                ),
              ),
              const Spacer(),

              // Action Buttons
              PrimaryButton(
                text: 'View QR Entry Pass',
                icon: Icons.qr_code,
                onPressed: () => context.go('/qr-pass'),
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                text: 'Return To Home',
                onPressed: () => context.go('/home'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium),
        Text(value, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
