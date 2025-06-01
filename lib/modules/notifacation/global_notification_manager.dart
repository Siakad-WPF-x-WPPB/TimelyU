import 'dart:async';
import 'package:timelyu/data/services/schedule_notification_service.dart';
import 'package:timelyu/data/models/schedule_today.dart';

class GlobalNotificationManager {
  static GlobalNotificationManager? _instance;
  static GlobalNotificationManager get instance {
    _instance ??= GlobalNotificationManager._internal();
    return _instance!;
  }

  GlobalNotificationManager._internal();

  Timer? _dailyTimer;
  Timer? _refreshTimer;

  void initialize() {
    _startDailyRefresh();
    _startPeriodicRefresh();
  }

  void _startDailyRefresh() {
    // Refresh notifications every day at midnight
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final durationUntilMidnight = nextMidnight.difference(now);

    _dailyTimer?.cancel();
    _dailyTimer = Timer(durationUntilMidnight, () {
      _refreshNotifications();
      _startDailyRefresh(); // Restart for next day
    });
  }

  void _startPeriodicRefresh() {
    // Refresh notifications every 15 minutes to handle schedule changes
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(Duration(minutes: 15), (timer) {
      _refreshNotifications();
    });
  }

  Future<void> _refreshNotifications() async {
    try {
      await ScheduleNotificationService.refreshNotifications();
      print('Notifications refreshed at ${DateTime.now()}');
    } catch (e) {
      print('Error refreshing notifications: $e');
    }
  }

  Future<void> updateSchedulesAndNotifications(
    List<ScheduleToday> schedules,
  ) async {
    await ScheduleNotificationService.saveSchedules(schedules);
  }

  void dispose() {
    _dailyTimer?.cancel();
    _refreshTimer?.cancel();
  }
}
