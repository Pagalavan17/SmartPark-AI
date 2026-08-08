import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/notification_model.dart';
import '../../providers/repository_providers.dart';
import 'notification_service.dart';
import 'notification_scheduler.dart';
import 'notification_preferences_manager.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final service = NotificationService(
    notificationRepository: ref.watch(notificationRepositoryProvider),
  );
  service.initialize();
  return service;
});

final notificationSchedulerProvider = Provider<NotificationScheduler>((ref) {
  return NotificationScheduler(
    notificationService: ref.watch(notificationServiceProvider),
  );
});

final notificationPreferencesProvider = StateProvider<NotificationPreferencesModel>((ref) {
  return const NotificationPreferencesModel();
});

final userNotificationsProvider = FutureProvider.family<List<NotificationModel>, String>((ref, userId) {
  final repo = ref.watch(notificationRepositoryProvider);
  return repo.getUserNotifications(userId);
});
