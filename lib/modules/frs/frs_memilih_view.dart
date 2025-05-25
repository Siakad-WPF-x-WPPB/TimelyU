import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelyu/data/models/pemilihan_frs_model.dart';
import 'package:timelyu/modules/frs/frs_controller.dart';

class FrsMemilihView extends StatelessWidget {
  final FrsController controller = Get.put(FrsController());

  FrsMemilihView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Aksi untuk tombol kembali
            if (Get.previousRoute.isNotEmpty) {
              Get.back();
            } else {
              // Jika tidak ada route sebelumnya, mungkin keluar aplikasi atau ke home
              print("Tidak ada halaman sebelumnya");
            }
          },
        ),
        title: const Text('Pemilihan FRS'),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.menu),
          //   onPressed: () {
          //     // Aksi untuk tombol menu
          //   },
          // ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tahun Ajar', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            hint: const Text('Pilih Tahun'),
                            items: ['2023/2024', '2024/2025']
                                .map((label) => DropdownMenuItem(
                                      value: label,
                                      child: Text(label),
                                    ))
                                .toList(),
                            onChanged: (value) {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           const Text('Semester', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                             decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            hint: const Text('Pilih Semester'),
                            items: ['Ganjil', 'Genap']
                                .map((label) => DropdownMenuItem(
                                      value: label,
                                      child: Text(label),
                                    ))
                                .toList(),
                            onChanged: (value) {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  onChanged: (value) {
                    // Implementasi logika search jika diperlukan
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Silahkan pilih FRS:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.pemilihanFRS.isEmpty) {
                return const Center(child: Text("Tidak ada mata kuliah tersedia."));
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: controller.pemilihanFRS.length,
                itemBuilder: (context, index) {
                  final course = controller.pemilihanFRS[index];
                  return Obx(() => _buildCourseCard(context, course));
                },
              );
            }),
          ),
          _buildBottomSummary(),
        ],
      ),
    );
  }

Widget _buildCourseCard(BuildContext context, PemilihanFrsModel course) {
  final bool selected = course.isSelected.value;
  final Color textColor = selected ? Colors.white : Colors.black;
  final Color subtitleColor = selected ? Colors.white70 : Colors.grey[700]!;

  return Card(
    elevation: 2.0,
    margin: const EdgeInsets.symmetric(vertical: 8.0),
    color: selected ? const Color.fromARGB(255, 1, 63, 117) : Colors.white,
    child: InkWell(
      onTap: () {
        controller.toggleCourseSelection(course);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${course.nama} (SKS ${course.sks})',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.person_outline, size: 16, color: subtitleColor),
                const SizedBox(width: 8),
                Text(course.dosen, style: TextStyle(color: subtitleColor)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.schedule_outlined, size: 16, color: subtitleColor),
                const SizedBox(width: 8),
                Text(course.jadwal, style: TextStyle(color: subtitleColor)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.class_outlined, size: 16, color: subtitleColor),
                const SizedBox(width: 8),
                Text(course.kelas, style: TextStyle(color: subtitleColor)),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}


  Widget _buildBottomSummary() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() => Text(
                'Mengambil / Sisa : ${controller.selectedSKS.value} / ${controller.remainingSKS} SKS',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              )),
          ElevatedButton(
            onPressed: () {
              controller.submitFRS();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Ambil', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}