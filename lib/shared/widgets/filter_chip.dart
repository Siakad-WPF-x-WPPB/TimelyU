import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelyu/modules/task/task_controller.dart';

class FilterChip extends StatelessWidget {
  final String label;
  final TaskController controller;

  const FilterChip({Key? key, required this.label, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<TaskController>(
      builder: (ctrl) {
        bool isSelected = ctrl.selectedFilter.value == label;
        return GestureDetector(
          onTap: () {
            controller.setFilter(label);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.grey[200],
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }
}