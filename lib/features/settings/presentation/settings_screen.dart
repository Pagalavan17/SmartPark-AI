import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../providers/app_state_providers.dart';

/// App Settings & Preferences Screen
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(isDarkModeProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'App Settings',
        onBackPressed: () => context.go('/profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Preferences', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.language, color: AppColors.primary),
                      title: Text('Language', style: AppTextStyles.bodyLarge),
                      subtitle: Text('English', style: AppTextStyles.bodySmall),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                      onTap: () => context.go('/language'),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      secondary: const Icon(Icons.notifications_active_outlined, color: AppColors.primary),
                      title: Text('Push Notifications', style: AppTextStyles.bodyLarge),
                      value: _notificationsEnabled,
                      activeColor: AppColors.primary,
                      onChanged: (val) => setState(() => _notificationsEnabled = val),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      secondary: const Icon(Icons.dark_mode_outlined, color: AppColors.primary),
                      title: Text('Dark Theme', style: AppTextStyles.bodyLarge),
                      value: isDarkMode,
                      activeColor: AppColors.primary,
                      onChanged: (val) {
                        ref.read(isDarkModeProvider.notifier).state = val;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text('Permissions & Privacy', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.location_on_outlined, color: AppColors.primary),
                      title: Text('Location Permission', style: AppTextStyles.bodyLarge),
                      trailing: Text('Granted', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.success, fontWeight: FontWeight.bold)),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.security, color: AppColors.primary),
                      title: Text('Privacy & Security Policy', style: AppTextStyles.bodyLarge),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                      onTap: () => context.go('/about'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text('Support & Info', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.help_outline, color: AppColors.primary),
                      title: Text('Help & FAQ', style: AppTextStyles.bodyLarge),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                      onTap: () => context.go('/help'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.info_outline, color: AppColors.primary),
                      title: Text('About SmartPark AI', style: AppTextStyles.bodyLarge),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                      onTap: () => context.go('/about'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.go('/login'),
                  icon: const Icon(Icons.logout, color: AppColors.error),
                  label: Text('Logout', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.error, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
