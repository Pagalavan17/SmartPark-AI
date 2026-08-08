import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Select Language',
        onBackPressed: () => context.go('/settings'),
      ),
      body: SafeArea(
        child: RadioGroup<String>(
          groupValue: activeCode,
          onChanged: (val) {
            if (val != null) {
              ref.read(activeLanguageCodeProvider.notifier).state = val;
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
                  onTap: () {
                    ref.read(activeLanguageCodeProvider.notifier).state = lang.code;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('App language changed to ${lang.name}')),
                    );
                  },
                  title: Text(
                    lang.nativeName,
                    style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(lang.name, style: AppTextStyles.bodySmall),
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
