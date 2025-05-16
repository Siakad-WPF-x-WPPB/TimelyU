import 'package:flutter/material.dart';
import 'package:timelyu/data/models/task_model.dart';
import 'package:timelyu/modules/task/task_controller.dart';
import 'package:timelyu/shared/widgets/status_badge.dart';

class TaskItem extends StatelessWidget {
  final TaskModel task;
  final TaskController controller;

  const TaskItem({Key? key, required this.task, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: CheckboxListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            // const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  task.description,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
                ),
                StatusBadge(status: task.status, controller: controller),
              ],
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Row(
            children: [
              Text(
                task.date,
                style: TextStyle(color: Colors.grey[600], fontSize: 12.0),
              ),
              const SizedBox(width: 8),
              Text(
                task.time,
                style: TextStyle(color: Colors.grey[600], fontSize: 12.0),
              ),
            ],
          ),
        ),
        value: task.isDone,
        onChanged: (value) {
          if (value != null) {
            controller.toggleTaskCompletion(task.id, value);
          }
        },
        controlAffinity: ListTileControlAffinity.leading,
        checkboxShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
    );
  }
}
