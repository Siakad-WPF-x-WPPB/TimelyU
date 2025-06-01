import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelyu/shared/widgets/tasks/add_task/duration_picker.dart';

class WorkDuration extends StatelessWidget {
  final Rx<TextEditingController> durationController;
  final BuildContext context; // Needed for showModalBottomSheet

  const WorkDuration(
      {required this.durationController, required this.context});

  void _showDurationPickerDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DurationPicker(
        initialHours: _parseDuration(durationController.value.text).$1,
        initialMinutes: _parseDuration(durationController.value.text).$2,
        onDurationChanged: (hours, minutes) {
          String result = '';
          if (hours > 0) result += '$hours jam';
          if (minutes > 0) {
            if (result.isNotEmpty) result += ' ';
            result += '$minutes menit';
          }
          durationController.value.text =
              result.isEmpty ? '30 menit' : result; // Default if empty
          durationController.refresh();
        },
      ),
    );
  }

  // Helper to parse "X jam Y menit" back to integers
  (int, int) _parseDuration(String durationText) {
    int hours = 0;
    int minutes = 0;
    if (durationText.isEmpty) return (0,30); // Default to 30 minutes if picker is opened with empty field

    final jamMatch = RegExp(r'(\d+)\s*jam').firstMatch(durationText);
    if (jamMatch != null) hours = int.parse(jamMatch.group(1)!);

    final menitMatch = RegExp(r'(\d+)\s*menit').firstMatch(durationText);
    if (menitMatch != null) minutes = int.parse(menitMatch.group(1)!);
    
    return (hours, minutes);
  }


  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: _showDurationPickerDialog,
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
                durationController.value.text.isEmpty
                    ? 'Pilih Durasi'
                    : durationController.value.text,
                style: TextStyle(
                  color: durationController.value.text.isEmpty
                      ? Colors.grey[600]
                      : Colors.black,
                  fontSize: 15, // Standardized font size
                ),
              ),
              const Icon(Icons.schedule, size: 20), // Standardized icon size
            ],
          ),
        ),
      ),
    );
  }
}