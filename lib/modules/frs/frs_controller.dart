import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelyu/data/models/frs_model.dart';
// Pastikan nama file model jadwal sudah benar (jadwal_matakuliah_model.dart)
import 'package:timelyu/data/models/jadwal_matkul.model.dart'; 
import 'package:timelyu/data/services/frs_service.dart';

class FrsController extends GetxController {
  late final FrsService _frsService;

  // --- State untuk Menampilkan FRS yang Sudah Ada ---
  final isLoadingFrs = false.obs;
  final frsList = <FrsModel>[].obs;

  // --- State untuk Pemilihan Jadwal FRS Baru ---
  final isLoadingJadwalPilihan = false.obs;
  // _rawJadwalPilihanList menyimpan data asli dari API sebelum difilter lebih lanjut
  final RxList<JadwalMatakuliahModel> _rawJadwalPilihanList = <JadwalMatakuliahModel>[].obs;
  // jadwalPilihanList adalah yang akan diobservasi oleh UI, berisi data yang sudah difilter
  final jadwalPilihanList = <JadwalMatakuliahModel>[].obs; 
  final selectedJadwalUntukPengajuan = <JadwalMatakuliahModel>[].obs;
  final isStoringFrs = false.obs;
  final RxString searchQuery = ''.obs;
  // Menyimpan idJadwalAsal dari FRS yang sudah diambil (status pending/approved) pada periode terpilih
  final RxList<String> _idsJadwalFrsDiambilPadaPeriodeIni = <String>[].obs; 

  // --- State Umum & Filter ---
  final selectedTahunAjar = Rxn<String>(); // Format "YYYY/YYYY"
  final selectedSemester = Rxn<String>();
  // Pastikan tahunAjarItems dan semesterItems diisi dengan data yang relevan
  final tahunAjarItems = <String>['2025/2026','2024/2025', '2023/2024', '2022/2023', '2021/2022','2020/2021', '2019/2020'].obs;
  final semesterItems = <String>['Genap', 'Ganjil'].obs;

  // --- Info Tambahan Mahasiswa (Contoh) ---
  final dosenWali = 'Dr. S.Kom Jakobowo, M.Kom'.obs; // Contoh data
  final tanggalPengisian = ''.obs; // Bisa diisi dari data profil atau tanggal saat ini

  // Helper untuk parsing tahun ajar di controller
  int? _getStartYearFromTahunAjarString(String? tahunAjarStr) {
    if (tahunAjarStr == null) return null;
    try {
      List<String> parts = tahunAjarStr.split('/');
      if (parts.length == 2) {
        return int.parse(parts[0]);
      }
    } catch (e) {
      print("Error parsing tahun ajar string in controller '$tahunAjarStr': $e");
    }
    return null;
  }

