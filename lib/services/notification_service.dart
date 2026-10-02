import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _notificationsPlugin.initialize(initSettings);
  }

  static Future<void> showPaymentReminder({
    required int id,
    required String clientName,
    required String invoiceNumber,
    required double amount,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'clear_bill_reminders',
      'Clear Bill Payment Reminders',
      channelDescription: 'Notifications for overdue and pending payment invoices from Clear Bill',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);
    await _notificationsPlugin.show(
      id,
      'Clear Bill - Payment Reminder',
      'Invoice $invoiceNumber for $clientName of ₹$amount is pending/overdue.',
      details,
    );
  }
}
