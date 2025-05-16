import 'package:flutter/material.dart';
import 'package:timelyu/modules/task/task_controller.dart';

class TaskFilterSection extends StatelessWidget {
  final TaskController controller;

  const TaskFilterSection({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Using Flutter's built-in FilterChip correctly
            FilterChip(
              label: const Text('Semua'),
              selected: true, // Initial selection state
              onSelected: (bool selected) {
                // Call your controller's setFilter method
                controller.setFilter('Semua');
              },
            ),
            const SizedBox(width: 8),
            FilterChip(
              label: const Text('Selesai'),
              selected: false,
              onSelected: (bool selected) {
                controller.setFilter('Selesai');
              },
            ),
            const SizedBox(width: 8),
            FilterChip(
              label: const Text('Belum Selesai'),
              selected: false,
              onSelected: (bool selected) {
                controller.setFilter('Belum Selesai');
              },
            ),
          ],
        ),
      ),
    );
  }
}