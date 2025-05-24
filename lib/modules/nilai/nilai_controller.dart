import 'package:get/get.dart';

class NilaiController extends GetxController {
  // Observable variables
  var selectedTahunAjaran = '2024/2025'.obs;
  var selectedSemester = 'Genap'.obs;
  
  // List of available options
  final List<String> tahunAjaranList = ['2024/2025', '2023/2024', '2022/2023'];
  final List<String> semesterList = ['Genap', 'Ganjil'];
  
  // List of mata kuliah data
  final RxList<Map<String, String>> mataKuliahList = <Map<String, String>>[
    {
      'nama': 'Workshop Desain Pengalaman Pengguna',
      'kode': 'TI034109',
      'nilai': 'Belum Isi Kuesioner',
    },
    {
      'nama': 'Workshop Pengembangan Perangkat Lunak berbasis Agile',
      'kode': 'TI034106',
      'nilai': 'Belum Isi Kuesioner',
    },
    {
      'nama': 'Workshop Pemrograman Framework',
      'kode': 'TI034107',
      'nilai': 'Belum Isi Kuesioner',
    },
    {
      'nama': 'Workshop Administrasi Basis Data',
      'kode': 'TI034104',
      'nilai': 'Belum Isi Kuesioner',
    },
  ].obs;
  
  // Methods to update selected values
  void updateTahunAjaran(String value) {
    selectedTahunAjaran.value = value;
  }
  
  void updateSemester(String value) {
    selectedSemester.value = value;
  }
  
  // Method to handle kuesioner action
  void isiKuesioner(int index) {
    // Update nilai status (this is just an example)
    mataKuliahList[index]['nilai'] = 'Kuesioner Terisi';
    mataKuliahList.refresh();
    
    Get.snackbar(
      'Info',
      'Kuesioner untuk ${mataKuliahList[index]['nama']} telah diisi',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  @override
  void onInit() {
    super.onInit();
    // Initialize any data if needed
  }
  
  @override
  void onReady() {
    super.onReady();
    // Called after the widget is rendered on screen
  }
  
  @override
  void onClose() {
    super.onClose();
    // Clean up resources
  }
}