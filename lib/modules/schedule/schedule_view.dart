import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelyu/data/models/schedule_today.dart';
import 'package:timelyu/modules/schedule/full_schedule_view.dart';
import 'package:timelyu/modules/schedule/jadwal_hariIni_controller.dart';
import 'package:timelyu/modules/schedule/jadwal_besok_controller.dart';
import 'package:timelyu/shared/widgets/bottomNavigasi.dart';
// Tambahkan import untuk notifikasi
import 'package:timelyu/data/services/schedule_notification_service.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView>
    with WidgetsBindingObserver {
  final ScheduleTodayController _todayScheduleController = Get.put(
    ScheduleTodayController(),
  );
  final JadwalBesokController _jadwalBesokController = Get.put(
    JadwalBesokController(),
  );

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Auto-refresh untuk memastikan notifikasi selalu up-to-date
    _setupAutoRefresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _setupAutoRefresh() {
    // Refresh setiap kali jadwal berubah untuk update notifikasi
    _todayScheduleController.todaySchedule.listen((schedules) {
      _updateNotifications();
    });
  }

  Future<void> _updateNotifications() async {
    // Konversi data jadwal ke ScheduleToday untuk notifikasi
    final scheduleList =
        _todayScheduleController.todaySchedule.map((item) {
          return _convertToScheduleToday(item);
        }).toList();

    // Update notifikasi
    await ScheduleNotificationService.saveSchedules(scheduleList);
  }

  // Helper method untuk konversi data
  ScheduleToday _convertToScheduleToday(Map<String, dynamic> item) {
    return ScheduleToday(
      id: item['id']?.toString(),
      hari: _getCurrentDayName(),
      jamMulai: item['waktu'] ?? '',
      jamSelesai: _extractEndTime(item['jamKuliah'] ?? ''),
      matakuliah: item['mataKuliah'] ?? '',
      kelas: item['kelas'] ?? '',
      dosen: item['dosen'] ?? '',
      ruang: item['ruang'] ?? '',
    );
  }

  String _getCurrentDayName() {
    final weekdays = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    return weekdays[DateTime.now().weekday - 1];
  }

  String _extractEndTime(String jamKuliah) {
    if (jamKuliah.contains(' - ')) {
      return jamKuliah.split(' - ')[1];
    }
    return jamKuliah;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _todayScheduleController.fetchTodaySchedule();
            await _jadwalBesokController.fetchJadwalBesok();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                _kelasBerlangsungCard(screenWidth),
                const SizedBox(height: 30),
                _jadwalHariIni(screenWidth),
                const SizedBox(height: 30),
                _jadwalMendatang(screenWidth),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const TaskBottomNavigationBar(),
    );
  }

  Widget _kelasBerlangsungCard(double screenWidth) {
    return Obx(() {
      // Cari kelas yang sedang berlangsung
      final now = DateTime.now();
      final currentTime =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      final currentClass = _todayScheduleController.todaySchedule
          .firstWhereOrNull((item) {
            final jamKuliah = item['jamKuliah'] ?? '';
            if (jamKuliah.contains(' - ')) {
              final times = jamKuliah.split(' - ');
              final startTime = times[0];
              final endTime = times[1];
              return _isTimeBetween(currentTime, startTime, endTime);
            }
            return false;
          });

      if (currentClass == null) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.schedule, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Tidak ada kelas berlangsung',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        );
      }

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
                Text(
                  'Kelas berlangsung',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              currentClass['mataKuliah'] ?? 'N/A',
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(
                  currentClass['jamKuliah'] ?? 'N/A',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.location_on, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(
                  currentClass['ruang'] ?? 'N/A',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 32, color: Colors.black),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentClass['dosen'] ?? 'N/A',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Text(
                      'Pengajar',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
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

  Widget _jadwalHariIni(double screenWidth) {
    return Obx(() {
      if (_todayScheduleController.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: CircularProgressIndicator(),
          ),
        );
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const FullScheduleView());
                  },
                  child: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(_todayScheduleController.errorMessage.value),
              ),
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
                  Row(
                    children: [
                      Text(
                        _todayScheduleController.currentDayDisplay.value,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Indicator notifikasi aktif
                      if (_todayScheduleController.todaySchedule.isNotEmpty)
                        const Icon(
                          Icons.notifications_active,
                          color: Colors.green,
                          size: 20,
                        ),
                    ],
                  ),
                  Text(
                    _todayScheduleController.todaySchedule.isEmpty &&
                            _todayScheduleController.errorMessage.value.isEmpty
                        ? 'Tidak ada kelas hari ini.'
                        : 'Kamu mempunyai ${_todayScheduleController.todaySchedule.length} kelas hari ini.',
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => const FullScheduleView());
                },
                child: const Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_todayScheduleController.todaySchedule.isEmpty &&
              _todayScheduleController.errorMessage.value.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text("Tidak ada jadwal untuk hari ini."),
              ),
            )
          else
            Column(
              children: List.generate(
                _todayScheduleController.todaySchedule.length,
                (index) {
                  final item = _todayScheduleController.todaySchedule[index];
                  return _jadwalItem(
                    waktu: item['waktu'] ?? 'N/A',
                    mataKuliah: item['mataKuliah'] ?? 'N/A',
                    pengajar: item['dosen'] ?? 'N/A',
                    jamKuliah: item['jamKuliah'] ?? 'N/A',
                    lokasi: item['ruang'] ?? 'N/A',
                    cardColor:
                        _scheduleItemColors[index % _scheduleItemColors.length],
                    hasNotification: _hasUpcomingNotification(item),
                  );
                },
              ),
            ),
        ],
      );
    });
  }

  bool _hasUpcomingNotification(Map<String, dynamic> item) {
    try {
      final waktu = item['waktu'] ?? '';
      final now = DateTime.now();
      final timeParts = waktu.split(':');
      final classTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );
      final notificationTime = classTime.subtract(const Duration(minutes: 30));
      return notificationTime.isAfter(now);
    } catch (e) {
      return false;
    }
  }

  // Existing methods...
  Widget _jadwalMendatang(double screenWidth) {
    // ... (keep existing implementation)
    return Obx(() {
      if (_jadwalBesokController.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (_jadwalBesokController.errorMessage.value.isNotEmpty &&
          _jadwalBesokController.jadwalBesokList.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _jadwalBesokController.scheduleDayTitle.value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 20),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(_jadwalBesokController.errorMessage.value),
              ),
            ),
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _jadwalBesokController.scheduleDayTitle.value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text(
            _jadwalBesokController.jadwalBesokList.isEmpty &&
                    _jadwalBesokController.errorMessage.value.isEmpty
                ? 'Tidak ada kelas mendatang.'
                : 'Kamu mempunyai ${_jadwalBesokController.jadwalBesokList.length} kelas mendatang.',
          ),
          const SizedBox(height: 20),
          if (_jadwalBesokController.jadwalBesokList.isEmpty &&
              _jadwalBesokController.errorMessage.value.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text("Tidak ada jadwal mendatang."),
              ),
            )
          else
            Column(
              children: List.generate(
                _jadwalBesokController.jadwalBesokList.length,
                (index) {
                  final item = _jadwalBesokController.jadwalBesokList[index];
                  return _jadwalItem(
                    waktu: item['waktu'] ?? 'N/A',
                    mataKuliah: item['mataKuliah'] ?? 'N/A',
                    pengajar: item['dosen'] ?? 'N/A',
                    jamKuliah: item['jamKuliah'] ?? 'N/A',
                    lokasi: item['ruang'] ?? 'N/A',
                    cardColor:
                        _scheduleItemColors[(index + 2) %
                            _scheduleItemColors.length],
                    hasNotification:
                        false, // Jadwal besok tidak ada notifikasi hari ini
                  );
                },
              ),
            ),
        ],
      );
    });
  }

  Widget _jadwalItem({
    required String waktu,
    required String mataKuliah,
    required String pengajar,
    required String jamKuliah,
    required String lokasi,
    required Color cardColor,
    bool hasNotification = false,
  }) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          mataKuliah,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasNotification)
                        Icon(
                          Icons.notifications,
                          size: 16,
                          color: Colors.green[600],
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: Colors.black54),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          pengajar,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.black54,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        jamKuliah,
                        style: const TextStyle(color: Colors.black87),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.black54,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          lokasi,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ),
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
