// timelyu/modules/nilai/nilai_controller.dart

import 'package:get/get.dart';
import 'package:timelyu/data/models/nilai_model.dart';
import 'package:timelyu/data/services/nilai_service.dart';

class NilaiController extends GetxController {
  final NilaiService _nilaiService = NilaiService();

  var selectedTahunAjaran = '2024/2025'.obs;
  var selectedSemester = 'Genap'.obs;

  final List<String> tahunAjaranList = ['2025/2026', '2024/2025', '2023/2024', '2022/2023', '2017/2018'];
  final List<String> semesterList = ['Genap', 'Ganjil'];

  var allNilaiList = <NilaiModel>[].obs;
  var displayedNilaiList = <NilaiModel>[].obs;
  var isLoading = true.obs;
  var errorMessage = RxnString();
  // Variabel ini sekarang akan menyimpan Rata-Rata Bobot Nilai Semester
  var ipsSemester = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    // Set nilai awal filter agar tidak null jika memungkinkan
    if (tahunAjaranList.isNotEmpty) {
      selectedTahunAjaran.value = tahunAjaranList.first;
    }
    if (semesterList.isNotEmpty) {
      selectedSemester.value = semesterList.first;
    }
    fetchNilai();
  }

  Future<void> fetchNilai() async {
    try {
      isLoading(true);
      errorMessage.value = null;
      final response = await _nilaiService.getNilai();

      if (response.success && response.data != null) {
        allNilaiList.assignAll(response.data!);
        _applyFilters();
      } else {
        errorMessage.value = response.message ?? "Gagal mengambil data nilai.";
        displayedNilaiList.clear();
        _calculateMetric(); // Hitung metrik (akan jadi 0 jika list kosong)
      }
    } catch (e) {
      print("Error fetching nilai: $e");
      errorMessage.value = "Terjadi kesalahan saat mengambil data: ${e.toString()}";
      displayedNilaiList.clear();
      _calculateMetric();
    } finally {
      isLoading(false);
    }
  }

  double _getBobotNilai(String nilaiHuruf) {
    switch (nilaiHuruf.toUpperCase()) {
      case 'A': return 4.0;
      case 'A-': return 3.75; // Sesuaikan dengan skema nilai Anda
      case 'AB': return 3.5;
      case 'B+': return 3.25;
      case 'B': return 3.0;
      case 'B-': return 2.75;
      case 'BC': return 2.5;
      case 'C+': return 2.25;
      case 'C': return 2.0;
      case 'D': return 1.0;
      case 'E': return 0.0;
      default: return 0.0;
    }
  }

  // Menghitung Rata-Rata Bobot Nilai Semester (BUKAN IPS)
  void _calculateMetric() {
    if (displayedNilaiList.isEmpty) {
      ipsSemester.value = 0.0;
      return;
    }

    double totalBobotNilai = 0;
    int jumlahMataKuliah = 0;

    for (var nilaiItem in displayedNilaiList) {
      totalBobotNilai += _getBobotNilai(nilaiItem.nilaiHuruf);
      jumlahMataKuliah++;
    }

    if (jumlahMataKuliah == 0) {
      ipsSemester.value = 0.0;
    } else {
      double rataRataBobot = totalBobotNilai / jumlahMataKuliah;
      ipsSemester.value = double.parse(rataRataBobot.toStringAsFixed(2)).clamp(0.0, 4.0);
    }
     // print("Rata-Rata Bobot Nilai Semester dihitung: ${ipsSemester.value}");
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
      displayedNilaiList.assignAll(allNilaiList.where((nilai) =>
        nilai.semester.toLowerCase() == semester.toLowerCase()
      ).toList());
    } else {
      displayedNilaiList.assignAll(allNilaiList.where((nilai) {
        bool tahunMatch = (nilai.tahunMulai == startYear && nilai.tahunAkhir == endYear);
        bool semesterMatch = nilai.semester.toLowerCase() == semester.toLowerCase();
        return tahunMatch && semesterMatch;
      }).toList());
    }
    _calculateMetric();
  }

  void updateTahunAjaran(String value) {
    if (tahunAjaranList.contains(value)) {
      selectedTahunAjaran.value = value;
      _applyFilters();
    }
  }

  void updateSemester(String value) {
     if (semesterList.contains(value)) {
      selectedSemester.value = value;
      _applyFilters();
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}