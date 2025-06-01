import 'package:flutter/material.dart';
import 'package:timelyu/data/models/task_model.dart';
import 'package:timelyu/modules/task/task_controller.dart';

class TaskCheckbox extends StatelessWidget {
  final TaskModel task;
  final TaskController controller;
  final bool isTablet;
  final bool isDesktop;

  const TaskCheckbox({
    required this.task,
    required this.controller,
    required this.isTablet,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.toggleTaskCompletion(task.id, !task.isDone);
      },
      child: Container(
        width: isDesktop ? 28 : (isTablet ? 26 : 24),
        height: isDesktop ? 28 : (isTablet ? 26 : 24),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: task.isDone ? const Color(0xFF4CAF50) : Colors.grey[400]!,
            width: 2,
          ),
          color: task.isDone ? const Color(0xFF4CAF50) : Colors.transparent,
        ),
        child: task.isDone
            ? Icon(
                Icons.check,
                color: Colors.white,
                size: isDesktop ? 18 : (isTablet ? 17 : 16),
              )
            : null,
      ),
    );
  }
}