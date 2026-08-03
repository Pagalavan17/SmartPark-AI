import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/custom_app_bar.dart';

/// Payment Options & Checkout Screen
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'upi_gpay';
  bool _isProcessing = false;

  void _handlePayment() {
    setState(() => _isProcessing = true);
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() => _isProcessing = false);
        context.go('/payment-success');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Payment Checkout'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Metro Cyber Park (Slot A-14)', style: AppTextStyles.headingSmall.copyWith(fontSize: 16)),
                        const SizedBox(height: 4),
                        Text('Vehicle: TN 01 AB 1234 • 4 Hours', style: AppTextStyles.bodySmall),
                      ],
                    ),
                    Text('₹213', style: AppTextStyles.headingLarge.copyWith(color: AppColors.primary)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Select Payment Method Header
            Text('Select Payment Method', style: AppTextStyles.headingSmall),
            const SizedBox(height: 12),

            // Payment Options List
            _buildPaymentOption(
              id: 'upi_gpay',
              title: 'Google Pay (UPI)',
              subtitle: 'Fast checkout via UPI app',
              icon: Icons.account_balance_wallet_outlined,
            ),
            _buildPaymentOption(
              id: 'upi_phonepe',
              title: 'PhonePe / Paytm',
              subtitle: 'Direct bank transfer via UPI',
              icon: Icons.qr_code_scanner,
            ),
            _buildPaymentOption(
              id: 'card',
              title: 'Credit / Debit Card',
              subtitle: 'Visa, MasterCard, RuPay supported',
              icon: Icons.credit_card_outlined,
            ),
            _buildPaymentOption(
              id: 'netbanking',
              title: 'Net Banking',
              subtitle: 'All major Indian banks',
              icon: Icons.account_balance_outlined,
            ),
            const SizedBox(height: 20),

            // Security Badge
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock, size: 16, color: AppColors.success),
                  const SizedBox(width: 6),
                  Text(
                    '256-Bit SSL Encrypted & Secured Payment',
                    style: AppTextStyles.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Pay Now Primary Action Button
            PrimaryButton(
              text: 'Pay ₹213 Now',
              isLoading: _isProcessing,
              onPressed: _handlePayment,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedMethod == id;

    return Card(
      elevation: isSelected ? 3 : 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: ListTile(
        onTap: () => setState(() => _selectedMethod = id),
        leading: CircleAvatar(
          backgroundColor: (isSelected ? AppColors.primary : AppColors.textLight).withOpacity(0.1),
          child: Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary),
        ),
        title: Text(title, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
        trailing: Radio<String>(
          value: id,
          groupValue: _selectedMethod,
          activeColor: AppColors.primary,
          onChanged: (val) {
            if (val != null) setState(() => _selectedMethod = val);
          },
        ),
      ),
    );
  }
}
