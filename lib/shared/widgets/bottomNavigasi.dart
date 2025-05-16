import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      selectedItemColor: Colors.blue,
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
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: currentIndex == 0 ? Colors.blue : Colors.grey,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.list_alt,
            color: currentIndex == 1 ? Colors.blue : Colors.grey,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.bookmark,
            color: currentIndex == 2 ? Colors.blue : Colors.grey,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.notifications,
            color: currentIndex == 3 ? Colors.blue : Colors.grey,
          ),
          label: '',
        ),
      ],
    );
  }
}
