import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelyu/data/models/frs_model.dart';
import 'package:timelyu/data/models/pemilihan_frs_model.dart';

class FrsController extends GetxController {
  // Observable variables
  final items = ['Item 1', 'Item 2', 'Item 3', 'Item 4'].obs;
  final selectedTahunAjar = Rxn<String>();
  final selectedSemester = Rxn<String>();

  // Sample FRS data
  final frsList = <FrsModel>[].obs;

  // Info data
  final dosenWali = 'S.kom Jakobowo'.obs;
  final batasKredit = '24'.obs;
  final sisaKredit = '20'.obs;
  final tanggalPengisian = '07-08-2023'.obs;

  // Total sks yang diambil
  final int maxSKS = 24;

  // Daftar mata kuliah yang tersedia
  var pemilihanFRS = <PemilihanFrsModel>[].obs;

  // SKS yang sudah dipilih
  var selectedSKS = 0.obs;

  // Sisa SKS yang bisa dipilih
  int get remainingSKS => maxSKS - selectedSKS.value;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
    fetchCourses();
  }

  // data contoh dalam pengambilan API
  void fetchCourses() {
    // Data contoh, dalam aplikasi nyata data ini bisa berasal dari API
    var coursesData = [
      PemilihanFrsModel(
        id: '1',
        nama: 'MW-Bahasa Inggris',
        sks: 2,
        dosen: 'Adolf Ismaran S.kom',
        jadwal: '08:00 sd 11:00 WIB',
        kelas: 'Kelas B',
      ),
      PemilihanFrsModel(
        id: '2',
        nama: 'MW-Workshop Pemrograman Perangkat Bergerak',
        sks: 2,
        dosen: 'Adolf Ismaran S.kom',
        jadwal: '12:00 sd 14:30 WIB',
        kelas: 'Kelas B',
      ),
      PemilihanFrsModel(
        id: '3',
        nama: 'MW-Dasar Sistem Informasi',
        sks: 2,
        dosen: 'Adolf Ismaran S.kom',
        jadwal: 'TBA', // To Be Announced
        kelas: 'Kelas A',
      ),
      PemilihanFrsModel(
        id: '4',
        nama: 'Kalkulus Lanjut',
        sks: 3,
        dosen: 'Dr. Supriadi, M.Si.',
        jadwal: 'Senin, 10:00-12:30 WIB',
        kelas: 'Kelas C',
      ),
      PemilihanFrsModel(
        id: '5',
        nama: 'Struktur Data dan Algoritma',
        sks: 4,
        dosen: 'Prof. Budi Santoso, Ph.D',
        jadwal: 'Selasa, 13:00-15:40 WIB',
        kelas: 'Kelas D',
      ),
    ];
    pemilihanFRS.assignAll(coursesData);
  }

  void toggleCourseSelection(PemilihanFrsModel frs) {
    if (frs.isSelected.value) {
      // Jika sudah dipilih (deselect)
      frs.isSelected.value = false;
      selectedSKS.value -= frs.sks;
    } else {
      // Jika belum dipilih (select)
      if (selectedSKS.value + frs.sks <= maxSKS) {
        frs.isSelected.value = true;
        selectedSKS.value += frs.sks;
      } else {
        // Tampilkan pesan jika melebihi batas SKS
        Get.snackbar(
          'Batas SKS Terlampaui',
          'Anda tidak dapat memilih mata kuliah ini karena akan melebihi batas SKS.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  void submitFRS() {
    // Logika untuk submit FRS yang dipilih
    List<PemilihanFrsModel> chosenCourses =
        pemilihanFRS.where((c) => c.isSelected.value).toList();

    if (chosenCourses.isEmpty) {
      Get.snackbar(
        'Belum Ada Pilihan',
        'Silakan pilih minimal satu mata kuliah.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // Custom dialog yang sesuai dengan tampilan
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: Get.width * 0.85, // 85% dari lebar layar
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header dengan ikon close
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 24), // Spacer
                  const Text(
                    'Pemilihan FRS',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(
                      Icons.close,
                      size: 24,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Pesan konfirmasi
              const Text(
                'Apakah anda yakin ingin\nmenambahkan FRS berikut?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 20),

              // List mata kuliah yang dipilih
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(
                  maxHeight: 200, // Maksimal tinggi untuk scroll
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        chosenCourses.asMap().entries.map((entry) {
                          int index = entry.key + 1;
                          PemilihanFrsModel course = entry.value;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$index. ',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '${course.nama} (${course.sks} SKS)',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Tombol aksi
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Tidak',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        Get.snackbar(
                          'Berhasil',
                          'FRS telah berhasil diambil.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Iya',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );

    print("Mata kuliah yang dipilih:");
    for (var course in chosenCourses) {
      print("- ${course.nama} (${course.sks} SKS)");
    }
  }

  void _loadInitialData() {
    frsList.add(
      FrsModel(
        namaMatakuliah: "Adolf Ismaran S.kom",
        status: "Ditolak",
        pengajar: "Adolf Ismaran S.kom",
        waktu: "08:00 sd 11:00 WIB",
        kelas: "Kelas B",
      ),
    );
  }

  // Methods
  void onTahunAjarChanged(String? value) {
    selectedTahunAjar.value = value;
    _refreshData();
  }

  void onSemesterChanged(String? value) {
    selectedSemester.value = value;
    _refreshData();
  }

  void _refreshData() {
    // Simulate data refresh based on selected tahun ajar and semester
    if (selectedTahunAjar.value != null && selectedSemester.value != null) {
      // Here you would typically call an API or update data
      print(
        'Refreshing data for ${selectedTahunAjar.value} - ${selectedSemester.value}',
      );
    }
  }

  void removeFrsItem(int index) {
    if (index >= 0 && index < frsList.length) {
      frsList.removeAt(index);
    }
  }

  void addFrsItem(FrsModel item) {
    frsList.add(item);
  }
}
