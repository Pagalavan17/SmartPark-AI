import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';
import 'notification_repository.dart';

class FirebaseNotificationRepository implements INotificationRepository {
  final FirebaseFirestore? _firestore;
  final List<NotificationModel> _fallback = [
    NotificationModel(
      id: 'n_1',
      userId: 'user_1',
      title: 'Reservation Confirmed',
      body: 'Your slot at Metro Cyber Park Garage is reserved for 10:00 AM.',
      type: 'Reservation',
      isRead: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    NotificationModel(
      id: 'n_2',
      userId: 'user_1',
      title: 'AI Smart Pick Available',
      body: 'Low traffic route detected for Phoenix Marketcity Hub.',
      type: 'AI',
      isRead: true,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  FirebaseNotificationRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<NotificationModel>> getUserNotifications(String userId) async {
    try {
      if (_firestore != null) {
        final snapshot = await _firestore.collection('notifications').get();
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs.map((doc) => NotificationModel.fromMap(doc.data(), doc.id)).toList();
        }
      }
    } catch (_) {}
    return _fallback;
  }

  @override
  Future<void> addNotification(NotificationModel notification) async {
    try {
      if (_firestore != null) {
        await _firestore.collection('notifications').doc(notification.id).set(notification.toMap());
      }
    } catch (_) {}
    _fallback.insert(0, notification);
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      if (_firestore != null) {
        await _firestore.collection('notifications').doc(notificationId).update({'isRead': true});
      }
    } catch (_) {}
  }
}
