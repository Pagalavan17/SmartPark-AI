import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';

/// About SmartPark AI Application Information Screen
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'About SmartPark AI',
        onBackPressed: () => context.go('/settings'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          child: Column(
            children: [
              // Logo & App Version Header
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.local_parking_rounded, size: 52, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    Text('SmartPark AI', style: AppTextStyles.headingLarge),
                    const SizedBox(height: 4),
                    Text('Version 1.0.0 (Build 102)', style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 6),
                    Text(
                      'AI-Powered Smart Parking & Navigation System',
                      style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Developed By Banner
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: AppColors.secondary,
                        child: Icon(Icons.code, color: Colors.white),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Engineered & Developed By', style: AppTextStyles.caption),
                          Text('SmartPark AI Core Team', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Core Features Overview
              Text('Core Innovations', style: AppTextStyles.headingSmall),
              const SizedBox(height: 10),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _FeatureRow(title: 'Real-Time Slot Detection', desc: 'Predictive occupancy tracking across parking decks'),
                      Divider(height: 20),
                      _FeatureRow(title: 'AI Traffic Optimization', desc: 'Congestion forecast to suggest fastest parking routes'),
                      Divider(height: 20),
                      _FeatureRow(title: 'Dynamic QR Entry Pass', desc: 'Contactless gate entry and exit validation'),
                      Divider(height: 20),
                      _FeatureRow(title: 'Multilingual Support', desc: 'Native support for EN, TA, HI, ML, KN'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Legal & Licenses
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Terms of Service', style: AppTextStyles.bodyMedium),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: Text('Privacy Policy', style: AppTextStyles.bodyMedium),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: Text('Open Source Licenses', style: AppTextStyles.bodyMedium),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                      onTap: () => showLicensePage(context: context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('© 2026 SmartPark AI. All rights reserved.', style: AppTextStyles.caption),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String title;
  final String desc;

  const _FeatureRow({required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle_outline, color: AppColors.success, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(desc, style: AppTextStyles.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
