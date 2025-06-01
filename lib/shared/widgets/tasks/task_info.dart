import 'package:flutter/material.dart';

class TaskInfo extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isTablet;
  final bool isDesktop;

  const TaskInfo({
    required this.icon,
    required this.text,
    required this.isTablet,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: isDesktop ? 16 : (isTablet ? 15 : 14),
          color: Colors.grey[600],
        ),
        SizedBox(width: isTablet ? 6 : 4),
        Text(
          text,
          style: TextStyle(
            fontSize: isDesktop ? 14 : (isTablet ? 13 : 12),
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}