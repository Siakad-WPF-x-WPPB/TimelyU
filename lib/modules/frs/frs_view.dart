import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:timelyu/modules/frs/frs_controller.dart';
import 'package:timelyu/shared/widgets/bottomNavigasi.dart';

class FrsView extends GetView<FrsController> {
  const FrsView({super.key});

  @override
  Widget build(BuildContext context) {
    final FrsController controller = Get.put(FrsController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Persetujuan FRS'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.05,
              vertical: Get.height * 0.02,
            ),
            child: Column(
              children: [
                _buildDropdownSection(),
                const SizedBox(height: 16),
                _buildInfoSection(),
                const SizedBox(height: 16),
                _buildFrsListSection(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: const TaskBottomNavigationBar(),
    );
  }

  Widget _buildDropdownSection() {
    return Row(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: _buildDropdownField(
            label: 'Tahun Ajar',
            value: controller
            .selectedTahunAjar,
            onChanged: controller.onTahunAjarChanged,
          ),
        ),
        Expanded(
          child: _buildDropdownField(
            label: 'Semester',
            value: controller.selectedSemester,
            onChanged: controller.onSemesterChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required Rxn<String> value,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        SizedBox(
          height: Get.height * 0.04,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26, width: 1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: DropdownButtonHideUnderline(
              child: Obx(() => DropdownButton<String>(
                icon: Icon(
                  PhosphorIcons.caretDown(PhosphorIconsStyle.regular),
                  size: 14,
                ),
                isExpanded: true,
                value: value.value,
                style: const TextStyle(fontSize: 14, color: Colors.black),
                items: controller.items.map(_buildMenuItem).toList(),
                onChanged: onChanged,
              )),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Obx(() => Column(
      children: [
        _buildInfoRow('Dosen Wali', controller.dosenWali.value),
        const SizedBox(height: 8),
        _buildKreditRow(
          'Batas / Sisa',
          controller.batasKredit.value,
          controller.sisaKredit.value,
        ),
        const SizedBox(height: 8),
        _buildInfoRow('Pengisian', controller.tanggalPengisian.value),
      ],
    ));
  }

  Widget _buildFrsListSection() {
    return Obx(() => ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.frsList.length,
      itemBuilder: (context, index) {
        final frsItem = controller.frsList[index];
        return Padding(
          padding: EdgeInsets.only(bottom: Get.height * 0.02),
          child: _buildFrsCard(
            frsItem: frsItem,
            index: index,
          ),
        );
      },
    ));
  }

  Widget _buildFloatingActionButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      child: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/frs-memilih');
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        backgroundColor: const Color(0xFF00509D),
        child: Icon(
          PhosphorIcons.plus(PhosphorIconsStyle.regular),
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: Get.width * 0.25,
          child: Text(label, style: const TextStyle(fontSize: 14)),
        ),
        const Text(':', style: TextStyle(fontSize: 14)),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildKreditRow(String label, String batas, String sisa) {
    return Row(
      children: [
        SizedBox(
          width: Get.width * 0.25,
          child: Text(label, style: const TextStyle(fontSize: 14)),
        ),
        const Text(':', style: TextStyle(fontSize: 14)),
        const SizedBox(width: 8),
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 14, color: Colors.black),
            children: [
              TextSpan(
                text: batas,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
              ),
              const TextSpan(text: ' / '),
              TextSpan(
                text: sisa,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.yellow,
                ),
              ),
              const TextSpan(
                text: " SKS",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFrsCard({
    required frsItem,
    required int index,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  frsItem.namaMatakuliah,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: frsItem.statusColor,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.02,
              vertical: Get.height * 0.005,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  PhosphorIcons.warningCircle(PhosphorIconsStyle.regular),
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 6),
                Text(
                  frsItem.status,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildCardInfoRow(
            PhosphorIcons.student(PhosphorIconsStyle.regular),
            frsItem.pengajar,
          ),
          const SizedBox(height: 4),
          _buildCardInfoRow(
            PhosphorIcons.clock(PhosphorIconsStyle.regular),
            frsItem.waktu,
          ),
          const SizedBox(height: 4),
          _buildCardInfoRow(
            PhosphorIcons.chalkboardSimple(PhosphorIconsStyle.regular),
            frsItem.kelas,
          ),
        ],
      ),
    );
  }

  Widget _buildCardInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  DropdownMenuItem<String> _buildMenuItem(String item) =>
      DropdownMenuItem(value: item, child: Text(item));
}