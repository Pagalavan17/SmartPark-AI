import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/extensions/l10n_extension.dart';
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

  String _getCategoryLabel(BuildContext context, String cat) {
    final l10n = context.l10n;
    switch (cat.toLowerCase()) {
      case 'all':
        return l10n.categoryAll;
      case 'reservation':
        return l10n.categoryReservation;
      case 'ai':
        return l10n.categoryAi;
      case 'adaptive':
        return l10n.categoryAdaptive;
      case 'expiry':
        return l10n.categoryExpiry;
      case 'surge':
        return l10n.categorySurge;
      default:
        return cat;
    }
  }

  String _localizeTitle(BuildContext context, String rawTitle) {
    final l10n = context.l10n;
    if (rawTitle.contains('Reservation Confirmed')) return l10n.reservationConfirmed;
    if (rawTitle.contains('AI Smart Pick Available')) return l10n.aiSmartPickAvailable;
    if (rawTitle.contains('Low traffic route detected')) return l10n.lowTrafficRouteDetected;
    if (rawTitle.contains('Parking Expiry Warning')) return l10n.parkingExpiryWarning;
    if (rawTitle.contains('Peak Surge Alert')) return l10n.peakSurgeAlert;
    return rawTitle;
  }

  String _formatTime(BuildContext context, DateTime time) {
    final l10n = context.l10n;
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return l10n.minsAgo(diff.inMinutes < 1 ? 1 : diff.inMinutes);
    if (diff.inHours < 24) return l10n.hoursAgo(diff.inHours);
    return '${time.day}/${time.month}/${time.year}';
  }

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(userNotificationsProvider('user_1'));
    final repo = ref.watch(notificationRepositoryProvider);
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppNavigationDrawer(currentRoute: '/notifications'),
      appBar: AppBar(
        title: Text(l10n.notificationsTitle, style: AppTextStyles.headingSmall.copyWith(color: theme.colorScheme.onSurface)),
        leading: IconButton(
          icon: Icon(Icons.menu, color: theme.colorScheme.onSurface),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.done_all, color: theme.colorScheme.onSurface),
            tooltip: l10n.markAllAsRead,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.allNotificationsMarkedRead)),
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
                    label: Text(_getCategoryLabel(context, cat)),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    backgroundColor: theme.colorScheme.surfaceContainer,
                    labelStyle: AppTextStyles.caption.copyWith(
                      color: isSelected ? Colors.white : theme.colorScheme.onSurface,
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
              error: (err, stack) => Center(child: Text('${l10n.unableToLoadNotifications}: $err')),
              data: (notifications) {
                final filtered = _selectedCategory == 'All'
                    ? notifications
                    : notifications.where((n) => n.type.toLowerCase() == _selectedCategory.toLowerCase()).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_off_outlined, size: 64, color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(height: 12),
                        Text(l10n.noNotificationsAvailable, style: AppTextStyles.bodyLarge.copyWith(color: theme.colorScheme.onSurface)),
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
                          SnackBar(content: Text('${_localizeTitle(context, item.title)} ${l10n.done}')),
                        );
                      },
                      child: Card(
                        elevation: item.isRead ? 0 : 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        color: item.isRead ? theme.colorScheme.surface : AppColors.primary.withValues(alpha: 0.12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: item.isRead ? theme.colorScheme.outline : AppColors.primary.withValues(alpha: 0.4),
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
                                  _localizeTitle(context, item.title),
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: theme.colorScheme.onSurface,
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
                              Text(item.body, style: AppTextStyles.bodySmall.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                              const SizedBox(height: 6),
                              Text(_formatTime(context, item.timestamp), style: AppTextStyles.caption.copyWith(color: theme.colorScheme.onSurfaceVariant)),
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
}
