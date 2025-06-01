import 'package:get/get.dart';
import 'package:timelyu/data/models/schedule.dart';
import 'package:timelyu/data/client/api_client.dart';
import 'package:timelyu/data/services/schedule_service.dart';

class FullScheduleController extends GetxController {
  final ScheduleService _scheduleService = ScheduleService();

  var isLoading = true.obs;
  var errorMessage = ''.obs;

  var days =
      ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'].obs;
  var scheduleData = <String, List<Map<String, dynamic>>>{}.obs;

  var tahunAjarDisplay = ''.obs;
  var semesterDisplay = ''.obs;

  var selectedDayIndex = 0.obs;
  String get selectedDayString => days[selectedDayIndex.value];
  List<Map<String, dynamic>> get todayScheduleFromSelection =>
      scheduleData[selectedDayString] ?? [];

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
      print('=== Starting fetchFullSchedule ===');
      isLoading(true);
      errorMessage('');
      scheduleData.clear();

      // Initialize scheduleData with empty lists for all displayable days
      for (String day in days) {
        scheduleData[day] = [];
      }

      ApiResponse<MyFrsResponseModel> apiResponse =
          await _scheduleService.getMyFrs();
      print('API Response received - Success: ${apiResponse.success}');

      if (apiResponse.success && apiResponse.data != null) {
        MyFrsResponseModel frsResponse = apiResponse.data!;
        print('Processing FRS Response...');

        // Safely populate header info
        try {
          if (frsResponse.tahunAjar != null) {
            print('TahunAjar found at root level');
            final displayNameParts = frsResponse.tahunAjar!.displayName.split(
              ' ',
            );
            tahunAjarDisplay.value =
                displayNameParts.isNotEmpty ? displayNameParts.last : 'N/A';
            semesterDisplay.value = frsResponse.tahunAjar!.semester ?? 'N/A';
          } else if (frsResponse.data?.tahunAjar != null) {
            print('TahunAjar found at data level');
            final tahunAjar = frsResponse.data!.tahunAjar;
            tahunAjarDisplay.value =
                "${tahunAjar.tahunMulai ?? 'N/A'}/${tahunAjar.tahunAkhir ?? 'N/A'}";
            semesterDisplay.value = tahunAjar.semester ?? 'N/A';
          } else {
            print('No TahunAjar found, using defaults');
            tahunAjarDisplay.value = 'N/A';
            semesterDisplay.value = 'N/A';
          }

          print(
            'Header info - Tahun: ${tahunAjarDisplay.value}, Semester: ${semesterDisplay.value}',
          );
        } catch (e) {
          print('Error processing header info: $e');
          tahunAjarDisplay.value = 'Error';
          semesterDisplay.value = 'Error';
        }

        // Safely transform and populate schedule data
        try {
          if (frsResponse.data?.details != null) {
            print('Processing ${frsResponse.data!.details.length} details');

            for (int i = 0; i < frsResponse.data!.details.length; i++) {
              try {
                final detail = frsResponse.data!.details[i];
                print('Processing detail $i - Status: ${detail.status}');

                // Only include approved schedules
                if (detail.status.toLowerCase() == 'disetujui') {
                  final jadwal = detail.jadwal;
                  print(
                    'Processing approved schedule: ${jadwal.matakuliah.nama}',
                  );

                  String dayKey = _normalizeDayName(jadwal.hari ?? 'Unknown');
                  print('Day key: $dayKey');

                  // Ensure the day key exists in our map
                  if (!scheduleData.containsKey(dayKey)) {
                    scheduleData[dayKey] = [];
                  }

                  // Safely extract time components
                  String jamMulai = 'N/A';
                  String jamSelesai = 'N/A';

                  try {
                    jamMulai =
                        jadwal.jamMulai?.isNotEmpty == true
                            ? jadwal.jamMulai!.substring(
                              0,
                              jadwal.jamMulai!.length >= 5
                                  ? 5
                                  : jadwal.jamMulai!.length,
                            )
                            : 'N/A';
                  } catch (e) {
                    print('Error processing jamMulai: $e');
                  }

                  try {
                    jamSelesai =
                        jadwal.jamSelesai?.isNotEmpty == true
                            ? jadwal.jamSelesai!.substring(
                              0,
                              jadwal.jamSelesai!.length >= 5
                                  ? 5
                                  : jadwal.jamSelesai!.length,
                            )
                            : 'N/A';
                  } catch (e) {
                    print('Error processing jamSelesai: $e');
                  }

                  scheduleData[dayKey]!.add({
                    'waktu': jamMulai,
                    'mataKuliah': jadwal.matakuliah.nama ?? 'N/A',
                    'pengajar': jadwal.dosen.nama ?? 'N/A',
                    'jamKuliah': '$jamMulai - $jamSelesai',
                    'lokasi': jadwal.ruangan.kode ?? 'N/A',
                  });

                  print(
                    'Added schedule for $dayKey: ${jadwal.matakuliah.nama}',
                  );
                }
              } catch (e) {
                print('Error processing detail $i: $e');
                continue; // Skip this detail and continue with others
              }
            }

            // Sort schedules by start time for each day
            scheduleData.forEach((day, schedules) {
              try {
                schedules.sort(
                  (a, b) =>
                      (a['waktu'] as String).compareTo(b['waktu'] as String),
                );
              } catch (e) {
                print('Error sorting schedules for $day: $e');
              }
            });

            print('Schedule processing completed');
          } else {
            print('No details found in response');
          }
        } catch (e) {
          print('Error processing schedule data: $e');
          errorMessage('Error processing schedule data: ${e.toString()}');
        }

        // Trigger update for the observable map
        scheduleData.refresh();

        print('Schedule data updated with ${scheduleData.length} days');
      } else {
        final message = apiResponse.message ?? 'Gagal memuat jadwal.';
        print('API call failed: $message');
        errorMessage(message);
      }
    } catch (e, stackTrace) {
      print('Error in fetchFullSchedule: $e');
      print('Stack trace: $stackTrace');
      errorMessage('Terjadi kesalahan: ${e.toString()}');
    } finally {
      isLoading(false);
      print('=== fetchFullSchedule completed ===');
    }
  }

  String _normalizeDayName(String apiDayName) {
    // Add mapping if needed
    switch (apiDayName.toLowerCase()) {
      case 'senin':
        return 'Senin';
      case 'selasa':
        return 'Selasa';
      case 'rabu':
        return 'Rabu';
      case 'kamis':
        return 'Kamis';
      case 'jumat':
        return 'Jumat';
      case 'sabtu':
        return 'Sabtu';
      case 'minggu':
        return 'Minggu';
      default:
        return apiDayName;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
