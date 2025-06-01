import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Sesuaikan path import ini dengan struktur proyek Anda
import 'package:timelyu/data/models/frs_model.dart';
import 'package:timelyu/data/models/jadwal_matkul.model.dart';
import 'package:timelyu/data/services/frs_service.dart';

class FrsController extends GetxController {
  late final FrsService _frsService;

  // --- State untuk Menampilkan FRS yang Sudah Ada ---
  final isLoadingFrs = false.obs;
  final frsList = <FrsModel>[].obs;

  // --- State untuk Pemilihan Jadwal FRS Baru ---
  final isLoadingJadwalPilihan = false.obs;
  // _rawJadwalPilihanList adalah data mentah dari API sebelum difilter
  final RxList<JadwalMatakuliahModel> _rawJadwalPilihanList = <JadwalMatakuliahModel>[].obs;
  // jadwalPilihanListForUiConditions digunakan untuk beberapa kondisi UI, diperbarui dari filteredJadwalPilihanList
  final jadwalPilihanListForUiConditions = <JadwalMatakuliahModel>[].obs;
  final selectedJadwalUntukPengajuan = <JadwalMatakuliahModel>[].obs;
  final isStoringFrs = false.obs;
  final RxString searchQuery = ''.obs;
  // Menyimpan idJadwalAsal dari FRS yang sudah diambil (status pending/approved) pada periode terpilih
  final RxList<String> _idsJadwalFrsDiambilPadaPeriodeIni = <String>[].obs;

  // --- State Umum & Filter ---
  final selectedTahunAjar = Rxn<String>();
  final selectedSemester = Rxn<String>();
  final tahunAjarItems = <String>['2025/2026','2024/2025', '2023/2024', '2022/2023', '2021/2022','2020/2021', '2019/2020'].obs;
  final semesterItems = <String>['Genap', 'Ganjil'].obs;

  // Helper untuk parsing tahun ajar di controller
  int? _getStartYearFromTahunAjarString(String? tahunAjarStr) {
    if (tahunAjarStr == null || tahunAjarStr.isEmpty) return null;
    try {
      List<String> parts = tahunAjarStr.split('/');
      if (parts.length == 2) {
        return int.parse(parts[0]);
      }
    } catch (e) {
      print("FrsController (_getStartYearFromTahunAjarString): Error parsing tahun ajar string '$tahunAjarStr': $e");
    }
    return null;
  }

  // Getter untuk list jadwal yang sudah difilter (sumber utama untuk ListView di UI)
  List<JadwalMatakuliahModel> get filteredJadwalPilihanList {
    print("FrsController (Getter filteredJadwalPilihanList): Invoked.");
    print("FrsController (Getter filteredJadwalPilihanList): _rawJadwalPilihanList count = ${_rawJadwalPilihanList.length}");
    print("FrsController (Getter filteredJadwalPilihanList): _idsJadwalFrsDiambilPadaPeriodeIni count = ${_idsJadwalFrsDiambilPadaPeriodeIni.length}, IDs: ${_idsJadwalFrsDiambilPadaPeriodeIni.join(', ')}");

    List<JadwalMatakuliahModel> listSetelahFilterFrs = _rawJadwalPilihanList.where((jadwal) {
      return !_idsJadwalFrsDiambilPadaPeriodeIni.contains(jadwal.idJadwal);
    }).toList();
    print("FrsController (Getter filteredJadwalPilihanList): listSetelahFilterFrs (after FRS taken filter) count = ${listSetelahFilterFrs.length}");

    if (searchQuery.value.isEmpty) {
      return listSetelahFilterFrs;
    }
    final query = searchQuery.value.toLowerCase();
    final result = listSetelahFilterFrs.where((jadwal) {
      return jadwal.namaMatakuliah.toLowerCase().contains(query) ||
             jadwal.namaDosen.toLowerCase().contains(query);
    }).toList();
    print("FrsController (Getter filteredJadwalPilihanList): After search query. Result count = ${result.length}");
    return result;
  }

