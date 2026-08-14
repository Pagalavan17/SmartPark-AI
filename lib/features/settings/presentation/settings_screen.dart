import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/extensions/l10n_extension.dart';
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

  String _getLanguageNativeName(String code) {
    switch (code) {
      case 'ta':
        return 'தமிழ் (Tamil)';
      case 'hi':
        return 'हिंदी (Hindi)';
      case 'ml':
        return 'മലയാളം (Malayalam)';
      case 'kn':
        return 'ಕನ್ನಡ (Kannada)';
      case 'en':
      default:
        return 'English';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    final activeLanguage = ref.watch(activeLanguageCodeProvider);
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.settingsTitle,
        onBackPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/profile');
          }
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.settings,
                style: AppTextStyles.caption.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.language, color: AppColors.primary),
                      title: Text(l10n.language, style: AppTextStyles.bodyLarge.copyWith(color: theme.colorScheme.onSurface)),
                      subtitle: Text(_getLanguageNativeName(activeLanguage), style: AppTextStyles.bodySmall.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      trailing: Icon(Icons.arrow_forward_ios, size: 14, color: theme.colorScheme.onSurfaceVariant),
                      onTap: () => context.go('/language'),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      secondary: const Icon(Icons.notifications_active_outlined, color: AppColors.primary),
                      title: Text(l10n.notificationsTitle, style: AppTextStyles.bodyLarge.copyWith(color: theme.colorScheme.onSurface)),
                      value: _notificationsEnabled,
                      activeThumbColor: AppColors.primary,
                      onChanged: (val) => setState(() => _notificationsEnabled = val),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      secondary: const Icon(Icons.dark_mode_outlined, color: AppColors.primary),
                      title: Text(l10n.darkMode, style: AppTextStyles.bodyLarge.copyWith(color: theme.colorScheme.onSurface)),
                      value: isDarkMode,
                      activeThumbColor: AppColors.primary,
                      onChanged: (val) {
                        ref.read(isDarkModeProvider.notifier).toggleTheme(val);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                l10n.helpSupport,
                style: AppTextStyles.caption.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.help_outline, color: AppColors.primary),
                      title: Text(l10n.helpSupport, style: AppTextStyles.bodyLarge.copyWith(color: theme.colorScheme.onSurface)),
                      trailing: Icon(Icons.arrow_forward_ios, size: 14, color: theme.colorScheme.onSurfaceVariant),
                      onTap: () => context.go('/help'),
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
                  label: Text(l10n.logout, style: AppTextStyles.bodyLarge.copyWith(color: AppColors.error, fontWeight: FontWeight.bold)),
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
