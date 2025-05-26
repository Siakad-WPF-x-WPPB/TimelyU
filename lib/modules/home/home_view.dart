// File: lib/modules/home/home_view.dart (Updated)

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelyu/modules/auth/auth_controller.dart';
import 'package:timelyu/modules/home/profile_view.dart';
import 'package:timelyu/shared/widgets/bottomNavigasi.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final AuthController _authController = Get.find<AuthController>();

  // Helper method untuk memotong nama jika terlalu panjang
  String _formatUserName(String fullName) {
    if (fullName.isEmpty) return "Pengguna";
    
    // Jika nama kurang dari atau sama dengan 15 karakter, tampilkan penuh
    if (fullName.length <= 15) {
      return fullName;
    }
    
    // Jika lebih dari 15 karakter, potong dan tambahkan "..."
    return "${fullName.substring(0, 15)}...";
  }

  // Helper method untuk mendapatkan nama lengkap untuk tooltip
  String _getFullUserName(String fullName) {
    return fullName.isEmpty ? "Pengguna" : fullName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.08, // Responsive horizontal padding
            vertical: Get.height * 0.02,  // Responsive vertical padding
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // *** Header Section ***
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded( // Wrap dengan Expanded untuk mencegah overflow
                    child: Obx(() {
                      final fullUserName = _authController.user.value?.nama ?? "Pengguna";
                      final displayName = _formatUserName(fullUserName);
                      final userNrp = _authController.user.value?.nrp ?? "Memuat...";
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nama dengan tooltip jika nama dipotong
                          fullUserName.length > 15
                            ? Tooltip(
                                message: "Halo, $fullUserName!",
                                child: Text(
                                  "Halo, $displayName",
                                  style: TextStyle(
                                    fontSize: Get.width < 400 ? 20 : 24, // Responsive font size
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              )
                            : Text(
                                "Halo, $displayName!",
                                style: TextStyle(
                                  fontSize: Get.width < 400 ? 20 : 24, // Responsive font size
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                          SizedBox(height: Get.height * 0.005), // Responsive spacing
                          Text(
                            userNrp, 
                            style: TextStyle(
                              fontSize: Get.width < 400 ? 14 : 16, // Responsive font size
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      );
                    }),
                  ),
                  SizedBox(width: Get.width * 0.02), // Responsive spacing
                  PopupMenuButton(
                    icon: Icon(
                      Icons.menu, 
                      size: Get.width < 400 ? 28 : 32, // Responsive icon size
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
                        // Navigasi ke halaman Profile
                        Get.to(() => ProfileView());
                      } else if (value == 2) {
                        // Konfirmasi logout
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

              SizedBox(height: Get.height * 0.03), // Responsive spacing

              // *** Next Class Section ***
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(Get.width * 0.04), // Responsive padding
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
                            fontSize: Get.width < 400 ? 12 : 14, // Responsive font
                          ),
                        ),
                        SizedBox(height: Get.height * 0.005),
                        Text(
                          "Kecerdasan Buatan",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Get.width < 400 ? 18 : 20, // Responsive font
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
                                "Aliridho Barakbah",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Get.width < 400 ? 11 : 13, // Responsive font
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
                              "13:00 - 16:20",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Get.width < 400 ? 11 : 13, // Responsive font
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
                                "C 203",
                                style: TextStyle(
                                  color: Colors.white,
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
                  SizedBox(height: Get.height * 0.015), // Responsive spacing
                  Container(
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

              SizedBox(height: Get.height * 0.03), // Responsive spacing

              // *** Next Assignment Section ***
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tugas Mendatang",
                    style: TextStyle(
                      fontSize: Get.width < 400 ? 18 : 20, // Responsive font
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              SizedBox(height: Get.height * 0.02), // Responsive spacing
              SizedBox(
                height: Get.height * 0.18, // Responsive height
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Container(
                      width: Get.width * 0.75, // Responsive width
                      margin: EdgeInsets.only(right: Get.width * 0.04), // Responsive margin
                      padding: EdgeInsets.all(Get.width * 0.04), // Responsive padding
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
                            "Clustering Dataset Milk.csv",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: Get.width < 400 ? 14 : 16, // Responsive font
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: Get.height * 0.005),
                          Text(
                            "Kecerdasan Buatan",
                            style: TextStyle(
                              fontSize: Get.width < 400 ? 11 : 13, // Responsive font
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
                                "27 Mei 2025",
                                style: TextStyle(
                                  fontSize: Get.width < 400 ? 10 : 12, // Responsive font
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
              ),

              SizedBox(height: Get.height * 0.03), // Responsive spacing

              // *** Announcement Section ***
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
              
              SizedBox(height: Get.height * 0.02), // Bottom spacing untuk scroll
            ],
          ),
        ),
      ),
      bottomNavigationBar: const TaskBottomNavigationBar(),
    );
  }
}