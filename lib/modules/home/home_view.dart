// File: lib/modules/home/home_view.dart (Updated)

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelyu/modules/auth/auth_controller.dart';
import 'package:timelyu/modules/home/home_controller.dart';
// ⬇️ Import PengumumanController
import 'package:timelyu/modules/home/pengumuman_controller.dart';
import 'package:timelyu/modules/home/profile_view.dart';
import 'package:timelyu/shared/widgets/bottomNavigasi.dart';
// Import model pengumuman jika Anda ingin type hint atau akses langsung
// import 'package:timelyu/data/models/pengumuman_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final AuthController _authController = Get.find<AuthController>();
  final HomeController _homeController = Get.put(HomeController());
  // ⬇️ Tambahkan PengumumanController
  final PengumumanController _pengumumanController = Get.put(PengumumanController());

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
              // ... (Tidak ada perubahan di Header Section, sudah ada di kode Anda) ...
                 Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded( 
                    child: Obx(() {
                      final fullUserName = _authController.user.value?.nama ?? "Pengguna";
                      final displayName = _formatUserName(fullUserName);
                      final userNrp = _authController.user.value?.nrp ?? "Memuat...";
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          fullUserName.length > 15
                            ? Tooltip(
                                message: "Halo, $fullUserName!",
                                child: Text(
                                  "Halo, $displayName",
                                  style: TextStyle(
                                    fontSize: Get.width < 400 ? 20 : 24, 
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              )
                            : Text(
                                "Halo, $displayName!",
                                style: TextStyle(
                                  fontSize: Get.width < 400 ? 20 : 24, 
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                          SizedBox(height: Get.height * 0.005), 
                          Text(
                            userNrp, 
                            style: TextStyle(
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
                    icon: Icon(
                      Icons.menu, 
                      size: Get.width < 400 ? 28 : 32, 
                    ),
                    itemBuilder: (context) => [
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
                            content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
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


              // *** Next Class Section ***
              // ... (Tidak ada perubahan di Next Class Section, sudah ada di kode Anda) ...
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(Get.width * 0.04), 
                    decoration: BoxDecoration(
                      color: const Color(0xFF0056B3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Kelas saat ini", // atau "Kelas Selanjutnya" jika lebih cocok
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: Get.width < 400 ? 12 : 14, 
                          ),
                        ),
                        SizedBox(height: Get.height * 0.005),
                        Text(
                          "Kecerdasan Buatan", // Ini bisa dinamis juga nanti
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Get.width < 400 ? 18 : 20, 
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: Get.height * 0.01),
                        Row(
                          children: [
                            const Icon(Icons.person, size: 16, color: Colors.white),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                "Aliridho Barakbah", // Ini bisa dinamis juga nanti
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
                              "13:00 - 16:20", // Ini bisa dinamis juga nanti
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
                                "C 203", // Ini bisa dinamis juga nanti
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
                    ),
                  ),
                  SizedBox(height: Get.height * 0.015), 
                  // ... (Container kelas selanjutnya tidak berubah, sudah ada di kode Anda) ...
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(Get.width * 0.04),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC107),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Kelas selanjutnya",
                          style: TextStyle(
                            color: const Color(0xFF00296B),
                            fontSize: Get.width < 400 ? 12 : 14,
                          ),
                        ),
                        SizedBox(height: Get.height * 0.005),
                        Text(
                          "Workshop Pemrograman Berbasis Agile",
                          style: TextStyle(
                            color: const Color(0xFF00296B),
                            fontSize: Get.width < 400 ? 18 : 20,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
                              "13:00 - 16:20",
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
                                "C 203",
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
                    ),
                  ),
                ],
              ),
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
                        style: TextStyle(fontSize: Get.width < 400 ? 12 : 14, color: Colors.grey),
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
              Obx(() { // ⬇️ Bungkus dengan Obx untuk reaktivitas
                if (_pengumumanController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (_pengumumanController.errorMessage.value.isNotEmpty && _pengumumanController.pengumumanList.isEmpty) {
                  return Center(child: Text(_pengumumanController.errorMessage.value));
                }
                if (_pengumumanController.pengumumanList.isEmpty) {
                  return const Center(child: Text("Tidak ada pengumuman saat ini."));
                }
                final pengumuman = _pengumumanController.pengumumanList.first;
                return Container(
                  width: double.infinity, // Agar container mengambil lebar penuh
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
                        style: TextStyle(
                          fontSize: Get.width < 400 ? 12 : 14,
                        ),
                        maxLines: 3, // Batasi jumlah baris jika isi terlalu panjang
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
                              color: Colors.grey[700]
                            ),
                          ),
                          Text(
                            // Format tanggal jika perlu, atau tampilkan langsung
                            _formatDisplayDate(pengumuman.tanggalDibuat),
                            style: TextStyle(
                              fontSize: Get.width < 400 ? 10 : 12,
                               fontStyle: FontStyle.italic,
                              color: Colors.grey[700]
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
      // Format ke dd MMM yyyy (contoh: 01 Jun 2025)
      // Anda bisa menggunakan package intl untuk format yang lebih kompleks
      return "${parsedDate.day.toString().padLeft(2, '0')} ${['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'][parsedDate.month - 1]} ${parsedDate.year}";
    } catch (e) {
      return apiDate; // Kembalikan tanggal asli jika parsing gagal
    }
  }
}