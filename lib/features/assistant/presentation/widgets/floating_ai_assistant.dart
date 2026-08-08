import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'ai_assistant_sheet.dart';

/// Global Floating AI Assistant FAB accessible across screens
class FloatingAIAssistant extends StatelessWidget {
  const FloatingAIAssistant({super.key});

  void _openAssistant(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const AIAssistantSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'floating_ai_assistant_fab',
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 4,
      onPressed: () => _openAssistant(context),
      child: const Icon(Icons.auto_awesome, size: 26),
    );
  }
}
