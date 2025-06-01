import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize timezone
      tz.initializeTimeZones();

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      const InitializationSettings initializationSettings =
          InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
          );

      final bool? initialized = await _notificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      if (initialized == true) {
        await _requestPermissions();
        _isInitialized = true;
        if (kDebugMode) {
          print('NotificationService initialized successfully');
        }
      } else {
        if (kDebugMode) {
          print('Failed to initialize NotificationService');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing NotificationService: $e');
      }
    }
  }

  static Future<void> _requestPermissions() async {
    try {
      if (await Permission.notification.isDenied) {
        final status = await Permission.notification.request();
        if (kDebugMode) {
          print('Notification permission status: $status');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error requesting notification permissions: $e');
      }
    }
  }

  static void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      print('Notification tapped: ${response.payload}');
    }
  }

  static Future<void> scheduleClassNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'class_reminder_channel',
            'Class Reminders',
            channelDescription: 'Notifications for upcoming classes',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            enableVibration: true,
            playSound: true,
          );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        notificationDetails,
        payload: payload,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      if (kDebugMode) {
        print('Notification scheduled for: $scheduledTime with ID: $id');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error scheduling notification: $e');
      }
    }
  }

  static Future<void> cancelNotification(int id) async {
    if (!_isInitialized) return;

    try {
      await _notificationsPlugin.cancel(id);
      if (kDebugMode) {
        print('Notification cancelled with ID: $id');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error cancelling notification: $e');
      }
    }
  }

  static Future<void> cancelAllNotifications() async {
    if (!_isInitialized) return;

    try {
      await _notificationsPlugin.cancelAll();
      if (kDebugMode) {
        print('All notifications cancelled');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error cancelling all notifications: $e');
      }
    }
  }

  static Future<List<PendingNotificationRequest>>
  getPendingNotifications() async {
    if (!_isInitialized) return [];

    try {
      final pending = await _notificationsPlugin.pendingNotificationRequests();
      if (kDebugMode) {
        print('Pending notifications: ${pending.length}');
      }
      return pending;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting pending notifications: $e');
      }
      return [];
    }
  }

  static Future<void> createNotificationChannel() async {
    if (!_isInitialized) return;

    try {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'class_reminder_channel',
        'Class Reminders',
        description: 'Notifications for upcoming classes',
        importance: Importance.high,
        enableVibration: true,
        playSound: true,
      );

      final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
          _notificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      if (androidPlugin != null) {
        await androidPlugin.createNotificationChannel(channel);
        if (kDebugMode) {
          print('Notification channel created');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating notification channel: $e');
      }
    }
  }
}
