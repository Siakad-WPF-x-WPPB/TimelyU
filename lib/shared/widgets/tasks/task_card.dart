import 'package:flutter/material.dart';
import 'package:timelyu/data/models/task_model.dart';
import 'package:timelyu/modules/task/task_controller.dart';
import 'package:timelyu/shared/widgets/tasks/task_checkbox.dart';
import 'package:timelyu/shared/widgets/tasks/task_content.dart';
import 'package:timelyu/shared/widgets/tasks/task_status.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final TaskController controller;
  final bool isTablet;
  final bool isDesktop;
  final VoidCallback onLongPress;

  const TaskCard({
    required this.task,
    required this.controller,
    required this.isTablet,
    required this.isDesktop,
    required this.onLongPress,
  });

  Color _getStatusBadgeColor() {
    // Using the controller's method for consistency if desired, or keep local
    // For this example, let's use a local one for the badge itself
    switch (task.status) {
      case 'Terlambat':
        return const Color(0xFFFF5722); // Red
      case 'Selesai':
        return const Color(0xFF4CAF50); // Green
      case 'Belum Selesai':
        return const Color(0xFF9C27B0); // Purple (Orange was in controller example)
      default:
        return const Color(0xFF2196F3); // Blue
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: isDesktop ? 16 : (isTablet ? 14 : 12)),
      child: Card(
        shadowColor: Colors.grey[300],
        elevation: 3,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(isDesktop ? 16 : (isTablet ? 14 : 12)),
          side: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
        child: InkWell(
          borderRadius:
              BorderRadius.circular(isDesktop ? 16 : (isTablet ? 14 : 12)),
          onLongPress: onLongPress,
          onTap: () {
            // Optional: Navigate to task detail screen or edit task
            // Get.to(() => EditTaskScreen(task: task));
          },
          child: Padding(
            padding: EdgeInsets.all(isDesktop ? 20 : (isTablet ? 18 : 16)),
            child: Row(
              children: [
                TaskCheckbox(
                    task: task,
                    controller: controller,
                    isTablet: isTablet,
                    isDesktop: isDesktop),
                SizedBox(width: isDesktop ? 16 : (isTablet ? 14 : 12)),
                Expanded(
                  child: TaskContent(
                      task: task, isTablet: isTablet, isDesktop: isDesktop),
                ),
                SizedBox(width: isDesktop ? 16 : (isTablet ? 14 : 12)),
                TaskStatus(
                    status: task.status,
                    color: _getStatusBadgeColor(),
                    isTablet: isTablet,
                    isDesktop: isDesktop),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
