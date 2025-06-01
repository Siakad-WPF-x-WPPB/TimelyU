import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelyu/modules/auth/auth_controller.dart';
import 'package:timelyu/modules/home/home_controller.dart';
// ⬇️ Import PengumumanController
import 'package:timelyu/modules/home/pengumuman_controller.dart';
import 'package:timelyu/modules/home/profile_view.dart';
import 'package:timelyu/modules/schedule/jadwal_hariIni_controller.dart';
import 'package:timelyu/shared/widgets/bottomNavigasi.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final AuthController _authController = Get.find<AuthController>();
  final HomeController _homeController = Get.put(HomeController());
  // ⬇️ Tambahkan PengumumanController
  final PengumumanController _pengumumanController = Get.put(
    PengumumanController(),
  );
  // Tambahkan controller untuk jadwal
  final ScheduleTodayController _todayScheduleController = Get.put(
    ScheduleTodayController(),
  );

  String _formatUserName(String fullName) {
    // ... (fungsi _formatUserName tidak berubah) ...
    if (fullName.isEmpty) return "Pengguna";
    if (fullName.length <= 15) {
      return fullName;
    }
    return "${fullName.substring(0, 15)}...";
  }

  @override
  void initState() {
    super.initState();
    _homeController.fetchUpcomingTasks();
    // ⬇️ Panggil fetchPengumuman saat view diinisialisasi
    _pengumumanController.fetchPengumuman();
  }

  // Helper method untuk cek apakah waktu sekarang berada di antara start dan end time
  bool _isTimeBetween(String current, String start, String end) {
    try {
      final currentMinutes = _timeToMinutes(current);
      final startMinutes = _timeToMinutes(start);
      final endMinutes = _timeToMinutes(end);

      return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
    } catch (e) {
      return false;
    }
  }

  int _timeToMinutes(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  // Helper method untuk mencari kelas berikutnya
  Map<String, dynamic>? _findNextClass() {
    final now = DateTime.now();
    final currentTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final currentMinutes = _timeToMinutes(currentTime);

    Map<String, dynamic>? nextClass;
    int minTimeDiff = double.maxFinite.toInt();

    for (final item in _todayScheduleController.todaySchedule) {
      final waktu = item['waktu'] ?? '';
      if (waktu.isNotEmpty) {
        try {
          final classMinutes = _timeToMinutes(waktu);
          final timeDiff = classMinutes - currentMinutes;

          if (timeDiff > 0 && timeDiff < minTimeDiff) {
            minTimeDiff = timeDiff;
            nextClass = item;
          }
        } catch (e) {
          // Skip jika ada error parsing
        }
      }
    }

    return nextClass;
  }

  // Helper method untuk menghitung waktu hingga kelas berikutnya
  String _getTimeUntilNext(String nextStartTime) {
    try {
      final now = DateTime.now();
      final currentMinutes = now.hour * 60 + now.minute;
      final nextMinutes = _timeToMinutes(nextStartTime);

      final diffMinutes = nextMinutes - currentMinutes;

      if (diffMinutes <= 0) return 'Segera';
      if (diffMinutes < 60) return '${diffMinutes} menit lagi';

      final hours = diffMinutes ~/ 60;
      final minutes = diffMinutes % 60;
      return '${hours}h ${minutes}m lagi';
    } catch (e) {
      return 'Segera';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.08,
            vertical: Get.height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // *** Header Section ***
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Obx(() {
                      final fullUserName =
                          _authController.user.value?.nama ?? "Pengguna";
                      final displayName = _formatUserName(fullUserName);
                      final userNrp =
                          _authController.user.value?.nrp ?? "Memuat...";

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          fullUserName.length > 15
                              ? Tooltip(
                                message: "Halo, $fullUserName!",
                                child: Text(
                                  "Halo, $displayName",
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w700,
                                    fontSize: Get.width < 400 ? 20 : 24,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              )
                              : Text(
                                "Halo, $displayName!",
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w700,
                                  fontSize: Get.width < 400 ? 20 : 24,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                          SizedBox(height: Get.height * 0.005),
                          Text(
                            userNrp,
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontSize: Get.width < 400 ? 14 : 16,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      );
                    }),
                  ),
                  SizedBox(width: Get.width * 0.02),
                  PopupMenuButton(
                    icon: Icon(Icons.menu, size: Get.width < 400 ? 28 : 32),
                    itemBuilder:
                        (context) => [
                          const PopupMenuItem(
                            value: 1,
                            child: Row(
                              children: [
                                Icon(Icons.person, size: 18),
                                SizedBox(width: 8),
                                Text("Profile"),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 2,
                            child: Row(
                              children: [
                                Icon(Icons.logout, size: 18),
                                SizedBox(width: 8),
                                Text("Logout"),
                              ],
                            ),
                          ),
                        ],
                    onSelected: (value) {
                      if (value == 1) {
                        Get.to(() => ProfileView());
                      } else if (value == 2) {
                        Get.dialog(
                          AlertDialog(
                            title: const Text('Konfirmasi Logout'),
                            content: const Text(
                              'Apakah Anda yakin ingin keluar dari aplikasi?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text('Batal'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                  _authController.logout();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Logout'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.03),

              // *** Dynamic Class Section ***
              Obx(() {
                if (_todayScheduleController.isLoading.value) {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(Get.width * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                final now = DateTime.now();
                final currentTime =
                    '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

                // Cari kelas yang sedang berlangsung
                final currentClass = _todayScheduleController.todaySchedule
                    .firstWhereOrNull((item) {
                      final jamKuliah = item['jamKuliah'] ?? '';
                      if (jamKuliah.contains(' - ')) {
                        final times = jamKuliah.split(' - ');
                        final startTime = times[0].trim();
                        final endTime = times[1].trim();
                        return _isTimeBetween(currentTime, startTime, endTime);
                      }
                      return false;
                    });

                // Cari kelas berikutnya jika tidak ada kelas berlangsung
                final nextClass =
                    currentClass == null ? _findNextClass() : null;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kelas Saat Ini atau Status
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(Get.width * 0.04),
                      decoration: BoxDecoration(
                        color:
                            currentClass != null
                                ? const Color(0xFF0056B3)
                                : Colors.grey[400],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                currentClass != null
                                    ? Icons.school
                                    : Icons.schedule,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                currentClass != null
                                    ? "Kelas saat ini"
                                    : "Tidak ada kelas berlangsung",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Get.width < 400 ? 12 : 14,
                                ),
                              ),
                              if (currentClass != null) ...[
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'LIVE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: Get.height * 0.005),
                          Text(
                            currentClass != null
                                ? (currentClass['mataKuliah'] ?? 'N/A')
                                : "Tidak ada kelas yang sedang berlangsung",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Get.width < 400 ? 18 : 20,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (currentClass != null) ...[
                            SizedBox(height: Get.height * 0.01),
                            Row(
                              children: [
                                const Icon(
                                  Icons.person,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    currentClass['dosen'] ?? 'N/A',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Get.width < 400 ? 11 : 13,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: Get.height * 0.01),
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  currentClass['jamKuliah'] ?? 'N/A',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Get.width < 400 ? 11 : 13,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    currentClass['ruang'] ?? 'N/A',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Get.width < 400 ? 11 : 13,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: Get.height * 0.015),

                    // Kelas Selanjutnya
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(Get.width * 0.04),
                      decoration: BoxDecoration(
                        color:
                            nextClass != null
                                ? const Color(0xFFFFC107)
                                : Colors.grey[300],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                nextClass != null
                                    ? Icons.schedule
                                    : Icons.event_busy,
                                color:
                                    nextClass != null
                                        ? const Color(0xFF00296B)
                                        : Colors.grey[600],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                nextClass != null
                                    ? "Kelas selanjutnya"
                                    : "Tidak ada kelas mendatang",
                                style: TextStyle(
                                  color:
                                      nextClass != null
                                          ? const Color(0xFF00296B)
                                          : Colors.grey[600],
                                  fontSize: Get.width < 400 ? 12 : 14,
                                ),
                              ),
                              if (nextClass != null) ...[
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _getTimeUntilNext(nextClass['waktu'] ?? ''),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: Get.height * 0.005),
                          Text(
                            nextClass != null
                                ? (nextClass['mataKuliah'] ?? 'N/A')
                                : "Tidak ada kelas yang dijadwalkan",
                            style: TextStyle(
                              color:
                                  nextClass != null
                                      ? const Color(0xFF00296B)
                                      : Colors.grey[600],
                              fontSize: Get.width < 400 ? 18 : 20,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (nextClass != null) ...[
                            SizedBox(height: Get.height * 0.01),
                            Row(
                              children: [
                                const Icon(
                                  Icons.person,
                                  size: 16,
                                  color: Color(0xFF00296B),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    nextClass['dosen'] ?? 'N/A',
                                    style: TextStyle(
                                      color: const Color(0xFF00296B),
                                      fontSize: Get.width < 400 ? 11 : 13,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: Get.height * 0.01),
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: Color(0xFF00296B),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  nextClass['jamKuliah'] ?? 'N/A',
                                  style: TextStyle(
                                    color: const Color(0xFF00296B),
                                    fontSize: Get.width < 400 ? 11 : 13,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Color(0xFF00296B),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    nextClass['ruang'] ?? 'N/A',
                                    style: TextStyle(
                                      color: const Color(0xFF00296B),
                                      fontSize: Get.width < 400 ? 11 : 13,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                );
              }),

              SizedBox(height: Get.height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tugas Mendatang",
                    style: TextStyle(
                      fontSize: Get.width < 400 ? 18 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              SizedBox(height: Get.height * 0.02),
              Obx(() {
                if (_homeController.isLoadingUpcomingTasks.value) {
                  return SizedBox(
                    height: Get.height * 0.18,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                if (_homeController.upcomingTasks.isEmpty) {
                  return SizedBox(
                    height: Get.height * 0.18,
                    child: Center(
                      child: Text(
                        "Tidak ada tugas mendatang.",
                        style: TextStyle(
                          fontSize: Get.width < 400 ? 12 : 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                }

                return SizedBox(
                  height: Get.height * 0.18,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _homeController.upcomingTasks.length,
                    itemBuilder: (context, index) {
                      final task = _homeController.upcomingTasks[index];
                      return Container(
                        width: Get.width * 0.75,
                        margin: EdgeInsets.only(right: Get.width * 0.04),
                        padding: EdgeInsets.all(Get.width * 0.04),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: Get.width < 400 ? 14 : 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: Get.height * 0.005),
                            Text(
                              task.description,
                              style: TextStyle(
                                fontSize: Get.width < 400 ? 11 : 13,
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  task.date,
                                  style: TextStyle(
                                    fontSize: Get.width < 400 ? 10 : 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }),

              SizedBox(height: Get.height * 0.03),

              // *** Announcement Section (DINAMIS) ***
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pengumuman",
                    style: TextStyle(
                      fontSize: Get.width < 400 ? 18 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Anda bisa membuat Icon ini mengarah ke halaman daftar pengumuman penuh nantinya
                  const Icon(Icons.chevron_right),
                ],
              ),
              SizedBox(height: Get.height * 0.02),
              Obx(() {
                // ⬇️ Bungkus dengan Obx untuk reaktivitas
                if (_pengumumanController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (_pengumumanController.errorMessage.value.isNotEmpty &&
                    _pengumumanController.pengumumanList.isEmpty) {
                  return Center(
                    child: Text(_pengumumanController.errorMessage.value),
                  );
                }
                if (_pengumumanController.pengumumanList.isEmpty) {
                  return const Center(
                    child: Text("Tidak ada pengumuman saat ini."),
                  );
                }
                final pengumuman = _pengumumanController.pengumumanList.first;
                return Container(
                  width:
                      double.infinity, // Agar container mengambil lebar penuh
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.all(Get.width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pengumuman.judul, // ⬅️ Data dinamis
                        style: TextStyle(
                          fontSize: Get.width < 400 ? 14 : 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: Get.height * 0.01),
                      Text(
                        pengumuman.isi, // ⬅️ Data dinamis
                        style: TextStyle(fontSize: Get.width < 400 ? 12 : 14),
                        maxLines:
                            3, // Batasi jumlah baris jika isi terlalu panjang
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: Get.height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Oleh: ${pengumuman.namaPembuat}",
                            style: TextStyle(
                              fontSize: Get.width < 400 ? 10 : 12,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            // Format tanggal jika perlu, atau tampilkan langsung
                            _formatDisplayDate(pengumuman.tanggalDibuat),
                            style: TextStyle(
                              fontSize: Get.width < 400 ? 10 : 12,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              SizedBox(height: Get.height * 0.02),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const TaskBottomNavigationBar(),
    );
  }

  // Helper sederhana untuk format tanggal, bisa Anda kembangkan
  String _formatDisplayDate(String apiDate) {
    try {
      final DateTime parsedDate = DateTime.parse(apiDate);
      return "${parsedDate.day.toString().padLeft(2, '0')} ${['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'][parsedDate.month - 1]} ${parsedDate.year}";
    } catch (e) {
      return apiDate; // Kembalikan tanggal asli jika parsing gagal
    }
  }
}
