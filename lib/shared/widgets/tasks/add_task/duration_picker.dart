import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelyu/shared/widgets/tasks/add_task/wheel_picker.dart';

class DurationPicker extends StatefulWidget {
  final Function(int hours, int minutes) onDurationChanged;
  final int initialHours;
  final int initialMinutes;

  const DurationPicker({
    required this.onDurationChanged,
    this.initialHours = 0,
    this.initialMinutes = 30, // Default to 30 minutes
  });

  @override
  State<DurationPicker> createState() => _DurationPickerSheetContentState();
}

class _DurationPickerSheetContentState extends State<DurationPicker> {
  late RxInt hours;
  late RxInt minutes;

  @override
  void initState() {
    super.initState();
    hours = widget.initialHours.obs;
    minutes = widget.initialMinutes.obs;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Estimasi Waktu Pengerjaan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Obx(() => Text(
                '${hours.value} Jam ${minutes.value} Menit',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500),
              )),
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WheelPicker(
                  label: 'Jam',
                  itemCount: 24,
                  onSelectedItemChanged: (index) => hours.value = index,
                  currentValue: hours,
                ),
                Container( // Separator
                  padding: const EdgeInsets.only(top: 35), // Align with numbers
                  alignment: Alignment.center,
                  child: const Text(':', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ),
                WheelPicker(
                  label: 'Menit',
                  itemCount: 60,
                  onSelectedItemChanged: (index) => minutes.value = index,
                  currentValue: minutes,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.blue),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 16)),
                    child: const Text('Batal',
                        style: TextStyle(fontSize: 16, color: Colors.blue)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onDurationChanged(hours.value, minutes.value);
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 16)),
                    child: const Text('OK',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}