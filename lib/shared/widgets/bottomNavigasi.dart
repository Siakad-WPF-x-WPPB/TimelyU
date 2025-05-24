import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';

class TaskBottomNavigationBar extends StatelessWidget {
  const TaskBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final route = Get.currentRoute;
    int currentIndex = 0;

    if (route == '/home') {
      currentIndex = 0;
    } else if (route == '/schedule') {
      currentIndex = 1;
    } else if (route == '/tasks') {
      currentIndex = 2;
    } else if (route == '/frs') {
      currentIndex = 3;
    }

    return CircleNavBar(
      activeIcons: const [
        Icon(Icons.home, color: Colors.white),
        Icon(Icons.list_alt, color: Colors.white),
        Icon(Icons.bookmark, color: Colors.white),
        Icon(Icons.notifications, color: Colors.white),
      ],
      inactiveIcons: [
        Icon(Icons.home, color: Colors.grey[400]),
        Icon(Icons.list_alt, color: Colors.grey[400]),
        Icon(Icons.bookmark, color: Colors.grey[400]),
        Icon(Icons.notifications, color: Colors.grey[400]),
      ],
      color: Colors.white,
      circleColor: Colors.blue,
      height: 70,
      circleWidth: 65,
      activeIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            Get.offNamed('/home');
            break;
          case 1:
            Get.offNamed('/schedule');
            break;
          case 2:
            Get.offNamed('/tasks');
            break;
          case 3:
            Get.offNamed('/frs');
            break;
        }
      },
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      cornerRadius: BorderRadius.circular(20),
      shadowColor: Colors.grey.withOpacity(0.3),
      elevation: 8,
    );
  }
}