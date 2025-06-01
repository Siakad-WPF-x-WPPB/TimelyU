import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelyu/modules/schedule/full_schedule_view.dart';
import 'package:timelyu/modules/schedule/jadwal_hariIni_controller.dart';
import 'package:timelyu/modules/schedule/jadwal_besok_controller.dart';
import 'package:timelyu/shared/widgets/bottomNavigasi.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {

  final ScheduleTodayController _todayScheduleController = Get.put(ScheduleTodayController());  
  final JadwalBesokController _jadwalBesokController = Get.put(JadwalBesokController());

  final List<Color> _scheduleItemColors = [
    Colors.purple.shade50,
    Colors.green.shade50,
    Colors.blue.shade50,
    Colors.orange.shade50,
    Colors.red.shade50,
    Colors.teal.shade50,
    Colors.pink.shade50,
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Jadwal Kuliah',
                  style: TextStyle(
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _kelasBerlangsungCard(screenWidth), // Masih statis
              const SizedBox(height: 30),
              _jadwalHariIni(screenWidth),       // Sudah dinamis
              const SizedBox(height: 30),
              _jadwalMendatang(screenWidth),   // Akan dibuat dinamis
            ],
          ),
        ),
      ),
      bottomNavigationBar: const TaskBottomNavigationBar(),
    );
  }

  // --- _kelasBerlangsungCard tetap statis ---
  Widget _kelasBerlangsungCard(double screenWidth) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber[700],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.white),
              SizedBox(width: 8),
              Text('Kelas berlangsung', style: TextStyle(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Kecerdasan Buatan', // Contoh data
            style: TextStyle(
              fontSize: screenWidth * 0.06,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.access_time, color: Colors.white, size: 16),
              SizedBox(width: 4),
              Text(
                '13:00 - 16:20', // Contoh data
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(width: 12),
              Icon(Icons.location_on, color: Colors.white, size: 16),
              SizedBox(width: 4),
              Text('C 203', style: TextStyle(color: Colors.white)), // Contoh data
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 32, color: Colors.black),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alirdho Barakbah', // Contoh data
                    style: TextStyle(color: Colors.white),
                  ),
                  Text('Pengajar', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- _jadwalHariIni sudah dinamis (dari respons sebelumnya) ---
  Widget _jadwalHariIni(double screenWidth) {
    return Obx(() {
      if (_todayScheduleController.isLoading.value) {
        return const Center(child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: CircularProgressIndicator(),
        ));
      }
      if (_todayScheduleController.errorMessage.value.isNotEmpty &&
          _todayScheduleController.todaySchedule.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jadwal Hari Ini',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
                GestureDetector(
                    onTap: () {
                      Get.to(() => const FullScheduleView());
                    },
                    child: const Icon(Icons.arrow_forward_ios)),
              ],
            ),
            const SizedBox(height: 20),
            Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(_todayScheduleController.errorMessage.value),
                )
            ),
          ],
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _todayScheduleController.currentDayDisplay.value,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(_todayScheduleController.todaySchedule.isEmpty && _todayScheduleController.errorMessage.value.isEmpty
                      ? 'Tidak ada kelas hari ini.'
                      : 'Kamu mempunyai ${_todayScheduleController.todaySchedule.length} kelas hari ini.'),
                ],
              ),
              GestureDetector(
                  onTap: () {
                    Get.to(() => const FullScheduleView());
                  },
                  child: const Icon(Icons.arrow_forward_ios)),
            ],
          ),
          const SizedBox(height: 20),
          if (_todayScheduleController.todaySchedule.isEmpty && _todayScheduleController.errorMessage.value.isEmpty)
            const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text("Tidak ada jadwal untuk hari ini."),
                ))
          else
            Column(
              children: List.generate(_todayScheduleController.todaySchedule.length, (index) {
                final item = _todayScheduleController.todaySchedule[index];
                return _jadwalItem(
                  waktu: item['waktu'] ?? 'N/A',
                  mataKuliah: item['mataKuliah'] ?? 'N/A',
                  pengajar: item['dosen'] ?? 'N/A',
                  jamKuliah: item['jamKuliah'] ?? 'N/A',
                  lokasi: item['ruang'] ?? 'N/A',
                  cardColor: _scheduleItemColors[index % _scheduleItemColors.length],
                );
              }),
            ),
        ],
      );
    });
  }

  // --- Implementasi _jadwalMendatang yang DINAMIS ---
  Widget _jadwalMendatang(double screenWidth) {
    return Obx(() {
      if (_jadwalBesokController.isLoading.value) {
        return const Center(child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: CircularProgressIndicator(),
        ));
      }

      // 2. Menampilkan Pesan Error jika ada dan tidak ada data jadwal
      if (_jadwalBesokController.errorMessage.value.isNotEmpty &&
          _jadwalBesokController.jadwalBesokList.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // Menggunakan judul dari controller
              _jadwalBesokController.scheduleDayTitle.value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            // Tidak menampilkan jumlah kelas jika ada error utama
            const SizedBox(height: 20),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                // Menampilkan pesan error dari controller
                child: Text(_jadwalBesokController.errorMessage.value),
              )
            ),
          ],
        );
      }

      // 3. Menampilkan Data Jadwal jika berhasil dimuat
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            // Menggunakan judul dari controller
            _jadwalBesokController.scheduleDayTitle.value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text(_jadwalBesokController.jadwalBesokList.isEmpty && _jadwalBesokController.errorMessage.value.isEmpty
              ? 'Tidak ada kelas mendatang.' // Atau lebih spesifik "Tidak ada kelas besok."
              : 'Kamu mempunyai ${_jadwalBesokController.jadwalBesokList.length} kelas mendatang.'),
          const SizedBox(height: 20),
          // Jika tidak ada jadwal (setelah fetch berhasil) dan tidak ada error message
          if (_jadwalBesokController.jadwalBesokList.isEmpty && _jadwalBesokController.errorMessage.value.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text("Tidak ada jadwal mendatang."), // Atau "Tidak ada jadwal besok."
              ))
          else
            Column(
              children: List.generate(_jadwalBesokController.jadwalBesokList.length, (index) {
                final item = _jadwalBesokController.jadwalBesokList[index];
                return _jadwalItem(
                  waktu: item['waktu'] ?? 'N/A',
                  mataKuliah: item['mataKuliah'] ?? 'N/A',
                  pengajar: item['dosen'] ?? 'N/A',
                  jamKuliah: item['jamKuliah'] ?? 'N/A',
                  lokasi: item['ruang'] ?? 'N/A',
                  cardColor: _scheduleItemColors[(index + 2) % _scheduleItemColors.length], 
                );
              }),
            ),
        ],
      );
    });
  }

  // --- _jadwalItem tetap sama ---
  Widget _jadwalItem({
    required String waktu,
    required String mataKuliah,
    required String pengajar,
    required String jamKuliah,
    required String lokasi,
    required Color cardColor,
  }) {
    // ... (Implementasi _jadwalItem Anda yang sudah ada)
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 50,
            child: Text(
              waktu,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mataKuliah,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: Colors.black54),
                      const SizedBox(width: 4),
                      Expanded(child: Text(pengajar, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black87))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.black54),
                      const SizedBox(width: 4),
                      Text(jamKuliah, style: const TextStyle(color: Colors.black87)),
                      const SizedBox(width: 12),
                      const Icon(Icons.location_on, size: 16, color: Colors.black54),
                      const SizedBox(width: 4),
                      Expanded(child: Text(lokasi, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black87))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}