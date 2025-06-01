// lib/modules/home/pengumuman_controller.dart

import 'package:get/get.dart';
import 'package:timelyu/data/client/api_client.dart';
import 'package:timelyu/data/models/pengumuman_model.dart';
import 'package:timelyu/data/services/pengumuman_service.dart';

class PengumumanController extends GetxController {
  final PengumumanService _pengumumanService = Get.find<PengumumanService>();

  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var pengumumanList = <PengumumanItemModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    fetchPengumuman();
  }

  Future<void> fetchPengumuman() async {
    try {
      isLoading(true);
      errorMessage('');
      pengumumanList.clear();

      ApiResponse<PengumumanResponseModel> apiResponse =
          await _pengumumanService.getPengumuman();

      if (apiResponse.success && apiResponse.data != null) {
        PengumumanResponseModel responseData = apiResponse.data!;
        pengumumanList.assignAll(responseData.data);
        if (responseData.data.isEmpty) {
          errorMessage('Tidak ada pengumuman saat ini.');
        } else {
          errorMessage(''); // Clear error jika ada data
        }

      } else {
        errorMessage(apiResponse.message ?? 'Gagal memuat pengumuman.');
        pengumumanList.clear();
      }
    } catch (e) {
      print('Error in PengumumanController - fetchPengumuman: $e');
      errorMessage('Terjadi kesalahan: ${e.toString()}');
      pengumumanList.clear();
    } finally {
      isLoading(false);
    }
  }
}