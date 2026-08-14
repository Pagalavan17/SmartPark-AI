import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/custom_app_bar.dart';

/// Saved Payment Options Management Screen
class SavedPaymentsScreen extends StatelessWidget {
  const SavedPaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Saved Payment Methods',
        onBackPressed: () => context.go('/profile'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _buildPaymentCard(
                      title: 'Google Pay (UPI)',
                      detail: 'alex@okaxis',
                      icon: Icons.account_balance_wallet,
                      isDefault: true,
                    ),
                    _buildPaymentCard(
                      title: 'HDFC Credit Card',
                      detail: '•••• •••• •••• 4242',
                      icon: Icons.credit_card,
                      isDefault: false,
                    ),
                    _buildPaymentCard(
                      title: 'Paytm Wallet',
                      detail: '+91 9876543210',
                      icon: Icons.account_balance,
                      isDefault: false,
                    ),
                  ],
                ),
              ),
              PrimaryButton(
                text: 'Add Payment Method',
                icon: Icons.add,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Add payment method modal ready.')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentCard({
    required String title,
    required String detail,
    required IconData icon,
    required bool isDefault,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Row(
          children: [
            Text(title, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
            if (isDefault) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('DEFAULT', style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
        subtitle: Text(detail, style: AppTextStyles.bodyMedium),
        trailing: PopupMenuButton<String>(
          onSelected: (val) {},
          itemBuilder: (context) => [
            if (!isDefault) const PopupMenuItem(value: 'default', child: Text('Set as Default')),
            const PopupMenuItem(value: 'remove', child: Text('Remove')),
          ],
        ),
      ),
    );
  }
}
