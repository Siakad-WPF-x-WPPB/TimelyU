import 'package:flutter/material.dart';
import 'package:timelyu/modules/task/task_controller.dart';
import 'package:timelyu/shared/widgets/tasks/status_filter_chip.dart';

class TaskFilter extends StatelessWidget {
  final TaskController controller;
  final bool isTablet;
  final bool isDesktop;

  const TaskFilter({
    required this.controller,
    required this.isTablet,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          StatusFilterChip(
              filterName: 'Semua',
              controller: controller,
              isTablet: isTablet,
              isDesktop: isDesktop),
          SizedBox(width: isDesktop ? 16 : (isTablet ? 12 : 8)),
          StatusFilterChip(
              filterName: 'Terlambat',
              controller: controller,
              isTablet: isTablet,
              isDesktop: isDesktop),
          SizedBox(width: isDesktop ? 16 : (isTablet ? 12 : 8)),
          StatusFilterChip(
              filterName: 'Belum Selesai',
              controller: controller,
              isTablet: isTablet,
              isDesktop: isDesktop),
          SizedBox(width: isDesktop ? 16 : (isTablet ? 12 : 8)),
          StatusFilterChip( // Added Selesai filter chip
              filterName: 'Selesai',
              controller: controller,
              isTablet: isTablet,
              isDesktop: isDesktop),
        ],
      ),
    );
  }
}