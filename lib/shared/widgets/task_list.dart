import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelyu/modules/task/task_controller.dart';
import 'package:timelyu/shared/widgets/task_empty.dart';
import 'package:timelyu/shared/widgets/task_item.dart';

class TaskListView extends StatelessWidget {
  final TaskController controller;

  const TaskListView({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<TaskController>(
      builder: (ctrl) => ctrl.filteredTasks.isEmpty
          ? const EmptyTaskView()
          : ListView.builder(
              itemCount: ctrl.filteredTasks.length,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) {
                final task = ctrl.filteredTasks[index];
                return TaskItem(task: task, controller: controller);
              },
            ),
    );
  }
}