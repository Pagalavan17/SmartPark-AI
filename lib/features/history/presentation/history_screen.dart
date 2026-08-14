import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/widgets/app_navigation_drawer.dart';

import '../../../services/payment/payment_providers.dart';

/// Complete Production Payment History Screen
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final txAsync = ref.watch(userTransactionsProvider('user_1'));
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      key: scaffoldKey,
      drawer: const AppNavigationDrawer(currentRoute: '/history'),
      appBar: AppBar(
        title: Text(l10n.paymentHistoryTitle, style: AppTextStyles.headingSmall.copyWith(color: theme.colorScheme.onSurface)),
        leading: IconButton(
          icon: Icon(Icons.menu, color: theme.colorScheme.onSurface),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      body: txAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('${l10n.error}: $err')),
        data: (transactions) {
          if (transactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 64, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(height: 12),
                  Text(l10n.noTransactionsFound, style: AppTextStyles.bodyLarge.copyWith(color: theme.colorScheme.onSurface)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final tx = transactions[index];
              final isSuccess = tx.status == 'Success';
              final statusText = isSuccess ? l10n.statusSuccess : l10n.statusFailed;

              return Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: theme.colorScheme.outline),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isSuccess
                        ? AppColors.success.withValues(alpha: 0.15)
                        : AppColors.error.withValues(alpha: 0.15),
                    child: Icon(
                      isSuccess ? Icons.check_circle : Icons.cancel,
                      color: isSuccess ? AppColors.success : AppColors.error,
                      size: 20,
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.passNumber(tx.transactionId), style: AppTextStyles.bodyMedium.copyWith(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold)),
                      Text('₹${tx.amount.toInt()}', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(l10n.methodLabel(tx.paymentMethod), style: AppTextStyles.caption.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      Text(
                        '${l10n.dateLabel('${tx.timestamp.day}/${tx.timestamp.month}/${tx.timestamp.year}')} • $statusText',
                        style: AppTextStyles.caption.copyWith(
                          color: isSuccess ? AppColors.success : AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.download_rounded, color: AppColors.primary, size: 20),
                    tooltip: l10n.downloadInvoice,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.downloadingInvoice(tx.transactionId))),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
