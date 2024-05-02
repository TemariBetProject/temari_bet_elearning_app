import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> init() async {
    tz.initializeTimeZones(); // Make sure this is called to load timezone data
    tz.setLocalLocation(
        tz.getLocation('Africa/Nairobi')); // Set to East Africa Time

    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'task_channel', // ID of the notification channel
        'Task Notifications', // Name of the notification channel
        description: 'Notification channel for task reminders',
        importance: Importance.high,
        playSound: true);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    print("Notification channel created and timezone set to Africa/Nairobi.");
  }

  Future selectNotification(String? payload) async {
    print("Notification Tapped with payload: $payload");
  }

  Future<void> scheduleTaskNotification(
      String taskName, DateTime scheduledDate) async {
    tz.TZDateTime scheduleNotificationDateTime =
        tz.TZDateTime.from(scheduledDate, tz.local);
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          taskName.hashCode,
          'Task Reminder',
          'Reminder: You have a $taskName on ${scheduledDate.day}/${scheduledDate.month}/${scheduledDate.year}',
          scheduleNotificationDateTime,
          NotificationDetails(
              android: AndroidNotificationDetails(
                  'task_channel', // Ensure this matches your channel ID
                  'Task Notifications',
                  channelDescription: 'Notification channel for task reminders',
                  importance: Importance.high,
                  priority: Priority.high,
                  icon: '@mipmap/ic_launcher')),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time);
      print(
          "Notification scheduled for $taskName at $scheduleNotificationDateTime");
    } catch (e) {
      print("Failed to schedule notification: $e");
    }
  }
}
