import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TaskBottomNavigationBar extends StatelessWidget {
  const TaskBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final route = Get.currentRoute;
    int currentIndex = 0;

    if (route == '/home') {
      currentIndex = 0;
    } else if (route == '/schedule') {
      // Asumsi route untuk ikon kalender
      currentIndex = 1;
    } else if (route == '/tasks') {
      // Asumsi route untuk ikon pin/tugas
      currentIndex = 2;
    } else if (route == '/frs') {
      // Asumsi route untuk ikon buku/FRS
      currentIndex = 3;
    } else if (route == '/nilai') {
      // Asumsi route untuk ikon profil/nilai
      currentIndex = 4;
    }

    // Daftar ikon dan route yang sesuai
    // Perhatikan urutan ini harus sama dengan logika currentIndex di atas dan switch case di onTap
    final List<Map<String, dynamic>> navItems = [
      {
        'route': '/home',
        'icon': PhosphorIcons.house(PhosphorIconsStyle.regular),
        'activeIcon': PhosphorIcons.house(PhosphorIconsStyle.fill),
        'label': 'Home',
      },
      {
        'route': '/schedule',
        'icon': PhosphorIcons.calendarBlank(PhosphorIconsStyle.regular),
        'activeIcon': PhosphorIcons.calendarBlank(PhosphorIconsStyle.fill),
        'label': 'Schedule',
      },
      {
        'route': '/tasks',
        'icon': PhosphorIcons.pushPin(PhosphorIconsStyle.regular),
        'activeIcon': PhosphorIcons.pushPin(PhosphorIconsStyle.fill),
        'label': 'Tasks',
      },
      {
        'route': '/frs',
        'icon': PhosphorIcons.books(PhosphorIconsStyle.regular),
        'activeIcon': PhosphorIcons.books(PhosphorIconsStyle.fill),
        'label': 'FRS',
      },
      {
        'route': '/nilai',
        'icon': PhosphorIcons.user(PhosphorIconsStyle.regular),
        'activeIcon': PhosphorIcons.user(PhosphorIconsStyle.fill),
        'label': 'Nilai',
      },
    ];

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if (index >= 0 && index < navItems.length) {
          Get.offNamed(navItems[index]['route']);
        }
      },
      items:
          navItems.map((item) {
            return BottomNavigationBarItem(
              icon: Icon(item['icon'] as IconData),
              activeIcon: Icon(item['activeIcon'] as IconData),
              label: item['label'] as String,
            );
          }).toList(),
      backgroundColor: Colors.white,
      selectedItemColor: Color.fromARGB(255, 0, 80, 157),
      unselectedItemColor: Colors.grey[700],
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 5.0,
    );
  }
}
