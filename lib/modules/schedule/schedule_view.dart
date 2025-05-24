import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelyu/modules/schedule/full_schedule_view.dart';
import 'package:timelyu/shared/widgets/bottomNavigasi.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
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
              _kelasBerlangsungCard(screenWidth),
              const SizedBox(height: 30),
              _jadwalHariIni(screenWidth),
              const SizedBox(height: 30),
              _jadwalMendatang(screenWidth),
            ],
          ),
        ),
      ),
      bottomNavigationBar: TaskBottomNavigationBar(),
    );
  }

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
            'Kecerdasan Buatan',
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
              const Text(
                '13:00 - 16:20',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.location_on, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              const Text('C 203', style: TextStyle(color: Colors.white)),
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
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alirdho Barakbah',
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

  Widget _jadwalHariIni(double screenWidth) {
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
                Text('Kamu mempunyai 2 kelas hari ini.'),
              ],
            ),
            GestureDetector(onTap: () {
              Get.to(const FullScheduleView());
            },child: Icon(Icons.arrow_forward_ios)),
          ],
        ),
        const SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          verticalDirection: VerticalDirection.up,
          children: [
            Column(
              children: [
                _jadwalItem(
                  waktu: '08:00',
                  mataKuliah: 'Kecerdasan Buatan',
                  pengajar: 'Alirdho Barakbah',
                  jamKuliah: '08:00 - 09:40',
                  lokasi: 'HH 101',
                  cardColor: Colors.purple.shade50,
                ),
                _jadwalItem(
                  waktu: '13:00',
                  mataKuliah: 'Administrasi Basis Data',
                  pengajar: 'Weny Mistarika Rahmawati',
                  jamKuliah: '13:00 - 15:30',
                  lokasi: 'C 105',
                  cardColor: Colors.green.shade50,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _jadwalMendatang(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jadwal Mendatang',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const Text('Kamu ada 1 kelas mendatang loh.'),
        const SizedBox(height: 20),
        Column(
          children: [
            _jadwalItem(
              waktu: '08:00',
              mataKuliah: 'Kecerdasan Buatan',
              pengajar: 'Alirdho Barakbah',
              jamKuliah: '08:00 - 09:40',
              lokasi: 'HH 101',
              cardColor: Colors.purple.shade50,
            ),
            _jadwalItem(
              waktu: '13:00',
              mataKuliah: 'Administrasi Basis Data',
              pengajar: 'Weny Mistarika Rahmawati',
              jamKuliah: '13:00 - 15:30',
              lokasi: 'C 105',
              cardColor: Colors.green.shade50,
            ),
          ],
        ),
      ],
    );
  }

  Widget _jadwalItem({
    required String waktu,
    required String mataKuliah,
    required String pengajar,
    required String jamKuliah,
    required String lokasi,
    required Color cardColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Waktu di kiri
          SizedBox(
            width: 50,
            child: Text(
              waktu,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          // Card di kanan
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
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16),
                      const SizedBox(width: 4),
                      Text(pengajar),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16),
                      const SizedBox(width: 4),
                      Text(jamKuliah),
                      const SizedBox(width: 12),
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 4),
                      Text(lokasi),
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