  // Getter untuk list jadwal yang sudah difilter berdasarkan pencarian DAN FRS yang sudah diambil
  List<JadwalMatakuliahModel> get filteredJadwalPilihanList {
    // 1. Filter berdasarkan FRS yang sudah diambil pada periode ini
    List<JadwalMatakuliahModel> listSetelahFilterFrs = _rawJadwalPilihanList.where((jadwal) {
      return !_idsJadwalFrsDiambilPadaPeriodeIni.contains(jadwal.idJadwal);
    }).toList();

    // 2. Filter berdasarkan query pencarian
    if (searchQuery.value.isEmpty) {
      return listSetelahFilterFrs;
    }
    return listSetelahFilterFrs.where((jadwal) {
      final query = searchQuery.value.toLowerCase();
      // Pencarian berdasarkan nama mata kuliah dan nama dosen
      return jadwal.namaMatakuliah.toLowerCase().contains(query) ||
             jadwal.namaDosen.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _initializeService();
    _loadInitialData(); // Memuat data awal saat controller diinisialisasi
  }

  void _initializeService() {
    _frsService = Get.put(FrsService()); 
  }

  void _loadInitialData() {
    if (tahunAjarItems.isNotEmpty && selectedTahunAjar.value == null) {
      selectedTahunAjar.value = tahunAjarItems.first;
    }
    if (semesterItems.isNotEmpty && selectedSemester.value == null) {
      selectedSemester.value = semesterItems.first;
    }
    _refreshData();
  }

  Future<void> _refreshData() async {
    if (selectedTahunAjar.value != null && selectedSemester.value != null) {
      await fetchFrsData(); 
      await fetchJadwalPilihan(); 
    } else {
      frsList.clear(); 
      _rawJadwalPilihanList.clear();
      jadwalPilihanList.clear();
      selectedJadwalUntukPengajuan.clear();
      _idsJadwalFrsDiambilPadaPeriodeIni.clear();
    }
  }

  Future<void> fetchFrsData() async {
    if (selectedTahunAjar.value == null || selectedSemester.value == null) {
      frsList.clear();
      _idsJadwalFrsDiambilPadaPeriodeIni.clear();
      return;
    }
    
    isLoadingFrs.value = true;
    try {
      final apiResponse = await _frsService.getFrsData(
        tahunAjar: selectedTahunAjar.value!,
        semester: selectedSemester.value!,
      );
      
      if (apiResponse.success && apiResponse.data != null) {
        frsList.assignAll(apiResponse.data!);
        
        final int? currentStartYear = _getStartYearFromTahunAjarString(selectedTahunAjar.value);
        final String? currentSemester = selectedSemester.value?.toLowerCase();

        if (currentStartYear != null && currentSemester != null) {
          _idsJadwalFrsDiambilPadaPeriodeIni.assignAll(
            frsList
                .where((frs) => 
                    (frs.status.toLowerCase() == 'pending' || 
                     frs.status.toLowerCase() == 'approved' || 
                     frs.status.toLowerCase() == 'disetujui') &&
                    frs.idJadwalAsal != null && frs.idJadwalAsal!.isNotEmpty &&
                    frs.tahunAjar == currentStartYear && // Perbandingan dengan tahunAjar yang diparsing
                    frs.semester.toLowerCase() == currentSemester
                )
                .map((frs) => frs.idJadwalAsal!)
                .toSet() 
                .toList()
          );
        } else {
          _idsJadwalFrsDiambilPadaPeriodeIni.clear();
        }
      } else {
        frsList.clear();
        _idsJadwalFrsDiambilPadaPeriodeIni.clear();
      }
    } catch (e) {
      frsList.clear();
      _idsJadwalFrsDiambilPadaPeriodeIni.clear();
      print("Controller Exception in fetchFrsData: $e");
    } finally {
      isLoadingFrs.value = false;
      _updateFilteredJadwalList();
    }
  }

  Future<void> fetchJadwalPilihan() async {
    if (selectedTahunAjar.value == null || selectedSemester.value == null) {
      _rawJadwalPilihanList.clear();
      jadwalPilihanList.clear();
      return;
    }

    isLoadingJadwalPilihan.value = true;
    try {
      final apiResponse = await _frsService.getJadwalPilihan(
        tahunAjar: selectedTahunAjar.value!,
        semester: selectedSemester.value!,
      );

      if (apiResponse.success && apiResponse.data != null) {
        _rawJadwalPilihanList.assignAll(apiResponse.data!);
        _updateFilteredJadwalList(); 
      } else {
        _rawJadwalPilihanList.clear();
        jadwalPilihanList.clear();
         Get.snackbar(
          'Error Memuat Jadwal',
          apiResponse.message ?? 'Terjadi kesalahan saat memuat jadwal pilihan.',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange, colorText: Colors.white,
        );
      }
    } catch (e) {
      _rawJadwalPilihanList.clear();
      jadwalPilihanList.clear();
      print("Controller Exception in fetchJadwalPilihan: $e");
      Get.snackbar('Error Kritis Jadwal', 'Terjadi pengecualian: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange, colorText: Colors.white);
    } finally {
      isLoadingJadwalPilihan.value = false;
    }
  }
  
  void _updateFilteredJadwalList() {
    jadwalPilihanList.assignAll(filteredJadwalPilihanList);
  }

  void onTahunAjarChanged(String? value) {
    if (value != null && selectedTahunAjar.value != value) {
      selectedTahunAjar.value = value;
      selectedJadwalUntukPengajuan.clear(); 
      searchQuery.value = ''; 
      _refreshData(); 
    }
  }

  void onSemesterChanged(String? value) {
    if (value != null && selectedSemester.value != value) {
      selectedSemester.value = value;
      selectedJadwalUntukPengajuan.clear(); 
      searchQuery.value = ''; 
      _refreshData(); 
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    _updateFilteredJadwalList(); 
  }

  void toggleJadwalSelection(JadwalMatakuliahModel jadwalItem) {
    final isSelected = selectedJadwalUntukPengajuan.any((item) => item.idJadwal == jadwalItem.idJadwal);

    if (isSelected) {
      selectedJadwalUntukPengajuan.removeWhere((item) => item.idJadwal == jadwalItem.idJadwal);
    } else {
      selectedJadwalUntukPengajuan.add(jadwalItem);
    }
  }

  bool isJadwalSelected(JadwalMatakuliahModel jadwalItem) {
    return selectedJadwalUntukPengajuan.any((item) => item.idJadwal == jadwalItem.idJadwal);
  }

  Future<void> storeSelectedFrs() async {
    if (selectedJadwalUntukPengajuan.isEmpty) {
      Get.snackbar('Belum Ada Pilihan', 'Silakan pilih minimal satu mata kuliah untuk diajukan.',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    if (selectedTahunAjar.value == null || selectedSemester.value == null) {
      Get.snackbar('Periode Belum Lengkap', 'Pastikan Tahun Ajar dan Semester sudah dipilih.',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    Get.defaultDialog(
      title: "Konfirmasi Pengajuan FRS",
      titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      middleText: "Anda akan mengajukan ${selectedJadwalUntukPengajuan.length} mata kuliah untuk periode ${selectedTahunAjar.value} Semester ${selectedSemester.value}. Lanjutkan?",
      textConfirm: "Ya, Ajukan",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Get.theme.primaryColor, 
      onConfirm: () async {
        Get.back(); 
        await _executeStoreFrs();
      }
    );
  }
  
  Future<void> _executeStoreFrs() async {
    isStoringFrs.value = true;
     Get.dialog( 
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final List<String> idJadwalDipilih = selectedJadwalUntukPengajuan.map((item) => item.idJadwal).toList();
      
      final apiResponse = await _frsService.storeFrs(
        idJadwalDipilih: idJadwalDipilih,
        tahunAjar: selectedTahunAjar.value!,
        semester: selectedSemester.value!,
      );
      
      if(Get.isDialogOpen ?? false) Get.back(); 

      if (apiResponse.success) {
        Get.snackbar('Berhasil', apiResponse.message ?? 'FRS berhasil diajukan.',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
        selectedJadwalUntukPengajuan.clear(); 
        await _refreshData(); 
      } else {
        String errorMessage = apiResponse.message ?? 'Gagal mengajukan FRS.';
        if (apiResponse.validationErrors != null && apiResponse.validationErrors!.isNotEmpty) {
          final errors = apiResponse.validationErrors!.entries
              .map((e) => '${e.key}: ${e.value is List ? (e.value as List).join(', ') : e.value}')
              .join('\n');
          errorMessage += '\nDetail:\n$errors';
        }
        Get.defaultDialog(
          title: "Gagal Mengajukan FRS", 
          middleText: errorMessage, 
          textConfirm: "OK", 
          confirmTextColor: Colors.white,
          buttonColor: Colors.red,
          onConfirm:()=> Get.back()
        );
      }
    } catch (e) {
      if(Get.isDialogOpen ?? false) Get.back(); 
      print("Controller Exception in storeSelectedFrs: $e");
      Get.defaultDialog(
        title: "Error Kritis", 
        middleText: "Terjadi pengecualian saat mengajukan FRS: ${e.toString()}", 
        textConfirm: "OK", 
        confirmTextColor: Colors.white,
        buttonColor: Colors.red,
        onConfirm:()=> Get.back()
      );
    } finally {
      isStoringFrs.value = false;
    }
  }
}