  @override
  void onInit() {
    super.onInit();
    _initializeService();
    _loadInitialData();
    // Debounce untuk search query agar tidak memicu update terlalu sering
    debounce(searchQuery, (_) => _updateJadwalPilihanListForUiConditions(), time: const Duration(milliseconds: 300));
  }

  void _initializeService() {
    _frsService = Get.put(FrsService());
  }

  void _loadInitialData() {
    print("FrsController (_loadInitialData): Called.");
    if (tahunAjarItems.isNotEmpty && selectedTahunAjar.value == null) {
      selectedTahunAjar.value = tahunAjarItems.first;
      print("FrsController (_loadInitialData): selectedTahunAjar initialized to ${selectedTahunAjar.value}");
    }
    if (semesterItems.isNotEmpty && selectedSemester.value == null) {
      selectedSemester.value = semesterItems.first;
      print("FrsController (_loadInitialData): selectedSemester initialized to ${selectedSemester.value}");
    }
    if (selectedTahunAjar.value != null && selectedSemester.value != null) {
        _refreshData();
    } else {
        print("FrsController (_loadInitialData): Initial period not fully set, data refresh skipped.");
        _clearAllFrsRelatedData(); // Pastikan list kosong jika periode tidak diset
    }
  }

  Future<void> _refreshData() async {
    print("FrsController (_refreshData): Called for TahunAjar: ${selectedTahunAjar.value}, Semester: ${selectedSemester.value}");
    if (selectedTahunAjar.value != null && selectedSemester.value != null) {
      await fetchFrsData(); // Ini akan memicu update _idsJadwalFrsDiambilPadaPeriodeIni
      await fetchJadwalPilihan(); // Ini akan memicu update _rawJadwalPilihanList dan akhirnya _updateJadwalPilihanListForUiConditions
    } else {
      _clearAllFrsRelatedData();
      print("FrsController (_refreshData): Cleared lists because period not fully selected.");
    }
  }

  void _clearAllFrsRelatedData(){
      print("FrsController (_clearAllFrsRelatedData): Clearing all FRS related lists.");
      frsList.clear();
      _rawJadwalPilihanList.clear();
      _idsJadwalFrsDiambilPadaPeriodeIni.clear();
      selectedJadwalUntukPengajuan.clear();
      _updateJadwalPilihanListForUiConditions(); // Update list UI conditions juga
  }

