import 'package:flutter/material.dart';

class TaskStatus extends StatelessWidget {
  final String status;
  final Color color;
  final bool isTablet;
  final bool isDesktop;

  const TaskStatus({
    required this.status,
    required this.color,
    required this.isTablet,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 12 : (isTablet ? 10 : 8),
        vertical: isDesktop ? 6 : (isTablet ? 5 : 4),
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(
          isDesktop ? 14 : (isTablet ? 13 : 12),
        ),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: isDesktop ? 14 : (isTablet ? 13 : 12),
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
