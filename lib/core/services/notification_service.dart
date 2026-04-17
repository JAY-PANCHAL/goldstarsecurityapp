import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationService extends GetxService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<NotificationService> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    try {
      await _plugin.initialize(initSettings);
    } catch (_) {
      // ignore plugin errors in test environments
    }
    return this;
  }

  Future<void> scheduleRoundoff({
    required int id,
    required String title,
    required DateTime scheduledAt,
  }) async {
    // TODO: Replace with scheduled notifications when timezone setup is added.
    final androidDetails = AndroidNotificationDetails(
      'roundoff_channel',
      'Round Off Alerts',
      importance: Importance.high,
      priority: Priority.high,
    );
    await _plugin.show(
      id,
      title,
      title,
      NotificationDetails(android: androidDetails),
    );
  }

  FlutterLocalNotificationsPlugin get plugin => _plugin;
}
