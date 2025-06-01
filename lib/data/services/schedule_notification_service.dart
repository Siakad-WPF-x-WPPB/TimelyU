import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:timelyu/data/models/schedule_today.dart';
import 'package:timelyu/modules/notifacation/notification_service.dart';

class ScheduleNotificationService {
  static const String _schedulesKey = 'today_schedules';

  static Future<void> saveSchedules(List<ScheduleToday> schedules) async {
    final prefs = await SharedPreferences.getInstance();
    final schedulesJson = schedules.map((s) => s.toJson()).toList();
    await prefs.setString(_schedulesKey, jsonEncode(schedulesJson));

    // Always schedule notifications for today's classes
    await _scheduleAllNotifications(schedules);
  }

  static Future<List<ScheduleToday>> getSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final schedulesJson = prefs.getString(_schedulesKey);

    if (schedulesJson == null) return [];

    final List<dynamic> decoded = jsonDecode(schedulesJson);
    return decoded.map((json) => ScheduleToday.fromJson(json)).toList();
  }

  static Future<void> _scheduleAllNotifications(
    List<ScheduleToday> schedules,
  ) async {
    // Cancel existing notifications
    await NotificationService.cancelAllNotifications();

    final now = DateTime.now();
    final today = _getDayName(now.weekday);

    // Filter schedules for today
    final todaySchedules =
        schedules
            .where(
              (schedule) => schedule.hari.toLowerCase() == today.toLowerCase(),
            )
            .toList();

    for (final schedule in todaySchedules) {
      if (schedule.canScheduleNotification) {
        await NotificationService.scheduleClassNotification(
          id: schedule.notificationId,
          title: 'Kelas akan dimulai dalam 30 menit',
          body:
              '${schedule.matakuliah} di ${schedule.ruang}\nDosen: ${schedule.dosen}',
          scheduledTime: schedule.notificationTime,
          payload: jsonEncode(schedule.toJson()),
        );
      }
    }
  }

  static String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Senin';
      case 2:
        return 'Selasa';
      case 3:
        return 'Rabu';
      case 4:
        return 'Kamis';
      case 5:
        return 'Jumat';
      case 6:
        return 'Sabtu';
      case 7:
        return 'Minggu';
      default:
        return '';
    }
  }

  static Future<void> scheduleNotificationForSchedule(
    ScheduleToday schedule,
  ) async {
    if (!schedule.canScheduleNotification) return;

    await NotificationService.scheduleClassNotification(
      id: schedule.notificationId,
      title: 'Kelas akan dimulai dalam 30 menit',
      body:
          '${schedule.matakuliah} di ${schedule.ruang}\nDosen: ${schedule.dosen}',
      scheduledTime: schedule.notificationTime,
      payload: jsonEncode(schedule.toJson()),
    );
  }

  static Future<void> refreshNotifications() async {
    final schedules = await getSchedules();
    await _scheduleAllNotifications(schedules);
  }

  static Future<List<PendingNotificationRequest>>
  getPendingNotifications() async {
    return await NotificationService.getPendingNotifications();
  }
}
