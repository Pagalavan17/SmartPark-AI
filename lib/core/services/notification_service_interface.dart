/// Abstract Interface for FCM & Push Notification Management
abstract class INotificationService {
  Future<void> initializePushNotifications();
  Future<String?> getFCMToken();
  Future<void> subscribeToTopic(String topic);
  Future<void> unsubscribeFromTopic(String topic);
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  });
}
