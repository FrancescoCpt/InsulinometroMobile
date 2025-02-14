import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Inizializza il servizio di notifica
  static Future<void> initialize() async {
    tz.initializeTimeZones(); // Inizializza i fusi orari per le notifiche pianificate

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher'); // Icona della notifica

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  // Mostra una notifica programmata
  static Future<void> showScheduledNotification({
    required int id,
    required String title,
    required String body,
    required int seconds,
  }) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'insulin_reminder_channel', // ID del canale
      'Insulin Reminder', // Nome del canale
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _scheduleTime(seconds),
      platformChannelSpecifics,
      androidAllowWhileIdle: true, // Consente la notifica anche in modalità Doze
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Calcola il tempo per la notifica programmata
  static tz.TZDateTime _scheduleTime(int seconds) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledTime = now.add(Duration(seconds: seconds));
    return scheduledTime;
  }
}