  Future<void> fetchFrsData() async {
    if (selectedTahunAjar.value == null || selectedSemester.value == null) {
      print("FrsController (fetchFrsData): Tahun ajar atau semester null, FRS data fetch skipped.");
      frsList.clear();
      _idsJadwalFrsDiambilPadaPeriodeIni.clear();
      _updateJadwalPilihanListForUiConditions(); // Update UI list agar konsisten
      return;
    }

    isLoadingFrs.value = true;
    print("FrsController (fetchFrsData): Fetching FRS data for ${selectedTahunAjar.value} - ${selectedSemester.value}");
    try {
      final apiResponse = await _frsService.getFrsData(
        tahunAjar: selectedTahunAjar.value!,
        semester: selectedSemester.value!,
      );

      if (apiResponse.success && apiResponse.data != null) {
        frsList.assignAll(apiResponse.data!);
        print("FrsController (fetchFrsData): frsList updated. Count: ${frsList.length}.");
        if (frsList.isNotEmpty) {
            print("FrsController (fetchFrsData): Sample FRS item - ID Asal: ${frsList.first.idJadwalAsal}, Matkul: ${frsList.first.namaMatakuliah}, Status: ${frsList.first.status}, TA: ${frsList.first.tahunAjar}, Sem: ${frsList.first.semester}");
        }

        final int? currentStartYear = _getStartYearFromTahunAjarString(selectedTahunAjar.value);
        final String? currentSemester = selectedSemester.value?.toLowerCase();
        print("FrsController (fetchFrsData): Current period for filtering taken FRS - TA: $currentStartYear, Sem: $currentSemester");

        if (currentStartYear != null && currentSemester != null) {
          final newIds = frsList
              .where((frs) =>
                  (frs.status.toLowerCase() == 'pending' ||
                   frs.status.toLowerCase() == 'approved' ||
                   frs.status.toLowerCase() == 'disetujui') &&
                  frs.idJadwalAsal != null && frs.idJadwalAsal!.isNotEmpty &&
                  frs.tahunAjar == currentStartYear &&
                  frs.semester.toLowerCase() == currentSemester)
              .map((frs) => frs.idJadwalAsal!)
              .toSet() // Hindari duplikasi ID
              .toList();
          _idsJadwalFrsDiambilPadaPeriodeIni.assignAll(newIds);
          print("FrsController (fetchFrsData): _idsJadwalFrsDiambilPadaPeriodeIni updated. Count: ${newIds.length}. IDs: ${newIds.join(', ')}");
        } else {
          _idsJadwalFrsDiambilPadaPeriodeIni.clear();
          print("FrsController (fetchFrsData): _idsJadwalFrsDiambilPadaPeriodeIni cleared (currentStartYear or currentSemester is null).");
        }
      } else {
        frsList.clear();
        _idsJadwalFrsDiambilPadaPeriodeIni.clear();
        print("FrsController (fetchFrsData): Failed or no FRS data. Message: ${apiResponse.message}. Cleared frsList and _idsJadwalFrsDiambilPadaPeriodeIni.");
      }
    } catch (e) {
      frsList.clear();
      _idsJadwalFrsDiambilPadaPeriodeIni.clear();
      print("FrsController (fetchFrsData): Exception: $e. Cleared frsList and _idsJadwalFrsDiambilPadaPeriodeIni.");
    } finally {
      isLoadingFrs.value = false;
      // Pemanggilan _updateJadwalPilihanListForUiConditions dipindahkan ke akhir _refreshData
      // atau setelah kedua fetch selesai untuk memastikan data konsisten.
      // Namun, karena _idsJadwalFrsDiambilPadaPeriodeIni mempengaruhi filteredJadwalPilihanList,
      // kita perlu update di sini jika fetchJadwalPilihan belum tentu dipanggil setelahnya atau datanya belum ada.
      _updateJadwalPilihanListForUiConditions();
    }
  }

