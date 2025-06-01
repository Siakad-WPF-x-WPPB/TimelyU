import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SubmitBottom extends StatelessWidget {
  final RxBool isSubmitting;
  final VoidCallback onSubmit;

  const SubmitBottom({required this.isSubmitting, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: Obx(
        () => ElevatedButton(
          onPressed: isSubmitting.value ? null : onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF003087),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            disabledBackgroundColor: const Color(0xFF003087).withOpacity(0.5),
          ),
          child: isSubmitting.value
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : const Text(
                  'Tambahkan Tugas',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}