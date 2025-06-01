import 'package:get/get.dart';
import 'package:timelyu/data/client/api_client.dart'; // Untuk ApiResponse
import 'package:timelyu/data/models/schedule_today.dart';
import 'package:timelyu/data/services/schedule_service.dart'; // Sesuaikan path

class ScheduleTodayController extends GetxController {
  final ScheduleService _scheduleService = ScheduleService();

  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var todaySchedule = <Map<String, dynamic>>[].obs; // Untuk ditampilkan di view
  var currentDayDisplay = 'Hari Ini'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTodaySchedule();
  }

  Future<void> fetchTodaySchedule() async {
    try {
      isLoading(true);
      errorMessage('');
      todaySchedule.clear();

      // Tipe generic di ApiResponse sekarang adalah ScheduleListData
      ApiResponse<ScheduleListData> apiResponse =
          await _scheduleService.getJadwalHariIni();
      
      print('--- DEBUG JADWAL HARI INI (CONTROLLER) ---');
      print('API Response Success: ${apiResponse.success}');
      print('API Response Message: ${apiResponse.message}');
      print('API Response Data Exists: ${apiResponse.data != null}');
      if(apiResponse.data != null) {
        print('API Response Data Items Count: ${apiResponse.data!.data.length}');
      }
      print('-----------------------------------------');


      // apiResponse.success sekarang didasarkan pada HTTP status dari service
      if (apiResponse.success && apiResponse.data != null) {
        ScheduleListData scheduleListData = apiResponse.data!;
        List<ScheduleToday> scheduleItems = scheduleListData.data; // Langsung akses list jadwal

        if (scheduleItems.isNotEmpty) {
          var transformedSchedules = scheduleItems.map((item) {
            return {
              'id': item.id,
              'waktu': item.jamMulai.substring(0, 5),
              'jamMulai': item.jamMulai.substring(0, 5),
              'jamSelesai': item.jamSelesai.substring(0, 5),
              'mataKuliah': item.matakuliah,
              'dosen': item.dosen,
              'kelas': item.kelas,
              'jamKuliah': '${item.jamMulai.substring(0, 5)} - ${item.jamSelesai.substring(0, 5)}',
              'ruang': item.ruang,
            };
          }).toList();

          transformedSchedules.sort((a, b) => (a['waktu'] as String).compareTo(b['waktu'] as String));
          
          todaySchedule.assignAll(transformedSchedules);
          errorMessage(''); // Kosongkan pesan error jika berhasil
        } else {
          // Berhasil fetch, tapi tidak ada jadwal (list kosong)
          errorMessage(apiResponse.message ?? 'Tidak ada jadwal untuk hari ini.');
          todaySchedule.clear();
        }
      } else {
        // Gagal dari ApiResponse (apiResponse.success = false atau apiResponse.data = null)
        errorMessage(apiResponse.message ?? 'Gagal memuat jadwal hari ini.');
        todaySchedule.clear();
      }
    } catch (e) {
      print('Error in fetchTodaySchedule (Controller): $e');
      errorMessage('Terjadi kesalahan: ${e.toString()}');
      todaySchedule.clear();
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}