  Future<void> fetchJadwalPilihan() async {
    if (selectedTahunAjar.value == null || selectedSemester.value == null) {
      print("FrsController (fetchJadwalPilihan): Tahun ajar atau semester null, jadwal pilihan fetch skipped.");
      _rawJadwalPilihanList.clear();
      _updateJadwalPilihanListForUiConditions();
      return;
    }

    isLoadingJadwalPilihan.value = true;
    print("FrsController (fetchJadwalPilihan): Fetching jadwal pilihan for ${selectedTahunAjar.value} - ${selectedSemester.value}");
    try {
      final apiResponse = await _frsService.getJadwalPilihan(
        tahunAjar: selectedTahunAjar.value!,
        semester: selectedSemester.value!,
      );

      if (apiResponse.success && apiResponse.data != null) {
        _rawJadwalPilihanList.assignAll(apiResponse.data!);
        print("FrsController (fetchJadwalPilihan): _rawJadwalPilihanList updated. Count: ${_rawJadwalPilihanList.length}.");
        if(_rawJadwalPilihanList.isNotEmpty){
            print("FrsController (fetchJadwalPilihan): Sample Jadwal - ID: ${_rawJadwalPilihanList.first.idJadwal}, Matkul: ${_rawJadwalPilihanList.first.namaMatakuliah}");
        }
      } else {
        _rawJadwalPilihanList.clear();
        print("FrsController (fetchJadwalPilihan): Failed or no jadwal pilihan data. Message: ${apiResponse.message}. Cleared _rawJadwalPilihanList.");
        Get.snackbar(
          'Error Memuat Jadwal',
          apiResponse.message ?? 'Terjadi kesalahan saat memuat jadwal pilihan.',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange, colorText: Colors.white,
        );
      }
    } catch (e) {
      _rawJadwalPilihanList.clear();
      print("FrsController (fetchJadwalPilihan): Exception: $e. Cleared _rawJadwalPilihanList.");
      Get.snackbar('Error Kritis Jadwal', 'Terjadi pengecualian: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoadingJadwalPilihan.value = false;
      _updateJadwalPilihanListForUiConditions(); // Pastikan UI terupdate setelah data jadwal pilihan baru masuk
    }
  }

  // Metode ini akan memperbarui list yang digunakan oleh beberapa kondisi UI
  void _updateJadwalPilihanListForUiConditions() {
    // Getter filteredJadwalPilihanList akan dipanggil di sini, yang sudah mengandung semua logika filter
    final tempList = filteredJadwalPilihanList;
    jadwalPilihanListForUiConditions.assignAll(tempList);
    print("FrsController (_updateJadwalPilihanListForUiConditions): jadwalPilihanListForUiConditions updated. Count: ${jadwalPilihanListForUiConditions.length}");
  }

  void onTahunAjarChanged(String? value) {
    if (value != null && selectedTahunAjar.value != value) {
      print("FrsController (onTahunAjarChanged): Old value = ${selectedTahunAjar.value}, New value = $value");
      selectedTahunAjar.value = value;
      _onFilterChanged();
    }
  }

  void onSemesterChanged(String? value) {
    if (value != null && selectedSemester.value != value) {
      print("FrsController (onSemesterChanged): Old value = ${selectedSemester.value}, New value = $value");
      selectedSemester.value = value;
      _onFilterChanged();
    }
  }
  
  // Helper method ketika filter utama (tahun ajar/semester) berubah
  void _onFilterChanged() {
    selectedJadwalUntukPengajuan.clear(); // Reset pilihan jadwal
    searchQuery.value = ''; // Reset search query juga
    _refreshData(); // Muat ulang semua data terkait FRS
  }

  void updateSearchQuery(String query) {
    // Tidak perlu memanggil _updateJadwalPilihanListForUiConditions secara manual di sini
    // karena searchQuery adalah RxString, dan getter filteredJadwalPilihanList
    // akan otomatis terpanggil oleh Obx di UI ketika searchQuery berubah.
    // Debounce di onInit akan menangani pembaruan jika diperlukan untuk jadwalPilihanListForUiConditions.
    searchQuery.value = query;
    print("FrsController (updateSearchQuery): new query = $query");
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
      buttonColor: Get.theme.primaryColor, // Menggunakan warna primer dari tema GetX
      onConfirm: () async {
        Get.back(); // Tutup dialog konfirmasi
        await _executeStoreFrs();
      }
    );
  }

  Future<void> _executeStoreFrs() async {
    isStoringFrs.value = true;
    Get.dialog( // Menampilkan dialog loading
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final List<String> idJadwalDipilih = selectedJadwalUntukPengajuan.map((item) => item.idJadwal).toList();
      print("FrsController (_executeStoreFrs): Storing FRS for TA: ${selectedTahunAjar.value}, Sem: ${selectedSemester.value}, Jadwal IDs: ${idJadwalDipilih.join(', ')}");
      
      final apiResponse = await _frsService.storeFrs(
        idJadwalDipilih: idJadwalDipilih,
        tahunAjar: selectedTahunAjar.value!,
        semester: selectedSemester.value!,
      );
      
      if(Get.isDialogOpen ?? false) Get.back(); // Tutup dialog loading

      if (apiResponse.success) {
        Get.snackbar('Berhasil', apiResponse.message ?? 'FRS berhasil diajukan.',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
        selectedJadwalUntukPengajuan.clear(); // Kosongkan pilihan setelah berhasil
        await _refreshData(); // Muat ulang data FRS dan jadwal
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
      if(Get.isDialogOpen ?? false) Get.back(); // Pastikan dialog loading ditutup jika ada error
      print("FrsController (_executeStoreFrs): Exception: $e");
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