import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelyu/modules/task/task_controller.dart';

class StatusFilterChip extends StatelessWidget {
  final String filterName;
  final TaskController controller;
  final bool isTablet;
  final bool isDesktop;

  const StatusFilterChip({
    required this.filterName,
    required this.controller,
    required this.isTablet,
    required this.isDesktop,
  });

  Color _getChipColor() {
    if (filterName == 'Semua') return const Color(0xFF2196F3);
    if (filterName == 'Terlambat') return const Color(0xFFFF5722);
    if (filterName == 'Belum Selesai') return const Color(0xFF9C27B0);
    if (filterName == 'Selesai') return const Color(0xFF4CAF50); // Color for Selesai
    return const Color(0xFF2196F3); // Default
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isSelected = controller.selectedFilter.value == filterName;
      return GestureDetector(
        onTap: () => controller.setFilter(filterName),
        child: Container(
          height: isDesktop ? 40 : (isTablet ? 36 : 32),
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 24 : (isTablet ? 20 : 16),
          ),
          decoration: BoxDecoration(
            color: isSelected ? _getChipColor() : Colors.grey[100],
            borderRadius: BorderRadius.circular(
              isDesktop ? 20 : (isTablet ? 18 : 16),
            ),
          ),
          child: Center(
            child: Text(
              filterName,
              style: TextStyle(
                fontSize: isDesktop ? 16 : (isTablet ? 15 : 14),
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    });
  }
}