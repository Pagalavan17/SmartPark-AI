import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/custom_app_bar.dart';

/// Registered Vehicles Management Screen
class MyVehiclesScreen extends StatelessWidget {
  const MyVehiclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Vehicles',
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
                    _buildVehicleCard(
                      context,
                      number: 'TN 01 AB 1234',
                      model: 'SUV - Hyundai Creta',
                      color: 'Polar White',
                      isDefault: true,
                    ),
                    _buildVehicleCard(
                      context,
                      number: 'TN 09 XY 5678',
                      model: 'Hatchback - Tata Altroz',
                      color: 'Harbor Blue',
                      isDefault: false,
                    ),
                  ],
                ),
              ),
              PrimaryButton(
                text: 'Add New Vehicle',
                icon: Icons.add,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Add vehicle modal ready.')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleCard(
    BuildContext context, {
    required String number,
    required String model,
    required String color,
    required bool isDefault,
  }) {
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
                Row(
                  children: [
                    const Icon(Icons.directions_car, color: AppColors.primary, size: 24),
                    const SizedBox(width: 10),
                    Text(number, style: AppTextStyles.headingSmall.copyWith(fontSize: 18)),
                  ],
                ),
                if (isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('DEFAULT', style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(model, style: AppTextStyles.bodyMedium),
            Text('Color: $color', style: AppTextStyles.bodySmall),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.delete_outline, size: 16, color: AppColors.error),
                  label: const Text('Delete', style: TextStyle(color: AppColors.error)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
