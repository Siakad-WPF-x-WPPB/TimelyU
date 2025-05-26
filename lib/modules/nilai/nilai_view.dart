import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelyu/modules/nilai/nilai_controller.dart';
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
          // Filter Section
          _buildFilterSection(),
          const SizedBox(height: 8),
          // Mata Kuliah List
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
                    margin: const EdgeInsets.only(bottom: 12), // Sedikit lebih banyak spasi
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2), // Shadow lebih halus
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
                          _buildNilaiRow('Nilai Angka', nilaiItem.nilaiAngka.toString()),
                          const SizedBox(height: 8),
                          _buildNilaiRow('Nilai Huruf', nilaiItem.nilaiHuruf),
                          // Jika ingin menampilkan status & semester (jika ditambahkan ke model)
                          // const SizedBox(height: 8),
                          // _buildNilaiRow('Status', nilaiItem.status),
                          // const SizedBox(height: 8),
                          // _buildNilaiRow('Semester', nilaiItem.semester),
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
      bottomNavigationBar: TaskBottomNavigationBar(), // Pastikan widget ini ada dan path benar
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white, // Atau sedikit berbeda untuk memisahkan dari list
      // Bisa ditambahkan shadow jika diinginkan
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.grey.withOpacity(0.1),
      //       spreadRadius: 1,
      //       blurRadius: 3,
      //       offset: Offset(0, 1),
      //     ),
      //   ],
      // ),
      child: Column(
        children: [
          Row(
            children: [
              // Tahun Ajaran Dropdown
              Expanded(
                child: _buildDropdown(
                  label: 'Tahun Ajaran',
                  value: controller.selectedTahunAjaran,
                  items: controller.tahunAjaranList,
                  onChanged: (value) {
                    if (value != null) {
                      controller.updateTahunAjaran(value);
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              // Semester Dropdown
              Expanded(
                child: _buildDropdown(
                  label: 'Semester',
                  value: controller.selectedSemester,
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
    required RxString value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15, // Sedikit lebih kecil
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), // Sesuaikan padding vertikal
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[350]!), // Border lebih jelas
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value.value,
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

  Widget _buildNilaiRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100, // Lebar label konsisten
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54, // Warna label lebih soft
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
              // fontWeight: FontWeight.w500, // Bisa ditambahkan jika ingin nilai lebih tebal
            ),
            textAlign: TextAlign.left, // Ubah ke left jika lebih sesuai
          ),
        ),
      ],
    );
  }
}