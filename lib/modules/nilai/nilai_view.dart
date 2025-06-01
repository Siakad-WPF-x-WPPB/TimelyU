// timelyu/modules/nilai/nilai_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelyu/modules/nilai/nilai_controller.dart';
// Pastikan path ini benar dan widget TaskBottomNavigationBar terdefinisi
import 'package:timelyu/shared/widgets/bottomNavigasi.dart';

class NilaiView extends GetView<NilaiController> {
  const NilaiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          'Nilai Per Semester',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          const SizedBox(height: 8),
          _buildCalculatedMetricSection(), // Menggantikan _buildIPSSection
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.errorMessage.value != null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      controller.errorMessage.value!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              if (controller.displayedNilaiList.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Tidak ada data nilai untuk filter yang dipilih.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.displayedNilaiList.length,
                itemBuilder: (context, index) {
                  final nilaiItem = controller.displayedNilaiList[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildNilaiRow('Mata Kuliah', nilaiItem.matakuliah),
                          const SizedBox(height: 8),
                          _buildNilaiRow('Kode MK', nilaiItem.kodemk),
                          const SizedBox(height: 8),
                          _buildNilaiRow('Status', nilaiItem.status),
                          const SizedBox(height: 8),
                          _buildNilaiRow('Nilai Angka', nilaiItem.nilaiAngka.toString()),
                          const SizedBox(height: 8),
                          _buildNilaiRow('Nilai Huruf', nilaiItem.nilaiHuruf),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: TaskBottomNavigationBar(),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  label: 'Tahun Ajaran',
                  valueObservable: controller.selectedTahunAjaran,
                  items: controller.tahunAjaranList,
                  onChanged: (value) {
                    if (value != null) {
                      controller.updateTahunAjaran(value);
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdown(
                  label: 'Semester',
                  valueObservable: controller.selectedSemester,
                  items: controller.semesterList,
                  onChanged: (value) {
                    if (value != null) {
                      controller.updateSemester(value);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required RxString valueObservable,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[350]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: items.contains(valueObservable.value) ? valueObservable.value : null,
                hint: Text("Pilih $label", style: const TextStyle(fontSize: 14, color: Colors.grey)),
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: Colors.grey[700]),
                items: items.map((String itemValue) {
                  return DropdownMenuItem<String>(
                    value: itemValue,
                    child: Text(itemValue, style: const TextStyle(fontSize: 14)),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalculatedMetricSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const SizedBox.shrink();
        }
        if (controller.displayedNilaiList.isEmpty && controller.errorMessage.value == null) {
           return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.withOpacity(0.3))),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'IPS:', // Label yang benar
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87),
                  ),
                  Text(
                    controller.ipsSemester.value.toStringAsFixed(2), // Menampilkan nilai yang dihitung
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildNilaiRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Text(
          ': ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}