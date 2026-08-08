import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';
import 'auth_controller.dart';

/// Email Verification Screen shown after Email/Password registration or for
/// unverified email users attempting to access protected routes.
class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  bool _resendCooldown = false;

  Future<void> _resendVerification() async {
    if (_resendCooldown) return;
    setState(() => _resendCooldown = true);

    final success =
        await ref.read(authControllerProvider.notifier).resendEmailVerification();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? 'Verification email sent! Please check your inbox.'
              : 'Failed to send verification email. Please try again.'),
          backgroundColor: success ? AppColors.success : AppColors.error,
        ),
      );
    }

    // 30-second cooldown before allowing resend
    await Future.delayed(const Duration(seconds: 30));
    if (mounted) setState(() => _resendCooldown = false);
  }

  Future<void> _checkVerificationStatus() async {
    final isVerified = await ref
        .read(authControllerProvider.notifier)
        .reloadVerificationStatus();

    if (!mounted) return;

    if (isVerified) {
      context.go('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email not yet verified. Please check your inbox.'),
          backgroundColor: AppColors.warning,
        ),
      );
    }
  }

  Future<void> _logout() async {
    await ref.read(authControllerProvider.notifier).logout();
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final email = authState.user?.email ?? ref.read(authRepositoryProvider).currentUser?.email ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_read_outlined,
                  size: 64,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 32),

              Text(
                'Verify Your Email',
                style: AppTextStyles.headingLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              Text(
                'A verification link has been sent to:',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                email,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Please click the link in the email to verify your account, then tap "I\'ve Verified" below.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // I've Verified Button
              PrimaryButton(
                text: "I've Verified",
                isLoading: authState.isLoading,
                onPressed: _checkVerificationStatus,
              ),
              const SizedBox(height: 16),

              // Resend Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: _resendCooldown ? null : _resendVerification,
                  icon: const Icon(Icons.refresh),
                  label: Text(
                    _resendCooldown
                        ? 'Resend in 30s...'
                        : 'Resend Verification Email',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    foregroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Return to Login
              TextButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Return to Login'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
