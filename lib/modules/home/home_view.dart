// File: lib/modules/home/home_view.dart (Updated)

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelyu/modules/auth/auth_controller.dart';
import 'package:timelyu/modules/home/home_controller.dart'; // Import HomeController
import 'package:timelyu/modules/home/profile_view.dart';
import 'package:timelyu/shared/widgets/bottomNavigasi.dart';
// Pastikan TaskModel diimpor jika diperlukan untuk type hinting,
// meskipun data akan datang dari HomeController
// import 'package:timelyu/data/models/task_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final AuthController _authController = Get.find<AuthController>();
  // Tambahkan HomeController
  final HomeController _homeController = Get.put(HomeController()); // atau Get.find() jika sudah di-bind

  String _formatUserName(String fullName) {
    // ... (fungsi _formatUserName tidak berubah)
    if (fullName.isEmpty) return "Pengguna";
    if (fullName.length <= 15) {
      return fullName;
    }
    return "${fullName.substring(0, 15)}...";
  }

  @override
  void initState() {
    super.initState();
    // Panggil fetchUpcomingTasks saat view diinisialisasi
    // Ini akan memastikan data dimuat bahkan jika onInit di controller sudah lewat
    // atau jika view direbuild.
    _homeController.fetchUpcomingTasks();
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
              // ... (Tidak ada perubahan di Header Section) ...
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
              // ... (Tidak ada perubahan di Next Class Section) ...
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
                          "Kelas saat ini",
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
                  Container(
                    // ... (Container kelas selanjutnya tidak berubah) ...
                     width: double.infinity,
                    padding: EdgeInsets.all(Get.width * 0.04), // Responsive padding
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
                            fontSize: Get.width < 400 ? 12 : 14, // Responsive font
                          ),
                        ),
                        SizedBox(height: Get.height * 0.005),
                        Text(
                          "Workshop Pemrograman Berbasis Agile",
                          style: TextStyle(
                            color: const Color(0xFF00296B),
                            fontSize: Get.width < 400 ? 18 : 20, // Responsive font
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
                                fontSize: Get.width < 400 ? 11 : 13, // Responsive font
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
                                  fontSize: Get.width < 400 ? 11 : 13, // Responsive font
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

              // *** Next Assignment Section (DINAMIS) ***
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
              Obx(() { // Obx untuk merebuild widget saat data berubah
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
                    // Gunakan panjang daftar dari controller
                    itemCount: _homeController.upcomingTasks.length, 
                    itemBuilder: (context, index) {
                      // Ambil data task dari controller
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
                              task.title, // Data dinamis
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: Get.width < 400 ? 14 : 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: Get.height * 0.005),
                            Text(
                              task.description, // Data dinamis (biasanya ini nama mata kuliah/kategori)
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
                                  task.date, // Data dinamis
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

              // *** Announcement Section ***
              // ... (Tidak ada perubahan di Announcement Section) ...
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pengumuman",
                    style: TextStyle(
                      fontSize: Get.width < 400 ? 18 : 20, // Responsive font
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              SizedBox(height: Get.height * 0.02), // Responsive spacing
              Container(
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.all(Get.width * 0.04), // Responsive padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pengumuman Webinar Alumni",
                      style: TextStyle(
                        fontSize: Get.width < 400 ? 14 : 16, // Responsive font
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: Get.height * 0.01),
                    Text(
                      "Akan ada webinar alumni pada tanggal 30 Mei 2025. Segera daftarkan diri Anda!",
                      style: TextStyle(
                        fontSize: Get.width < 400 ? 12 : 14, // Responsive font
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Get.height * 0.02),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const TaskBottomNavigationBar(),
    );
  }
}