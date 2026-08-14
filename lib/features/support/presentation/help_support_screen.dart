import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';

/// Help & Support Center Screen
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Help & FAQ',
        onBackPressed: () => context.go('/settings'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact Channels Row
              Row(
                children: [
                  Expanded(
                    child: _buildContactCard(
                      context,
                      icon: Icons.headset_mic_outlined,
                      title: 'Support Call',
                      subtitle: '+91 1800-SMART-PARK',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildContactCard(
                      context,
                      icon: Icons.email_outlined,
                      title: 'Email Us',
                      subtitle: 'support@smartpark.ai',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Text('Frequently Asked Questions (FAQ)', style: AppTextStyles.headingSmall),
              const SizedBox(height: 12),

              const _FaqItem(
                question: 'How does AI Parking Recommendation work?',
                answer: 'Our AI model analyzes historical traffic congestion, real-time camera feeds, and occupancy patterns to suggest spots with shortest total drive + walk time.',
              ),
              const _FaqItem(
                question: 'How do I scan the QR Pass at the parking gate?',
                answer: 'Open your Active Booking QR Pass screen and position your phone screen facing the scanner beam at entry or exit gates.',
              ),
              const _FaqItem(
                question: 'Can I cancel my reservation and get a refund?',
                answer: 'Yes, cancellations made up to 15 minutes before slot start time qualify for a 100% instant refund back to your payment method.',
              ),
              const _FaqItem(
                question: 'What if a slot is occupied when I arrive?',
                answer: 'SmartPark AI guarantees your reserved slot. Tap "Report Issue" or call our 24/7 hotline for instant automatic re-allocation.',
              ),
              const SizedBox(height: 24),

              // Report Issue & Feedback Actions
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.bug_report_outlined, color: AppColors.primary),
                      title: Text('Report an Issue', style: AppTextStyles.bodyLarge),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Issue reporting form opened.')),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.star_rate_outlined, color: AppColors.primary),
                      title: Text('Rate SmartPark AI on Play Store', style: AppTextStyles.bodyLarge),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Opening Google Play Store rating...')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 3))],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(height: 8),
          Text(title, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(subtitle, style: AppTextStyles.caption, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ExpansionTile(
        title: Text(question, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(answer, style: AppTextStyles.bodyMedium),
          ),
        ],
      ),
    );
  }
}
