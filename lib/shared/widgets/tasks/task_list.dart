import 'package:flutter/material.dart';
import 'package:timelyu/modules/task/task_controller.dart';
import 'package:get/get.dart';
import 'package:timelyu/shared/widgets/tasks/empty_task.dart';
import 'package:timelyu/shared/widgets/tasks/task_card.dart';

class TaskList extends StatelessWidget {
  final TaskController controller;
  final bool isTablet;
  final bool isDesktop;

  const TaskList({
    required this.controller,
    required this.isTablet,
    required this.isDesktop,
  });

  void _showDeleteDialog(BuildContext context, String taskId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            isDesktop ? 20 : (isTablet ? 18 : 16),
          ),
        ),
        title: Text(
          'Hapus Tugas',
          style: TextStyle(
            fontSize: isDesktop ? 22 : (isTablet ? 20 : 18),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus tugas ini?',
          style: TextStyle(fontSize: isDesktop ? 16 : (isTablet ? 15 : 14)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Batal',
              style: TextStyle(
                fontSize: isDesktop ? 16 : (isTablet ? 15 : 14),
                color: Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              controller.deleteTask(taskId);
              Navigator.of(context).pop();
            },
            child: Text(
              'Hapus',
              style: TextStyle(
                color: Colors.red,
                fontSize: isDesktop ? 16 : (isTablet ? 15 : 14),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.filteredTasks.isEmpty) {
        return EmptyTask(isTablet: isTablet, isDesktop: isDesktop);
      }

      if (isDesktop) {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 12,
            childAspectRatio: 3.5, // Adjust as needed for desktop card height
          ),
          itemCount: controller.filteredTasks.length,
          itemBuilder: (context, index) {
            final task = controller.filteredTasks[index];
            return TaskCard(
              task: task,
              controller: controller,
              isTablet: isTablet,
              isDesktop: isDesktop,
              onLongPress: () => _showDeleteDialog(context, task.id),
            );
          },
        );
      }

      return ListView.builder(
        itemCount: controller.filteredTasks.length,
        itemBuilder: (context, index) {
          final task = controller.filteredTasks[index];
          return TaskCard(
            task: task,
            controller: controller,
            isTablet: isTablet,
            isDesktop: isDesktop,
            onLongPress: () => _showDeleteDialog(context, task.id),
          );
        },
      );
    });
  }
}