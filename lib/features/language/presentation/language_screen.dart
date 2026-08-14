import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../providers/app_state_providers.dart';

/// Language Selection Model
class LanguageOption {
  final String code;
  final String name;
  final String nativeName;

  const LanguageOption({
    required this.code,
    required this.name,
    required this.nativeName,
  });
}

/// Multilingual Language Selector Screen
class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  final List<LanguageOption> _languages = const [
    LanguageOption(code: 'en', name: 'English', nativeName: 'English'),
    LanguageOption(code: 'ta', name: 'Tamil', nativeName: 'தமிழ்'),
    LanguageOption(code: 'hi', name: 'Hindi', nativeName: 'हिंदी'),
    LanguageOption(code: 'ml', name: 'Malayalam', nativeName: 'മലയാളം'),
    LanguageOption(code: 'kn', name: 'Kannada', nativeName: 'ಕನ್ನಡ'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeCode = ref.watch(activeLanguageCodeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: context.l10n.selectLanguage,
        onBackPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/settings');
          }
        },
      ),
      body: SafeArea(
        child: RadioGroup<String>(
          groupValue: activeCode,
          onChanged: (val) {
            if (val != null) {
              ref.read(activeLanguageCodeProvider.notifier).setLanguage(val);
            }
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(AppConstants.largePadding),
            itemCount: _languages.length,
            itemBuilder: (context, index) {
              final lang = _languages[index];
              final isSelected = lang.code == activeCode;

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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onTap: () {
                    ref.read(activeLanguageCodeProvider.notifier).setLanguage(lang.code);
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${context.l10n.selectLanguage}: ${lang.nativeName}'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  title: Text(
                    lang.nativeName,
                    style: AppTextStyles.bodyLarge.copyWith(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(lang.name, style: AppTextStyles.bodySmall.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  trailing: Radio<String>(
                    value: lang.code,
                    activeColor: AppColors.primary,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
