import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FullScheduleController extends GetxController {
  var selectedDayIndex = 0.obs;
  var days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'].obs;
  
  // Updated schedule data to match Figma design
  var scheduleData = <String, List<Map<String, dynamic>>>{
    'Senin': [
      {
        'waktu': '08:00',
        'mataKuliah': 'Kecerdasan Buatan',
        'pengajar': 'Aliridho Barakbah',
        'jamKuliah': '08:00 - 09:40',
        'lokasi': 'HH 101',
        'cardColor': const Color(0xFFE8D5FF),
      },
      {
        'waktu': '13:00',
        'mataKuliah': 'Workshop Pemrograman Perangkat Bergerak',
        'pengajar': 'Fadihal Fahrul Hardiansyah',
        'jamKuliah': '13:00 - 15:30',
        'lokasi': 'C 206',
        'cardColor': const Color(0xFFD4F7D4),
      },
    ],
    'Selasa': [
      {
        'waktu': '10:30',
        'mataKuliah': 'Workshop Pemrograman Framework',
        'pengajar': 'Yanuar Risah Prayogi',
        'jamKuliah': '10:30 - 13:50',
        'lokasi': 'C 303',
        'cardColor': const Color(0xFFFFE4E4),
      },
      {
        'waktu': '13:50',
        'mataKuliah': 'Workshop Administrasi Jaringan',
        'pengajar': 'Idris Winarno',
        'jamKuliah': '13:50 - 16:20',
        'lokasi': 'C 307',
        'cardColor': const Color(0xFFE0F2FE),
      },
    ],
    'Rabu': [
      {
        'waktu': '08:00',
        'mataKuliah': 'Workshop Pengembangan Perangkat Lunak berbasis Agile',
        'pengajar': 'Dr. Budi Santoso',
        'jamKuliah': '08:00 - 11:30',
        'lokasi': 'Lab C',
        'cardColor': const Color(0xFFFFF4E6),
      },
    ],
    'Kamis': <Map<String, dynamic>>[],
    'Jumat': <Map<String, dynamic>>[],
    'Sabtu': <Map<String, dynamic>>[],
  }.obs;

  void selectDay(int index) {
    selectedDayIndex.value = index;
  }

  String get selectedDay => days[selectedDayIndex.value];
  
  List<Map<String, dynamic>> get todaySchedule => 
      scheduleData[selectedDay] ?? [];

  @override
  void onInit() {
    super.onInit();
    // Initialize with Monday (Senin)
    selectedDayIndex.value = 0;
  }

  @override
  void onClose() {
    super.onClose();
  }
}