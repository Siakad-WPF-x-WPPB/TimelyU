// lib/modules/schedule/full_schedule_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelyu/modules/schedule/full_schedule_controller.dart'; // Ensure correct path

class FullScheduleView extends StatelessWidget {
  const FullScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    final FullScheduleController controller = Get.put(FullScheduleController());
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            Obx(() => _buildHeader(screenWidth, controller)),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Text('Error: ${controller.errorMessage.value}'),
                  );
                }
                return _buildScheduleContent(controller, screenWidth);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double screenWidth, FullScheduleController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 24,
                ),
                onPressed: () => Get.back(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 60), // Adjust spacing as needed
              const Text(
                'Jadwal Kuliah',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildDropdownField(
                  label: 'Tahun Ajar',
                  value:
                      controller.tahunAjarDisplay.value.isNotEmpty
                          ? controller.tahunAjarDisplay.value
                          : "Loading...", // Show loading or default
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdownField(
                  label: 'Semester',
                  value:
                      controller.semesterDisplay.value.isNotEmpty
                          ? controller.semesterDisplay.value
                          : "Loading...", // Show loading or default
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleContent(
    FullScheduleController controller,
    double screenWidth,
  ) {
    // Filter out days that have no schedules to display, unless you want to show all days from controller.days
    List<String> daysWithSchedules =
        controller.days.where((day) {
          final schedulesForDay = controller.scheduleData[day];
          return schedulesForDay != null && schedulesForDay.isNotEmpty;
        }).toList();

    if (daysWithSchedules.isEmpty && !controller.isLoading.value) {
      return const Center(
        child: Text(
          'Tidak ada jadwal disetujui untuk ditampilkan.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: controller.days.length, // Iterate through all defined days
      itemBuilder: (context, index) {
        final day = controller.days[index];
        final schedulesForDay = controller.scheduleData[day] ?? [];
        return Padding(
          padding: EdgeInsets.only(
            bottom: index == controller.days.length - 1 ? 0 : 32,
          ),
          child: _buildDaySection(day, schedulesForDay),
        );
      },
    );
  }

  Widget _buildDaySection(String day, List<Map<String, dynamic>> schedules) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          day,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        if (schedules.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Center(
              child: Text(
                'Tidak ada jadwal',
                style: TextStyle(color: Colors.grey[500], fontSize: 16),
              ),
            ),
          )
        else
          ...schedules.map((schedule) => _buildScheduleCard(schedule)).toList(),
      ],
    );
  }

  Widget _buildScheduleCard(Map<String, dynamic> schedule) {
    Color cardColor;
    switch (schedule['mataKuliah'] as String? ?? '') {
      case 'Kecerdasan Buatan':
        cardColor = const Color(0xFFE8D5FF);
        break;
      case 'Workshop Pemrograman Perangkat Bergerak':
        cardColor = const Color(0xFFD4F7D4);
        break;
      case 'Workshop Pemrograman Framework':
        cardColor = const Color(0xFFFFE4E4);
        break;
      case 'Workshop Administrasi Jaringan':
        cardColor = const Color(0xFFE0F2FE);
        break;
      case 'Workshop Pengembangan Perangkat Lunak berbasis Agile':
        cardColor = const Color(0xFFFFF4E6);
        break;
      case 'Dasar Teknik Elektronika':
        cardColor = Colors.blue[100]!; // Example color
        break;
      case 'VLSI Design':
        cardColor = Colors.green[100]!; // Example color
        break;
      case 'Workshop Aplikasi Berbasis Web': // This was approved in API sample
        cardColor = Colors.orange[100]!; // Example color
        break;
      case 'Rekayasa Perangkat Lunak':
        cardColor = Colors.purple[100]!; // Example color
        break;
      case 'Dasar Teknik Listrik': // This was approved in API sample
        cardColor = Colors.teal[100]!; // Example color
        break;
      default:
        cardColor =
            Colors
                .primaries[((schedule['mataKuliah'] as String? ?? '')
                        .hashCode) %
                    Colors.primaries.length]
                .shade100;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            schedule['mataKuliah'] as String? ?? 'N/A',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person_outline, size: 16, color: Colors.grey[700]),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  schedule['pengajar'] as String? ?? 'N/A',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.access_time_outlined,
                size: 16,
                color: Colors.grey[700],
              ),
              const SizedBox(width: 6),
              Text(
                schedule['jamKuliah'] as String? ?? 'N/A',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              const SizedBox(width: 24),
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Colors.grey[700],
              ),
              const SizedBox(width: 6),
              Text(
                schedule['lokasi'] as String? ?? 'N/A',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
