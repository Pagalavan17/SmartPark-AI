import '../models/notification_model.dart';

abstract class INotificationRepository {
  Future<List<NotificationModel>> getUserNotifications(String userId);
  Future<void> addNotification(NotificationModel notification);
  Future<void> markAsRead(String notificationId);
}
