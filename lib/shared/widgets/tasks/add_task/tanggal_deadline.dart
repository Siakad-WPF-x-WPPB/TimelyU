import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TanggalDeadline extends StatelessWidget {
  final Rx<DateTime?> selectedDeadline;
  final BuildContext context; // Needed for showDatePicker

  const TanggalDeadline(
      {required this.selectedDeadline, required this.context});

  Future<void> _pickDeadlineDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDeadline.value ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)), // Allow past dates for flexibility
      lastDate: DateTime(2101),
      locale: const Locale('id', 'ID'), // Indonesian locale
    );
    if (pickedDate != null) {
      selectedDeadline.value = pickedDate;
    }
  }

  String _formatDisplayDate(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: _pickDeadlineDate,
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
                selectedDeadline.value != null
                    ? _formatDisplayDate(selectedDeadline.value!)
                    : 'Pilih Tanggal Deadline',
                style: TextStyle(
                  color: selectedDeadline.value != null
                      ? Colors.black
                      : Colors.grey[600],
                  fontSize: 15, // Standardized font size
                ),
              ),
              const Icon(Icons.calendar_today, size: 20), // Standardized icon size
            ],
          ),
        ),
      ),
    );
  }
}