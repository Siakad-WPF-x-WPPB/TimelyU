import 'package:flutter/material.dart';

class TaskBottomNavigationBar extends StatelessWidget {
  const TaskBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 2, // Index for Tasks tab
      onTap: (index) {
        // Handle navigation to other tabs
        // This would typically use Get.toNamed() to navigate to other screens
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: ''),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark, color: Colors.blue),
          label: '',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
      ],
    );
  }
}