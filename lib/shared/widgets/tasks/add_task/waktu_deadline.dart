import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WaktuDeadline extends StatelessWidget {
  final Rx<TimeOfDay?> selectedTime;
  final BuildContext context; // Needed for showTimePicker

  const WaktuDeadline(
      {required this.selectedTime, required this.context});

  Future<void> _pickDeadlineTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime.value ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      selectedTime.value = pickedTime;
    }
  }

  String _formatDisplayTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm').format(dt); // Standard time format
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: _pickDeadlineTime,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), // Increased vertical padding
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedTime.value != null
                    ? _formatDisplayTime(selectedTime.value!)
                    : 'Pilih Waktu Deadline',
                style: TextStyle(
                  color: selectedTime.value != null
                      ? Colors.black
                      : Colors.grey[600],
                  fontSize: 15, // Standardized font size
                ),
              ),
              const Icon(Icons.access_time, size: 20), // Standardized icon size
            ],
          ),
        ),
      ),
    );
  }
}