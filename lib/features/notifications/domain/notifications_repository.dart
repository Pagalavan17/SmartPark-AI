abstract class INotificationsRepository {
  Future<List<Map<String, dynamic>>> getNotifications();
  Future<void> markAsRead(String id);
}
