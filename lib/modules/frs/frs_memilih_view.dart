import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:timelyu/data/models/jadwal_matkul.model.dart';
import 'package:timelyu/modules/frs/frs_controller.dart';
import 'package:timelyu/shared/widgets/bottomNavigasi.dart'; // Pastikan path ini benar
// import 'package:timelyu/shared/widgets/bottomNavigasi.dart'; // Diasumsikan diimpor jika digunakan

// --- AppColors ---
class AppColors {
  static const Color primary = Color(0xFF007AFF);
  static const Color primaryLight = Color(0xFFE6F2FF);
  static const Color accent = Color(0xFFFF9500);
  static const Color textTitle = Color(0xFF1D1D1F);
  static const Color textBody = Color(0xFF3C3C43);
  static const Color textBodySecondary = Color(0xFF6E6E73);
  static const Color background = Colors.white;
  static const Color cardBackground = Colors.white;
  static const Color cardSelectedBackground = Color(0xFFE6F2FF);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color iconColor = Color(0xFF6E6E73);
  static const Color buttonDisabled = Color(0xFFBDBDBD);
}
// --- End AppColors ---


class FrsInputView extends GetView<FrsController> {
  const FrsInputView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    // Jika controller belum di-inject, Anda bisa melakukannya di sini atau di Bindings
    // Get.lazyPut(() => FrsController(), fenix: true); // fenix: true agar tidak error jika sudah ada

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          // Menggunakan ikon yang lebih standar untuk kembali
          icon: Icon(PhosphorIcons.arrowLeft(PhosphorIconsStyle.regular), color: AppColors.textTitle),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Pemilihan FRS',
          style: TextStyle(
            color: AppColors.textTitle,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0.8,
        shadowColor: Colors.grey.withOpacity(0.2),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: _buildDropdownSection(context),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Cari Mata Kuliah, Dosen...',
                prefixIcon: Icon(PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.regular), color: AppColors.iconColor, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: AppColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: AppColors.divider, width: 1.2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                filled: true,
                fillColor: AppColors.background,
                 suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
                      ? IconButton(
                          icon: Icon(PhosphorIcons.xCircle(PhosphorIconsStyle.fill), color: AppColors.iconColor, size: 20),
                          onPressed: () {
                            searchController.clear();
                            controller.updateSearchQuery('');
                          },
                        )
                      : const SizedBox.shrink()),
              ),
              onChanged: (value) {
                controller.updateSearchQuery(value);
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoadingJadwalPilihan.value) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primary));
              }
              if (controller.selectedTahunAjar.value == null || controller.selectedSemester.value == null){
                 return _buildInstructionText("Pilih Tahun Ajar dan Semester untuk melihat jadwal.");
              }
              // KONDISI DIPERBAIKI: Gunakan filteredJadwalPilihanList.isEmpty
              if (controller.filteredJadwalPilihanList.isEmpty && controller.searchQuery.value.isNotEmpty) {
                return _buildInstructionText("Tidak ada mata kuliah yang cocok dengan pencarian '${controller.searchQuery.value}'.");
              }
              if (controller.jadwalPilihanList.isEmpty && controller.searchQuery.value.isEmpty) {
                 // Jika jadwalPilihanList (data asli dari API) kosong
                 return _buildInstructionText("Tidak ada jadwal mata kuliah tersedia untuk periode ini.");
              }
              if (controller.filteredJadwalPilihanList.isEmpty && controller.searchQuery.value.isEmpty && controller.jadwalPilihanList.isNotEmpty){
                // Ini seharusnya tidak terjadi jika logika filter benar, tapi sebagai fallback
                return _buildInstructionText("Tidak ada jadwal yang ditampilkan. Coba filter lain.");
              }


              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                // ITEM COUNT DIPERBAIKI
                itemCount: controller.filteredJadwalPilihanList.length,
                itemBuilder: (context, index) {
                  final jadwalItem = controller.filteredJadwalPilihanList[index];
                  return _buildJadwalCard(context, jadwalItem);
                },
              );
            }),
          ),
          _buildBottomSummaryAndActionButton(),
        ],
      ),
    );
  }


  Widget _buildInstructionText(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(PhosphorIcons.info(PhosphorIconsStyle.duotone), size: 48, color: AppColors.primary.withOpacity(0.7)),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.textBodySecondary, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildDropdownField(
            label: 'Tahun Ajar',
            value: controller.selectedTahunAjar,
            items: controller.tahunAjarItems,
            onChanged: controller.onTahunAjarChanged,
            icon: PhosphorIcons.calendarBlank(PhosphorIconsStyle.duotone),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildDropdownField(
            label: 'Semester',
            value: controller.selectedSemester,
            items: controller.semesterItems,
            onChanged: controller.onSemesterChanged,
            icon: PhosphorIcons.stack(PhosphorIconsStyle.duotone),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required Rxn<String> value,
    required RxList<String> items,
    required Function(String?) onChanged,
    IconData? icon,
  }) {
     return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textBodySecondary)),
        const SizedBox(height: 6),
        Obx(
          () => Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.divider, width: 1.2),
                borderRadius: BorderRadius.circular(10),
                color: AppColors.cardBackground,
                 boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  )
                ]
                ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                icon: Icon( PhosphorIcons.caretDown(PhosphorIconsStyle.bold), size: 20, color: AppColors.iconColor),
                isExpanded: true,
                value: value.value,
                style: TextStyle(fontSize: 14, color: AppColors.textBody, fontWeight: FontWeight.w500),
                items: items.map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item)
                )).toList(),
                onChanged: onChanged,
                hint: Row(
                  children: [
                    if (icon != null) Icon(icon, size: 18, color: AppColors.textBodySecondary.withOpacity(0.7)),
                    if (icon != null) const SizedBox(width: 8),
                    Text("Pilih $label", style: TextStyle(color: AppColors.textBodySecondary.withOpacity(0.8), fontSize: 14)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJadwalCard(BuildContext context, JadwalMatakuliahModel jadwalItem) {
    return Obx(() {
      final bool isSelected = controller.isJadwalSelected(jadwalItem);
      return Card(
        elevation: isSelected ? 1.5 : 2.5,
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: isSelected ? 1.5 : 0,
          ),
        ),
        color: isSelected ? AppColors.cardSelectedBackground : AppColors.cardBackground,
        shadowColor: Colors.grey.withOpacity(0.1),
        child: InkWell(
          onTap: () => controller.toggleJadwalSelection(jadwalItem),
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        jadwalItem.namaMatakuliah,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? AppColors.primary : AppColors.textTitle,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isSelected)
                      Icon(PhosphorIcons.checkCircle(PhosphorIconsStyle.fill), color: AppColors.primary, size: 22),
                  ],
                ),
                const SizedBox(height: 8),
                _buildCardInfoRow(PhosphorIcons.userList(PhosphorIconsStyle.duotone), jadwalItem.namaDosen, isSelected: isSelected),
                const SizedBox(height: 6),
                _buildCardInfoRow(PhosphorIcons.clock(PhosphorIconsStyle.duotone), "${jadwalItem.hari}, ${jadwalItem.jamMulai.substring(0,5)} - ${jadwalItem.jamSelesai.substring(0,5)}", isSelected: isSelected),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(child: _buildCardInfoRow(PhosphorIcons.identificationBadge(PhosphorIconsStyle.duotone), "Kelas ${jadwalItem.kelas}", isSelected: isSelected)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildCardInfoRow(PhosphorIcons.mapPin(PhosphorIconsStyle.duotone), jadwalItem.ruangan, isSelected: isSelected)),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

   Widget _buildCardInfoRow(IconData icon, String text, {bool isSelected = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: isSelected ? AppColors.primary.withOpacity(0.8) : AppColors.iconColor.withOpacity(0.9)),
        const SizedBox(width: 8),
        Expanded(
            child: Text(text,
                style: TextStyle(
                    fontSize: 13,
                    color: isSelected ? AppColors.textBody.withOpacity(0.9) : AppColors.textBodySecondary,
                    fontWeight: FontWeight.w400
                    ))),
      ],
    );
  }

  Widget _buildBottomSummaryAndActionButton() {
    return Obx(() {
      final int jumlahMatkulTerpilih = controller.selectedJadwalUntukPengajuan.length;
      final bool canSubmit = jumlahMatkulTerpilih > 0;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.background,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, -3),
            ),
          ],
          border: Border(top: BorderSide(color: AppColors.divider, width: 0.8))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Total Dipilih:",
                  style: TextStyle(fontSize: 13, color: AppColors.textBodySecondary, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 2),
                Text(
                  "$jumlahMatkulTerpilih Mata Kuliah",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              icon: controller.isStoringFrs.value
                  ? Container(width: 18, height: 18, margin: const EdgeInsets.only(right: 8), child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Icon(PhosphorIcons.paperPlaneTilt(PhosphorIconsStyle.fill), size: 18, color: Colors.white),
              label: Text(controller.isStoringFrs.value ? "Memproses..." : "Ambil FRS", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white)),
              onPressed: canSubmit && !controller.isStoringFrs.value ? () => controller.storeSelectedFrs() : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.buttonDisabled,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 2,
              ),
            ),
          ],
        ),
      );
    });
  }
}
