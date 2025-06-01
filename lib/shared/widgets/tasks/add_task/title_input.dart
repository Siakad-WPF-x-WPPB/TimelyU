import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TitleInput extends StatelessWidget {
  final Rx<TextEditingController> titleController;
  const TitleInput({required this.titleController});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TextField(
        controller: titleController.value,
        decoration: InputDecoration(
          hintText: 'Masukkan Judul Tugas',
          hintStyle: TextStyle(color: Colors.grey[400]),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          suffixText: '${titleController.value.text.length}/50 Karakter', // Example length
          suffixStyle: TextStyle(color: Colors.grey[400], fontSize: 12),
        ),
        maxLength: 50, // Enforce max length
        buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null, // Hide default counter
        onChanged: (value) {
          // Obx will rebuild due to titleController.value.text change
          titleController.refresh(); // Explicitly refresh if needed for suffixText
        },
      ),
    );
  }
}