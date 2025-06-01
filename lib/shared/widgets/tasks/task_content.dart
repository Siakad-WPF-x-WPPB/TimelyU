import 'package:flutter/material.dart';
import 'package:timelyu/data/models/task_model.dart';
import 'package:timelyu/shared/widgets/tasks/task_info.dart';

class TaskContent extends StatelessWidget {
  final TaskModel task;
  final bool isTablet;
  final bool isDesktop;

  const TaskContent({
    required this.task,
    required this.isTablet,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // Important for Row layout
      children: [
        Text(
          task.title,
          style: TextStyle(
            fontSize: isDesktop ? 18 : (isTablet ? 17 : 16),
            fontWeight: FontWeight.w600,
            color: Colors.black,
            decoration: task.isDone ? TextDecoration.lineThrough : null,
          ),
          maxLines: isDesktop ? 2 : 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: isTablet ? 6 : 4),
        Text(
          task.description,
          style: TextStyle(
            fontSize: isDesktop ? 16 : (isTablet ? 15 : 14),
            color: Colors.grey[600],
          ),
          maxLines: isDesktop ? 2 : 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: isDesktop ? 12 : (isTablet ? 10 : 8)),
        if (isDesktop)
          Row(
            children: [
              TaskInfo(
                  icon: Icons.calendar_today,
                  text: task.date,
                  isTablet: isTablet,
                  isDesktop: isDesktop),
              const SizedBox(width: 24),
              TaskInfo(
                  icon: Icons.access_time,
                  text: task.time,
                  isTablet: isTablet,
                  isDesktop: isDesktop),
            ],
          )
        else
          Wrap(
            spacing: isTablet ? 20 : 16, // Horizontal spacing
            runSpacing: isTablet ? 6 : 4, // Vertical spacing for new line
            children: [
              TaskInfo(
                  icon: Icons.calendar_today,
                  text: task.date,
                  isTablet: isTablet,
                  isDesktop: isDesktop),
              TaskInfo(
                  icon: Icons.access_time,
                  text: task.time,
                  isTablet: isTablet,
                  isDesktop: isDesktop),
            ],
          ),
      ],
    );
  }
}