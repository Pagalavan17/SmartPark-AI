import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../services/payment/payment_providers.dart';

/// Complete Production Smart Payment Screen
class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  String _selectedMethod = 'Razorpay (UPI / GPay / Cards)';

  static const List<String> _paymentMethods = [
    'Razorpay (UPI / GPay / Cards)',
    'UPI Instant (PhonePe / Paytm)',
    'Credit / Debit Card',
    'Net Banking',
    'SmartPark Wallet',
  ];

  @override
  Widget build(BuildContext context) {
    final paymentService = ref.watch(paymentServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout & Payment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pricing Breakdown Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order Summary', style: AppTextStyles.headingSmall),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('AI Price Optimized', style: AppTextStyles.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildRow('Base Parking Fee (2 Hours)', '₹100.00'),
                    _buildRow('Peak Surge Surcharge', '₹10.00'),
                    _buildRow('GST & Taxes (12%)', '₹12.00'),
                    _buildRow('Platform Service Fee', '₹15.00'),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Amount', style: AppTextStyles.headingSmall),
                        Text('₹137.00', style: AppTextStyles.headingLarge.copyWith(color: AppColors.primary)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Select Payment Method
            Text('Select Payment Gateway / Method', style: AppTextStyles.headingSmall),
            const SizedBox(height: 12),
            Column(
              children: _paymentMethods.map((method) {
                final isSelected = _selectedMethod == method;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: ListTile(
                    onTap: () => setState(() => _selectedMethod = method),
                    leading: Icon(
                      _getMethodIcon(method),
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    ),
                    title: Text(
                      method,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            // Pay Now Button
            PrimaryButton(
              text: 'Pay ₹137.00 & Confirm Slot',
              onPressed: () {
                paymentService.startRazorpayPayment(
                  reservationId: 'SP-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                  amount: 137.0,
                  userEmail: 'alex.morgan@smartpark.ai',
                  userPhone: '+919876543210',
                  parkingName: 'Metro Cyber Park Garage',
                );
                context.go('/payment-success');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySmall),
          Text(value, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  IconData _getMethodIcon(String method) {
    if (method.contains('Card')) return Icons.credit_card;
    if (method.contains('Wallet')) return Icons.account_balance_wallet_outlined;
    if (method.contains('Net')) return Icons.account_balance_outlined;
    return Icons.qr_code_scanner;
  }
}
