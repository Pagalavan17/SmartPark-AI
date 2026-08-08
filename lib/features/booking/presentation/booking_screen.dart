import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/custom_app_bar.dart';

/// Reservation Details & Price Checkout Summary Screen
class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final TextEditingController _couponController = TextEditingController();
  bool _acceptTerms = true;
  double _discount = 0.0;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    if (_couponController.text.trim().toUpperCase() == 'SMART20') {
      setState(() => _discount = 20.0);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Promo Code SMART20 Applied! ₹20 Discount')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid Promo Code. Try "SMART20"')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const double parkingFee = 200.0;
    const double serviceFee = 15.0;
    const double taxes = 18.0;
    final double total = parkingFee + serviceFee + taxes - _discount;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Reserve Parking Slot'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking Summary Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Metro Cyber Park', style: AppTextStyles.headingSmall),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('Slot A-14', style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildSummaryRow(Icons.directions_car, 'Vehicle', 'TN 01 AB 1234 (SUV)'),
                    const SizedBox(height: 10),
                    _buildSummaryRow(Icons.calendar_today, 'Date', 'Today, Oct 24, 2026'),
                    const SizedBox(height: 10),
                    _buildSummaryRow(Icons.access_time, 'Duration', '10:00 AM - 02:00 PM (4 Hrs)'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Coupon Field
            Text('Promo Code / Coupon', style: AppTextStyles.headingSmall),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _couponController,
                    decoration: const InputDecoration(
                      hintText: 'Enter coupon (e.g. SMART20)',
                      prefixIcon: Icon(Icons.confirmation_number_outlined),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _applyCoupon,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Apply'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Price Breakdown Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Price Breakdown', style: AppTextStyles.headingSmall),
                    const SizedBox(height: 14),
                    _buildPriceRow('Parking Fee (4 hrs)', '₹${parkingFee.toInt()}'),
                    const SizedBox(height: 8),
                    _buildPriceRow('Service & Platform Fee', '₹${serviceFee.toInt()}'),
                    const SizedBox(height: 8),
                    _buildPriceRow('Taxes & GST', '₹${taxes.toInt()}'),
                    if (_discount > 0) ...[
                      const SizedBox(height: 8),
                      _buildPriceRow('Coupon Discount', '-₹${_discount.toInt()}', isDiscount: true),
                    ],
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Amount payable', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                        Text('₹${total.toInt()}', style: AppTextStyles.headingLarge.copyWith(color: AppColors.primary)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Terms Checkbox
            Row(
              children: [
                Checkbox(
                  value: _acceptTerms,
                  activeColor: AppColors.primary,
                  onChanged: (val) => setState(() => _acceptTerms = val ?? true),
                ),
                Expanded(
                  child: Text(
                    'I agree to the reservation cancellation & parking rules.',
                    style: AppTextStyles.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Continue to Payment Button
            PrimaryButton(
              text: 'Continue To Payment (₹${total.toInt()})',
              onPressed: () {
                if (!_acceptTerms) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please accept parking rules.')),
                  );
                  return;
                }
                context.go('/payment');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(label, style: AppTextStyles.bodyMedium),
        const Spacer(),
        Text(value, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPriceRow(String label, String amount, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium),
        Text(
          amount,
          style: AppTextStyles.bodyLarge.copyWith(
            color: isDiscount ? AppColors.success : AppColors.textPrimary,
            fontWeight: isDiscount ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
