import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../models/notification_model.dart';
import '../../repositories/notification_repository.dart';

/// Production Central Notification Engine combining FCM & Local Notifications
class NotificationService {
  final INotificationRepository notificationRepository;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final FirebaseMessaging? _fcm;

  NotificationService({
    required this.notificationRepository,
    FirebaseMessaging? fcm,
  }) : _fcm = fcm ?? _tryGetFCM();

  static FirebaseMessaging? _tryGetFCM() {
    try {
      return FirebaseMessaging.instance;
    } catch (_) {
      return null;
    }
  }

  Future<void> initialize() async {
    // Initialize Local Notifications
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _localNotifications.initialize(initSettings);

    // Initialize FCM Permissions & Handlers
    if (_fcm != null) {
      try {
        await _fcm.requestPermission(alert: true, badge: true, sound: true);
        final token = await _fcm.getToken();
        // FCM Token registered
        if (token != null) {
          await _fcm.subscribeToTopic('smartpark_alerts');
        }

        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          if (message.notification != null) {
            showLocalNotification(
              title: message.notification!.title ?? 'SmartPark Alert',
              body: message.notification!.body ?? '',
              type: message.data['type'] ?? 'General',
            );
          }
        });
      } catch (_) {}
    }
  }

  /// Trigger instant local notification alert & persist to Firestore
  Future<void> showLocalNotification({
    required String title,
    required String body,
    required String type,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'smartpark_channel',
      'SmartPark Notifications',
      channelDescription: 'Real-time AI and Parking Alerts',
      importance: Importance.high,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);

    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await _localNotifications.show(id, title, body, notificationDetails);

    // Persist in Firestore repository
    final notification = NotificationModel(
      id: 'n_$id',
      userId: 'user_1',
      title: title,
      body: body,
      type: type,
      isRead: false,
      timestamp: DateTime.now(),
    );
    await notificationRepository.addNotification(notification);
  }

  /// Trigger AI Adaptive Reroute Alert
  Future<void> triggerAdaptiveRerouteAlert(String oldPark, String newPark) async {
    await showLocalNotification(
      title: '⚡ AI Adaptive Re-route',
      body: '$oldPark is at full capacity. Rerouted to $newPark (0.4 km closer).',
      type: 'Adaptive',
    );
  }

  /// Trigger Dynamic Pricing Surge Alert
  Future<void> triggerSurgeAlert(String parkingName, double surgeMultiplier) async {
    await showLocalNotification(
      title: '🔥 Dynamic Surge Notice',
      body: '$parkingName demand increased. Surge rate is now ${surgeMultiplier}x.',
      type: 'Surge',
    );
  }
}
