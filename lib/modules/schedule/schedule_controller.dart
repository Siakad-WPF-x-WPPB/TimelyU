import 'package:get/get.dart';
import 'package:timelyu/data/models/schedule_today.dart';
import 'package:timelyu/data/services/schedule_notification_service.dart';
import 'package:timelyu/data/client/api_client.dart';

class ScheduleController extends GetxController {
  final BaseApiService _apiService = BaseApiService();

  var isLoading = true.obs;
  var schedules = <ScheduleToday>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTodaySchedule();

    // Auto-refresh setiap 30 menit
    ever(schedules, (_) {
      _updateNotifications();
    });
  }

  Future<void> fetchTodaySchedule() async {
    try {
      isLoading(true);
      errorMessage('');

      final response = await _apiService.getTodaySchedule();

      if (response.success && response.data != null) {
        schedules.value = response.data!.data;
        // Auto-schedule notifications
        await _updateNotifications();
      } else {
        errorMessage(response.message ?? 'Gagal memuat jadwal');
      }
    } catch (e) {
      errorMessage('Terjadi kesalahan: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> _updateNotifications() async {
    if (schedules.isNotEmpty) {
      await ScheduleNotificationService.saveSchedules(schedules);
    }
  }

  Future<void> refreshSchedule() async {
    await fetchTodaySchedule();
  }
}
