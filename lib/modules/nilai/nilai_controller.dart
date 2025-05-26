import 'package:get/get.dart';
import 'package:timelyu/data/models/nilai_model.dart';
import 'package:timelyu/data/services/nilai_service.dart';

class NilaiController extends GetxController {
  // Service
  final NilaiService _nilaiService = NilaiService();

  // Observable variables untuk filter
  var selectedTahunAjaran = '2024/2025'.obs; // Contoh nilai awal
  var selectedSemester = 'Genap'.obs;    // Contoh nilai awal

  // Daftar opsi filter (bisa juga diambil dari API jika dinamis)
  final List<String> tahunAjaranList = ['2025/2026','2024/2025', '2023/2024', '2022/2023', '2017/2018']; // Tambahkan 2017/2018 sesuai data API contoh
  final List<String> semesterList = ['Genap', 'Ganjil'];

  // State untuk data, loading, dan error
  var allNilaiList = <NilaiModel>[].obs;         // Menyimpan semua data nilai dari API
  var displayedNilaiList = <NilaiModel>[].obs; // Menyimpan data nilai yang akan ditampilkan setelah filter
  var isLoading = true.obs;
  var errorMessage = RxnString(); // RxnString agar bisa null

  @override
  void onInit() {
    super.onInit();
    fetchNilai(); // Ambil data saat controller diinisialisasi
  }

  // Method untuk mengambil data nilai dari service
  Future<void> fetchNilai() async {
    try {
      isLoading(true);
      errorMessage.value = null; // Reset error message
      final response = await _nilaiService.getNilai();

      if (response.success && response.data != null) {
        allNilaiList.assignAll(response.data!);
        _applyFilters(); // Terapkan filter setelah data berhasil diambil
      } else {
        errorMessage.value = response.message ?? "Gagal mengambil data nilai.";
      }
    } catch (e) {
      print("Error fetching nilai: $e");
      errorMessage.value = "Terjadi kesalahan saat mengambil data: ${e.toString()}";
    } finally {
      isLoading(false);
    }
  }

  void _applyFilters() {
    int? startYear;
    int? endYear;
    if (selectedTahunAjaran.value.isNotEmpty && selectedTahunAjaran.value.contains('/')) {
      final parts = selectedTahunAjaran.value.split('/');
      startYear = int.tryParse(parts[0]);
      endYear = int.tryParse(parts[1]);
    }

    final semester = selectedSemester.value;

    if (startYear == null || endYear == null) {
      // Jika tahun ajaran tidak valid, tampilkan semua (atau kosongkan, sesuai kebutuhan)
      displayedNilaiList.assignAll(allNilaiList.where((nilai) =>
        nilai.semester.toLowerCase() == semester.toLowerCase()
      ).toList());
      return;
    }
    
    // Filter data berdasarkan tahun ajaran dan semester
    displayedNilaiList.assignAll(allNilaiList.where((nilai) {
      bool tahunMatch = (nilai.tahunMulai == startYear && nilai.tahunAkhir == endYear);
      bool semesterMatch = nilai.semester.toLowerCase() == semester.toLowerCase();
      return tahunMatch && semesterMatch;
    }).toList());

    if (displayedNilaiList.isEmpty && allNilaiList.isNotEmpty) {
      // Jika tidak ada data setelah filter, mungkin tampilkan pesan atau biarkan kosong
      // Get.snackbar('Info', 'Tidak ada data nilai untuk filter yang dipilih.');
    }
  }

  // Methods untuk update filter dan terapkan ulang
  void updateTahunAjaran(String value) {
    selectedTahunAjaran.value = value;
    _applyFilters();
  }

  void updateSemester(String value) {
    selectedSemester.value = value;
    _applyFilters();
  }

  // Metode onReady dan onClose bisa tetap ada jika ada penggunaan lain
  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}