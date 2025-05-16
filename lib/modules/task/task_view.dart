import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelyu/shared/widgets/addTask_widget.dart';
import 'package:timelyu/shared/widgets/bottomNavigasi.dart';
import 'package:timelyu/shared/widgets/filter_section.dart';
import 'package:timelyu/shared/widgets/task_list.dart';
import 'task_controller.dart';

// Main Task Screen
class TaskView extends GetView<TaskController> {
  const TaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: const Text('Tugas'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Column(
          children: [
            TaskFilterSection(controller: controller),
            Expanded(child: TaskListView(controller: controller)),
          ],
        ),
      ),
      floatingActionButton: AddTaskButton(context: context),
      bottomNavigationBar: const TaskBottomNavigationBar(),
    );
  }
}
