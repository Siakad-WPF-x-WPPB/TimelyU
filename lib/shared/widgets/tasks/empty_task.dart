import 'package:flutter/material.dart';

class EmptyTask extends StatelessWidget {
  final bool isTablet;
  final bool isDesktop;

  const EmptyTask({required this.isTablet, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: isDesktop ? 80 : (isTablet ? 72 : 64),
            color: Colors.grey[400],
          ),
          SizedBox(height: isTablet ? 24 : 16),
          Text(
            'Tidak ada tugas',
            style: TextStyle(
              fontSize: isDesktop ? 24 : (isTablet ? 20 : 18),
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: isTablet ? 12 : 8),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 100 : (isTablet ? 60 : 40),
            ),
            child: Text(
              'Tambahkan tugas baru dengan menekan tombol +',
              style: TextStyle(
                fontSize: isDesktop ? 16 : (isTablet ? 15 : 14),
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}