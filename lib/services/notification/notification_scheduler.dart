import 'dart:async';
import 'notification_service.dart';

/// Scheduler for timed reservation reminders and expiry warnings
class NotificationScheduler {
  final NotificationService notificationService;

  NotificationScheduler({required this.notificationService});

  void scheduleReservationReminder(String parkingName, DateTime arrivalTime) {
    final now = DateTime.now();
    final delay = arrivalTime.subtract(const Duration(minutes: 15)).difference(now);

    if (delay.isNegative) {
      // Immediate reminder
      notificationService.showLocalNotification(
        title: '⏰ Reservation Starting Soon',
        body: 'Your slot at $parkingName is reserved in 15 minutes.',
        type: 'Reservation',
      );
    } else {
      Timer(delay, () {
        notificationService.showLocalNotification(
          title: '⏰ Reservation Starting Soon',
          body: 'Your slot at $parkingName is reserved in 15 minutes.',
          type: 'Reservation',
        );
      });
    }
  }

  void scheduleExpiryWarning(String parkingName, DateTime expiryTime) {
    final now = DateTime.now();
    final delay = expiryTime.subtract(const Duration(minutes: 10)).difference(now);

    if (!delay.isNegative) {
      Timer(delay, () {
        notificationService.showLocalNotification(
          title: '⚠️ Parking Expiry Warning',
          body: 'Your reservation at $parkingName expires in 10 minutes. Tap to extend.',
          type: 'Expiry',
        );
      });
    }
  }
}
