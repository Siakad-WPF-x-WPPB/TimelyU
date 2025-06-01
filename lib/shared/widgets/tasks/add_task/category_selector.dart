import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategorySelector extends StatelessWidget {
  final Rx<TextEditingController> categoryController;
  final BuildContext context; // Needed for showModalBottomSheet

  const CategorySelector(
      {required this.categoryController, required this.context});

  void _showCategorySelectionDialog() {
    final List<String> categories = [
      'Matematika Diskrit', 'Pemrograman Web', 'Basis Data',
      'Sistem Operasi', 'Algoritma dan Struktur Data', 'Umum', // Added Umum
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _CategorySelectionSheetContent(
        categories: categories,
        onCategorySelected: (selectedCategory) {
          categoryController.value.text = selectedCategory;
          categoryController.refresh();
          Get.back();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          title: Text(
            categoryController.value.text,
            style: TextStyle(
              color: categoryController.value.text == 'Pilih Matakuliah'
                  ? Colors.grey[400]
                  : Colors.black,
            ),
          ),
          trailing: const Icon(Icons.keyboard_arrow_down),
          onTap: _showCategorySelectionDialog,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}

class _CategorySelectionSheetContent extends StatelessWidget {
  final List<String> categories;
  final ValueChanged<String> onCategorySelected;

  const _CategorySelectionSheetContent({
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding( // Changed Container to Padding
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Pilih Matakuliah',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(categories[index]),
                  onTap: () => onCategorySelected(categories[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}