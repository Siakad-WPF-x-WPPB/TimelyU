// lib/modules/schedule/full_schedule_controller.dart
import 'package:get/get.dart';
import 'package:timelyu/data/models/schedule.dart';
import 'package:timelyu/data/client/api_client.dart';
import 'package:timelyu/data/services/schedule_service.dart';

class FullScheduleController extends GetxController {
  final ScheduleService _scheduleService = ScheduleService(); // Instantiate the service

  var isLoading = true.obs;
  var errorMessage = ''.obs;

  // Days for display order
  var days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'].obs; // Added Minggu just in case

  // Schedule data: Key is day name (String), Value is List of schedule items
  var scheduleData = <String, List<Map<String, dynamic>>>{}.obs;

  // Data for header dropdowns (or static display)
  var tahunAjarDisplay = ''.obs;
  var semesterDisplay = ''.obs;

  // Selected day logic (kept from original, may not be used by FullScheduleView directly)
  var selectedDayIndex = 0.obs;
  String get selectedDayString => days[selectedDayIndex.value];
  List<Map<String, dynamic>> get todayScheduleFromSelection => scheduleData[selectedDayString] ?? [];

  void selectDay(int index) {
    if (index >= 0 && index < days.length) {
      selectedDayIndex.value = index;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchFullSchedule();
  }

  Future<void> fetchFullSchedule() async {
    try {
      isLoading(true);
      errorMessage('');
      scheduleData.clear(); // Clear previous data

      ApiResponse<MyFrsResponseModel> apiResponse = await _scheduleService.getMyFrs();

      if (apiResponse.success && apiResponse.data != null) {
        MyFrsResponseModel frsResponse = apiResponse.data!;

        // Populate header info
        if (frsResponse.tahunAjar != null) {
          tahunAjarDisplay.value = frsResponse.tahunAjar!.displayName.split(' ').last; // "2024/2025"
          semesterDisplay.value = frsResponse.tahunAjar!.semester; // "Genap"
        } else if (frsResponse.data?.tahunAjar != null) {
          // Fallback if root tahunAjar is null but nested one exists
          tahunAjarDisplay.value = "${frsResponse.data!.tahunAjar.tahunMulai}/${frsResponse.data!.tahunAjar.tahunAkhir}";
          semesterDisplay.value = frsResponse.data!.tahunAjar.semester;
        }
        
        // Initialize scheduleData with empty lists for all displayable days
        for (String day in days) {
           scheduleData[day] = [];
        }

        // Transform and populate schedule data
        if (frsResponse.data?.details != null) {
          for (var detail in frsResponse.data!.details) {
            // Only include approved schedules
            if (detail.status.toLowerCase() == 'disetujui') {
              JadwalModel jadwal = detail.jadwal;
              String dayKey = _normalizeDayName(jadwal.hari);

              // Ensure the day key exists in our map
              if (!scheduleData.containsKey(dayKey)) {
                scheduleData[dayKey] = [];
              }
              
              scheduleData[dayKey]!.add({
                'waktu': jadwal.jamMulai.substring(0, 5), // HH:MM
                'mataKuliah': jadwal.matakuliah.nama,
                'pengajar': jadwal.dosen.nama,
                'jamKuliah': '${jadwal.jamMulai.substring(0, 5)} - ${jadwal.jamSelesai.substring(0, 5)}',
                'lokasi': jadwal.ruangan.kode, // Or jadwal.ruangan.nama
                // 'cardColor' will be handled by the view's switch statement
              });
            }
          }
          // Sort schedules by start time for each day
          scheduleData.forEach((day, schedules) {
            schedules.sort((a, b) => (a['waktu'] as String).compareTo(b['waktu'] as String));
          });
        }
         // Trigger update for the observable map
        scheduleData.refresh();

      } else {
        errorMessage(apiResponse.message ?? 'Gagal memuat jadwal.');
      }
    } catch (e) {
      print('Error in fetchFullSchedule: $e');
      errorMessage('Terjadi kesalahan: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  String _normalizeDayName(String apiDayName) {
    // API: "Jumat", "Rabu", "Selasa"
    // Controller days: "Senin", "Selasa", ...
    // This assumes API day names match the controller's day names in terms of capitalization and spelling.
    // If not, add mapping logic here.
    // For example, if API returns "senin" but controller uses "Senin":
    // if (apiDayName.toLowerCase() == 'senin') return 'Senin';
    return apiDayName;
  }

  @override
  void onClose() {
    super.onClose();
  }
}