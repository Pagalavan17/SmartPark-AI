import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/secondary_button.dart';

/// Payment Success Confirmation Screen
class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          child: Column(
            children: [
              const SizedBox(height: 20),
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
              Text(l10n.paymentSuccessful, style: AppTextStyles.headingLarge.copyWith(color: theme.colorScheme.onSurface)),
              const SizedBox(height: 6),
              Text(
                l10n.spotReservedSuccessfully,
                style: AppTextStyles.bodyMedium.copyWith(color: theme.colorScheme.onSurfaceVariant),
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
                      _buildDetailRow(l10n.bookingId, '#SP-982341', context),
                      const Divider(height: 20),
                      _buildDetailRow(l10n.parkingLocation, 'Metro Cyber Park', context),
                      const Divider(height: 20),
                      _buildDetailRow(l10n.totalSlots, 'Slot A-14', context),
                      const Divider(height: 20),
                      _buildDetailRow(l10n.amount, '₹213.00', context),
                      const Divider(height: 20),
                      _buildDetailRow(l10n.transactionId, 'TXN-87623491', context),
                      const Divider(height: 20),
                      _buildDetailRow(l10n.paymentMethod, 'Google Pay (${l10n.upi})', context),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Action Buttons
              PrimaryButton(
                text: l10n.showQr,
                icon: Icons.qr_code,
                onPressed: () => context.go('/qr-pass'),
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                text: l10n.returnToHome,
                onPressed: () => context.go('/home'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(color: theme.colorScheme.onSurfaceVariant),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
