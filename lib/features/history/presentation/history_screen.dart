import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_navigation_drawer.dart';

import '../../../services/payment/payment_providers.dart';

/// Complete Production Payment History Screen
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final txAsync = ref.watch(userTransactionsProvider('user_1'));

    return Scaffold(
      key: scaffoldKey,
      drawer: const AppNavigationDrawer(currentRoute: '/history'),
      appBar: AppBar(
        title: const Text('Payment & Transaction History'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      body: txAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading transactions: $err')),
        data: (transactions) {
          if (transactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.textSecondary),
                  const SizedBox(height: 12),
                  Text('No payment transactions found.', style: AppTextStyles.bodyLarge),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final tx = transactions[index];
              return Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: tx.status == 'Success'
                        ? AppColors.success.withValues(alpha: 0.15)
                        : AppColors.error.withValues(alpha: 0.15),
                    child: Icon(
                      tx.status == 'Success' ? Icons.check_circle : Icons.cancel,
                      color: tx.status == 'Success' ? AppColors.success : AppColors.error,
                      size: 20,
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Pass #${tx.transactionId}', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                      Text('₹${tx.amount.toInt()}', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('Method: ${tx.paymentMethod}', style: AppTextStyles.caption),
                      Text('Date: ${tx.timestamp.day}/${tx.timestamp.month}/${tx.timestamp.year}', style: AppTextStyles.caption),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.download_rounded, color: AppColors.primary, size: 20),
                    tooltip: 'Download Invoice',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Downloading invoice for #${tx.transactionId}...')),
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
