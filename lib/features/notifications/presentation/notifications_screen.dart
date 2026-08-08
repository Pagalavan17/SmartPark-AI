import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_navigation_drawer.dart';

import '../../../services/notification/notification_providers.dart';
import '../../../providers/repository_providers.dart';

/// Production Intelligent Notification Center Screen
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedCategory = 'All';

  static const List<String> _categories = ['All', 'Reservation', 'AI', 'Adaptive', 'Expiry', 'Surge'];

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(userNotificationsProvider('user_1'));
    final repo = ref.watch(notificationRepositoryProvider);

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppNavigationDrawer(currentRoute: '/notifications'),
      appBar: AppBar(
        title: const Text('Notification Center'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Mark all as read',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications marked as read.')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter Chips
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding, vertical: 6),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.background,
                    labelStyle: AppTextStyles.caption.copyWith(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedCategory = cat);
                    },
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),

          // Main Notifications List
          Expanded(
            child: notificationsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error loading notifications: $err')),
              data: (notifications) {
                final filtered = _selectedCategory == 'All'
                    ? notifications
                    : notifications.where((n) => n.type.toLowerCase() == _selectedCategory.toLowerCase()).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.notifications_off_outlined, size: 64, color: AppColors.textSecondary),
                        const SizedBox(height: 12),
                        Text('No notifications in "$_selectedCategory"', style: AppTextStyles.bodyLarge),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return Dismissible(
                      key: Key(item.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: AppColors.error,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Notification "${item.title}" dismissed.')),
                        );
                      },
                      child: Card(
                        elevation: item.isRead ? 0 : 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        color: item.isRead ? Colors.white : AppColors.primary.withValues(alpha: 0.04),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: item.isRead ? AppColors.border : AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: ListTile(
                          onTap: () async {
                            await repo.markAsRead(item.id);
                            ref.invalidate(userNotificationsProvider('user_1'));
                          },
                          leading: CircleAvatar(
                            backgroundColor: _getCategoryColor(item.type).withValues(alpha: 0.15),
                            child: Icon(_getCategoryIcon(item.type), color: _getCategoryColor(item.type), size: 20),
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: item.isRead ? FontWeight.normal : FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (!item.isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                                ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(item.body, style: AppTextStyles.bodySmall),
                              const SizedBox(height: 6),
                              Text(_formatTime(item.timestamp), style: AppTextStyles.caption),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String type) {
    switch (type.toLowerCase()) {
      case 'reservation':
        return Icons.confirmation_number_outlined;
      case 'ai':
      case 'adaptive':
        return Icons.auto_awesome;
      case 'expiry':
        return Icons.warning_amber_rounded;
      case 'surge':
        return Icons.speed;
      default:
        return Icons.notifications_active_outlined;
    }
  }

  Color _getCategoryColor(String type) {
    switch (type.toLowerCase()) {
      case 'reservation':
        return AppColors.success;
      case 'ai':
      case 'adaptive':
        return AppColors.primary;
      case 'expiry':
        return AppColors.error;
      case 'surge':
        return AppColors.warning;
      default:
        return AppColors.secondary;
    }
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${time.day}/${time.month}/${time.year}';
  }
}
