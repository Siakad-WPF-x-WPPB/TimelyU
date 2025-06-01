// File: lib/views/add_task_view.dart (atau di mana _WheelPickerColumn didefinisikan)
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WheelPicker extends StatelessWidget {
  final String label;
  final int itemCount;
  final ValueChanged<int> onSelectedItemChanged;
  final RxInt currentValue; // Menerima RxInt

  const WheelPicker({
    // Hapus super.key jika tidak diperlukan atau tambahkan jika ada warning
    required this.label,
    required this.itemCount,
    required this.onSelectedItemChanged,
    required this.currentValue,
  });

  @override
  Widget build(BuildContext context) {
    final initialScrollItem = (currentValue.value >= 0 && currentValue.value < itemCount)
        ? currentValue.value
        : 0;
    final FixedExtentScrollController scrollController =
        FixedExtentScrollController(initialItem: initialScrollItem);

    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 8),
          Expanded(
            // ListWheelScrollView TIDAK perlu dibungkus Obx di sini
            child: ListWheelScrollView.useDelegate(
              controller: scrollController,
              itemExtent: 50,
              perspective: 0.005,
              diameterRatio: 1.2,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                onSelectedItemChanged(index);
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: itemCount,
                builder: (context, index) {
                  return Obx(() {
                    final isSelected = currentValue.value == index;
                    return Container(
                      alignment: Alignment.center,
                      child: Text(
                        index.toString().padLeft(2, '0'),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.blue : Colors.black,
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}