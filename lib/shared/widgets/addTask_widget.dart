import 'package:flutter/material.dart';
import 'package:timelyu/modules/task/add_task.dart';

class AddTaskButton extends StatelessWidget {
  final BuildContext context;

  const AddTaskButton({Key? key, required this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Show dialog to add new task
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddTaskScreen()),
        );
      },
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: const Icon(Icons.add),
    );
  }
}