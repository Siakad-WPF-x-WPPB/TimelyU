import 'package:get/get.dart';
import 'package:timelyu/data/client/api_client.dart';
import 'package:timelyu/data/models/jadwal_besok_model.dart';
import 'package:timelyu/data/services/schedule_service.dart';

class JadwalBesokController extends GetxController {
  final ScheduleService _scheduleService = ScheduleService();

  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var jadwalBesokList = <Map<String, dynamic>>[].obs;
  var scheduleDayTitle = 'Jadwal Besok'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchJadwalBesok();
  }

  Future<void> fetchJadwalBesok() async {
    try {
      isLoading(true);
      errorMessage('');
      jadwalBesokList.clear();

      ApiResponse<JadwalBesokListData> apiResponse = // ⬅️ Tipe diubah
          await _scheduleService.getTomorrowSchedule();

      print('--- DEBUG JADWAL BESOK (CONTROLLER) ---');
      print('API Response Success: ${apiResponse.success}');
      print('API Response Message: ${apiResponse.message}');
      // ... (print lainnya untuk debug jika perlu)

      if (apiResponse.success && apiResponse.data != null) {
        // apiResponse.data sekarang adalah instance JadwalBesokListData
        JadwalBesokListData listData = apiResponse.data!;
        List<JadwalBesokModel> scheduleItems = listData.data; // ⬅️ Akses list dari sini

        if (scheduleItems.isNotEmpty) {
          // scheduleDayTitle.value = scheduleItems.first.hari; // Opsional update judul

          var transformedSchedules = scheduleItems.map((item) {
            return {
              'id': item.id,
              'hari': item.hari,
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
          
          jadwalBesokList.assignAll(transformedSchedules);
          errorMessage('');
        } else {
          errorMessage(apiResponse.message ?? 'Tidak ada jadwal untuk besok.');
          jadwalBesokList.clear();
        }
      } else {
        errorMessage(apiResponse.message ?? 'Gagal memuat jadwal besok.');
        jadwalBesokList.clear();
      }
    } catch (e) {
      print('Error in fetchJadwalBesok (Controller): $e');
      errorMessage('Terjadi kesalahan: ${e.toString()}');
      jadwalBesokList.clear();
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}