import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelyu/modules/task/add_task.dart';

class TaskAddFloat extends StatelessWidget {
  final bool isTablet;
  final bool isDesktop;
  const TaskAddFloat({required this.isTablet, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Get.to(() => AddTaskScreen()),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          isDesktop ? 36 : (isTablet ? 34 : 32),
        ),
      ),
      backgroundColor: const Color(0xFF00509D),
      child: Icon(
        Icons.add,
        color: Colors.white,
        size: isDesktop ? 36.0 : (isTablet ? 34.0 : 30.0),
      ),
    );
  }
}