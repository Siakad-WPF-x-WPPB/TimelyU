import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'task_controller.dart';
import 'package:timelyu/data/models/task_model.dart';

class AddTaskScreen extends GetView<TaskController> {
  AddTaskScreen({Key? key}) : super(key: key);

  // Pindahkan controller ke level class, bukan di dalam build
  final titleController = TextEditingController().obs;
  final durationController = TextEditingController().obs;
  final categoryController =
      TextEditingController(text: 'Pilih Matakuliah').obs;

  final isAlarmEnabled = false.obs;
  final selectedDeadline = Rx<DateTime?>(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Tugas',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul Tugas Field
              Obx(
                () => TextField(
                  controller: titleController.value,
                  decoration: InputDecoration(
                    hintText: 'Masukkan Judul Tugas',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    suffixText:
                        '${titleController.value.text.length}/20 Karakter',
                    suffixStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                  onChanged: (value) {
                    // Update character count dengan rebuild menggunakan Obx
                    titleController.refresh();
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Pilih Matakuliah Dropdown
              Obx(
                () => Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    title: Text(
                      categoryController.value.text,
                      style: TextStyle(
                        color:
                            categoryController.value.text == 'Pilih Matakuliah'
                                ? Colors.grey[400]
                                : Colors.black,
                      ),
                    ),
                    trailing: const Icon(Icons.keyboard_arrow_down),
                    onTap: () {
                      // Show dropdown or navigation to select course
                      _showCategorySelection(context, categoryController.value);
                    },
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Deadline Section
              const Text(
                'Deadline',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 8),

              // Deadline Picker
              Obx(
                () => Container(
                  width: double.infinity,
                  child: InkWell(
                    onTap: () => _selectDeadline(context, selectedDeadline),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedDeadline.value != null
                                ? DateFormat(
                                  'dd MMMM yyyy',
                                ).format(selectedDeadline.value!)
                                : 'Pilih Deadline',
                            style: TextStyle(
                              color:
                                  selectedDeadline.value != null
                                      ? Colors.black
                                      : Colors.grey[600],
                            ),
                          ),
                          const Icon(Icons.calendar_today, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Estimasi Kerja Section
              const Text(
                'Estimasi Kerja',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 8),

              // Duration Picker
              Obx(
                () => Container(
                  width: double.infinity,
                  child: InkWell(
                    onTap: () => _showCustomDurationPicker(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
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
                              color:
                                  durationController.value.text.isEmpty
                                      ? Colors.grey[600]
                                      : Colors.black,
                            ),
                          ),
                          const Icon(Icons.access_time, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Alarm Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Alarm',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Obx(
                    () => Switch(
                      value: isAlarmEnabled.value,
                      onChanged: (value) {
                        isAlarmEnabled.value = value;
                      },
                      activeColor: Colors.white,
                      activeTrackColor: Colors.blue,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 220),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    // Validate and create task
                    if (titleController.value.text.isNotEmpty) {
                      final newTask = TaskModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: titleController.value.text,
                        description:
                            categoryController.value.text != 'Pilih Matakuliah'
                                ? categoryController.value.text
                                : 'Umum',
                        status: 'Belum Selesai',
                        date:
                            selectedDeadline.value != null
                                ? DateFormat(
                                  'd MMMM yyyy',
                                ).format(selectedDeadline.value!)
                                : DateFormat(
                                  'd MMMM yyyy',
                                ).format(DateTime.now()),
                        time:
                            durationController.value.text.isNotEmpty
                                ? durationController.value.text
                                : '1 jam',
                      );
                      controller.addTask(newTask);
                      Get.back();
                    } else {
                      Get.snackbar(
                        'Error',
                        'Judul tugas tidak boleh kosong',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    
                    backgroundColor: const Color(0xFF003087),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Tambahkan Tugas',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCategorySelection(
    BuildContext context,
    TextEditingController controller,
  ) {
    final List<String> categories = [
      'Matematika Diskrit',
      'Pemrograman Web',
      'Basis Data',
      'Sistem Operasi',
      'Algoritma dan Struktur Data',
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: const [
                      Text(
                        'Pilih Matakuliah',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(categories[index]),
                        onTap: () {
                          controller.text = categories[index];
                          Get.back();
                          // Memastikan UI diperbarui dengan nilai baru
                          categoryController.refresh();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _selectDeadline(BuildContext context, Rx<DateTime?> selectedDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      selectedDate.value = pickedDate;
    }
  }

  // Metode baru untuk custom duration picker
  void _showCustomDurationPicker(BuildContext context) {
    final hours = RxInt(0);
    final minutes = RxInt(0);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
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
                Obx(
                  () => Text(
                    '${hours.value} Jam ${minutes.value} Menit',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Row untuk jam dan menit wheel picker
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Kolom untuk Jam
                      Expanded(
                        child: Column(
                          children: [
                            // Label Jam
                            const Text(
                              'Jam',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Jam Picker
                            Expanded(
                              child: ListWheelScrollView.useDelegate(
                                itemExtent: 50,
                                perspective: 0.01,
                                diameterRatio: 1.2,
                                physics: const FixedExtentScrollPhysics(),
                                onSelectedItemChanged: (index) {
                                  hours.value = index;
                                },
                                childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: 24,
                                  builder: (context, index) {
                                    return Container(
                                      alignment: Alignment.center,
                                      child: Obx(
                                        () => Text(
                                          index.toString().padLeft(2, '0'),
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight:
                                                hours.value == index
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                            color:
                                                hours.value == index
                                                    ? Colors.blue
                                                    : Colors.black,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Separator
                      Container(
                        padding: const EdgeInsets.only(top: 35),
                        alignment: Alignment.center,
                        child: const Text(
                          ':',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Kolom untuk Menit
                      Expanded(
                        child: Column(
                          children: [
                            // Label Menit
                            const Text(
                              'Menit',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Menit Picker
                            Expanded(
                              child: ListWheelScrollView.useDelegate(
                                itemExtent: 50,
                                perspective: 0.01,
                                diameterRatio: 1.2,
                                physics: const FixedExtentScrollPhysics(),
                                onSelectedItemChanged: (index) {
                                  minutes.value = index;
                                },
                                childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: 60,
                                  builder: (context, index) {
                                    return Container(
                                      alignment: Alignment.center,
                                      child: Obx(
                                        () => Text(
                                          index.toString().padLeft(2, '0'),
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight:
                                                minutes.value == index
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                            color:
                                                minutes.value == index
                                                    ? Colors.blue
                                                    : Colors.black,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Tombol aksi
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tombol Batal
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.blue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Batal',
                            style: TextStyle(fontSize: 16, color: Colors.blue),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Tombol OK
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            String result = '';
                            if (hours.value > 0) {
                              result += '${hours.value} jam';
                            }
                            if (minutes.value > 0) {
                              if (result.isNotEmpty) result += ' ';
                              result += '${minutes.value} menit';
                            }
                            if (result.isEmpty) {
                              result = '30 menit'; // Default if both are 0
                            }
                            durationController.value.text = result;
                            durationController.refresh();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'OK',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
