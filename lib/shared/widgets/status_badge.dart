import 'package:flutter/material.dart';
import 'package:timelyu/modules/task/task_controller.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final TaskController controller;

  const StatusBadge({Key? key, required this.status, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = controller.getStatusColors(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: colors['background'],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: colors['text'],
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}