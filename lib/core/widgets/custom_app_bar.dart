import 'package:flutter/material.dart';
import '../constants/app_text_styles.dart';

/// Reusable Custom App Bar for SmartPark AI screens
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.actions,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: Text(title, style: AppTextStyles.headingSmall.copyWith(color: theme.colorScheme.onSurface)),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: theme.colorScheme.onSurface, size: 20),
              onPressed: onBackPressed ?? () => Navigator.of(context).maybePop(),
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
