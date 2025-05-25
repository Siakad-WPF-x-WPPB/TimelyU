import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelyu/modules/auth/auth_controller.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF0056B3),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        if (_authController.isLoading.value && _authController.user.value == null) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF0056B3),
            ),
          );
        }

        final user = _authController.user.value;
        
        if (user == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_off,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  _authController.errorMessage.value ?? 'Data profil tidak tersedia.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _authController.fetchProfile(showLoading: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0056B3),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Muat Ulang Profil'),
                ),
                 const SizedBox(height: 10),
                 ElevatedButton(
                  onPressed: () => _authController.logout(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Login Ulang'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator( // Tambahkan RefreshIndicator
          onRefresh: () => _authController.fetchProfile(showLoading: true),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(), // Agar RefreshIndicator selalu aktif
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Header Profile Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF0056B3),
                        Color(0xFF003875),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0056B3).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user.nama, // Harusnya selalu ada jika user tidak null
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          user.nrp ?? '-',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Informasi Detail
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informasi Pribadi',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00296B),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildInfoRow(
                        icon: Icons.email,
                        label: 'Email',
                        value: user.email, // Harusnya selalu ada
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        icon: Icons.badge,
                        label: 'NRP',
                        value: user.nrp ?? '-',
                      ),
                      const SizedBox(height: 16),
                      // Ini adalah bagian yang menampilkan strip jika namaProdi null
                      _buildInfoRow(
                        icon: Icons.school,
                        label: 'Program Studi',
                        value: user.namaProdi ?? '-', // TAMPIL STRIP JIKA user.namaProdi == null
                      ),
                      const SizedBox(height: 16),
                      // Ini adalah bagian yang menampilkan strip jika namaKelas null
                      _buildInfoRow(
                        icon: Icons.class_,
                        label: 'Kelas',
                        value: user.namaKelas ?? '-', // TAMPIL STRIP JIKA user.namaKelas == null
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        icon: Icons.timeline,
                        label: 'Semester',
                        value: user.semester != null ? 'Semester ${user.semester}' : '-',
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        icon: Icons.calendar_today,
                        label: 'Tanggal Lahir', // Tambahkan jika ada
                        value: user.tanggalLahir != null
                            ? _formatDate(user.tanggalLahir!)
                            : '-',
                      ),
                       const SizedBox(height: 16),
                      _buildInfoRow(
                        icon: Icons.event_available,
                        label: 'Tanggal Masuk',
                        value: user.tanggalMasuk != null
                            ? _formatDate(user.tanggalMasuk!)
                            : '-',
                      ),
                      // Tambahkan field lain jika perlu, misal alamat
                       const SizedBox(height: 16),
                       _buildInfoRow(
                        icon: Icons.location_on,
                        label: 'Alamat',
                        value: user.alamatJalan ?? '-',
                       ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
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
                                Get.back(); // Tutup dialog
                                _authController.logout(); // Panggil fungsi logout dari controller
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
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF0056B3).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: const Color(0xFF0056B3),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF00296B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Format tanggal sederhana
  String _formatDate(DateTime date) {
    // Anda bisa menggunakan package 'intl' untuk formatting yang lebih baik
    // import 'package:intl/intl.dart';
    // return DateFormat('d MMMM yyyy', 'id_ID').format(date);
    
    // Implementasi sederhana:
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}