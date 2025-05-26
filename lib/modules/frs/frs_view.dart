import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:timelyu/modules/frs/frs_controller.dart'; 
import 'package:timelyu/data/models/frs_model.dart';
import 'package:timelyu/modules/frs/frs_memilih_view.dart';
import 'package:timelyu/shared/widgets/bottomNavigasi.dart';

// --- AppColors (jika belum ada di file terpisah) ---
class AppColors {
  static const Color primary = Color(0xFF007AFF);
  static const Color primaryLight = Color(0xFFE6F2FF);
  static const Color accent = Color(0xFFFF9500);
  static const Color textTitle = Color(0xFF1D1D1F);
  static const Color textBody = Color(0xFF3C3C43);
  static const Color textBodySecondary = Color(0xFF6E6E73);
  static const Color background = Colors.white;
  static const Color cardBackground = Colors.white;
  static const Color divider = Color(0xFFE0E0E0);
  static const Color iconColor = Color(0xFF6E6E73);
  static const Color fabColor = Color(0xFF007AFF);

  // Warna untuk status
  static const Color statusApproved = Color(0xFF34C759);
  static const Color statusPending = Color(0xFFFF9500);
  static const Color statusRejected = Color(0xFFFF3B30);
  static const Color statusDefault = Color(0xFF8E8E93);
}

class FrsView extends GetView<FrsController> {
  const FrsView({super.key});

  // Helper untuk mendapatkan ukuran layar
  bool get isTablet => Get.width >= 768;
  bool get isDesktop => Get.width >= 1024;
  bool get isMobile => Get.width < 768;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildResponsiveAppBar(),
      body: SafeArea(
        child: _buildResponsiveBody(context),
      ),
      floatingActionButton: _buildResponsiveFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: isMobile ? const TaskBottomNavigationBar() : null,
    );
  }

  PreferredSizeWidget _buildResponsiveAppBar() {
    return AppBar(
      title: Text(
        'Persetujuan FRS',
        style: TextStyle(
          color: AppColors.textTitle,
          fontWeight: FontWeight.w600,
          fontSize: isDesktop ? 20 : isTablet ? 19 : 18,
        ),
      ),
      centerTitle: true,
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textTitle,
      elevation: 0.8,
      shadowColor: Colors.grey.withOpacity(0.2),
      toolbarHeight: isDesktop ? 64 : isTablet ? 60 : kToolbarHeight,
    );
  }

  Widget _buildResponsiveBody(BuildContext context) {
    final horizontalPadding = _getHorizontalPadding();
    final verticalPadding = _getVerticalPadding();

    if (isDesktop) {
      // Desktop layout dengan max width dan center alignment
      return Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: _buildFrsListSection(context),
        ),
      );
    } else {
      // Mobile dan tablet layout
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: _buildFrsListSection(context),
      );
    }
  }

  Widget _buildResponsiveFAB() {
    if (isDesktop) {
      return FloatingActionButton.extended(
        onPressed: () => Get.to(() => const FrsInputView()),
        backgroundColor: AppColors.fabColor,
        icon: Icon(PhosphorIcons.plusCircle(), color: Colors.white, size: 22),
        label: const Text(
          "Ambil FRS",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      );
    } else if (isTablet) {
      return FloatingActionButton.extended(
        onPressed: () => Get.to(() => const FrsInputView()),
        backgroundColor: AppColors.fabColor,
        icon: Icon(PhosphorIcons.plusCircle(), color: Colors.white, size: 20),
        label: const Text(
          "Ambil FRS",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      );
    } else {
      return FloatingActionButton(
        onPressed: () => Get.to(() => const FrsInputView()),
        backgroundColor: AppColors.fabColor,
        child: Icon(PhosphorIcons.plusCircle(), color: Colors.white, size: 24),
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      );
    }
  }

  double _getHorizontalPadding() {
    if (isDesktop) return 24.0;
    if (isTablet) return Get.width * 0.04;
    return Get.width * 0.05;
  }

  double _getVerticalPadding() {
    if (isDesktop) return 24.0;
    if (isTablet) return Get.height * 0.025;
    return Get.height * 0.02;
  }

  Widget _buildFrsListSection(BuildContext context) {
    return GetX(
      init: controller,
      initState: (state) => controller.fetchFrsData(),
      builder: (controller) {
        if (controller.isLoadingFrs.value) {
          return _buildLoadingState();
        }

        if (controller.selectedTahunAjar.value == null ||
            controller.selectedSemester.value == null) {
          return _buildNoPeriodState();
        }

        if (controller.frsList.isEmpty) {
          return _buildEmptyState(context);
        }

        return _buildResponsiveFrsList();
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: isDesktop ? 80 : 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: isDesktop ? 60 : isTablet ? 50 : 40,
              height: isDesktop ? 60 : isTablet ? 50 : 40,
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: isDesktop ? 4 : 3,
              ),
            ),
            SizedBox(height: isDesktop ? 24 : 16),
            Text(
              "Memuat data FRS...",
              style: TextStyle(
                fontSize: isDesktop ? 18 : isTablet ? 16 : 15,
                color: AppColors.textBodySecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoPeriodState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 48 : isTablet ? 40 : 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIcons.info(PhosphorIconsStyle.duotone),
              size: isDesktop ? 80 : isTablet ? 70 : 50,
              color: AppColors.primary.withOpacity(0.7),
            ),
            SizedBox(height: isDesktop ? 24 : 16),
            Text(
              "Periode FRS belum ditentukan untuk ditampilkan.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isDesktop ? 18 : isTablet ? 17 : 16,
                color: AppColors.textBodySecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveFrsList() {
    if (isDesktop) {
      // Desktop: Grid layout untuk menampilkan lebih banyak cards
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 2.2,
        ),
        itemCount: controller.frsList.length,
        itemBuilder: (context, index) {
          return _buildFrsCard(
            context: context,
            frsItem: controller.frsList[index],
          );
        },
      );
    } else if (isTablet) {
      // Tablet: Bisa single column atau grid tergantung orientasi
      return LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape = constraints.maxWidth > constraints.maxHeight;
          
          if (isLandscape) {
            // Landscape tablet: 2 columns
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.0,
              ),
              itemCount: controller.frsList.length,
              itemBuilder: (context, index) {
                return _buildFrsCard(
                  context: context,
                  frsItem: controller.frsList[index],
                );
              },
            );
          } else {
            // Portrait tablet: Single column
            return ListView.builder(
              itemCount: controller.frsList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: Get.height * 0.02),
                  child: _buildFrsCard(
                    context: context,
                    frsItem: controller.frsList[index],
                  ),
                );
              },
            );
          }
        },
      );
    } else {
      // Mobile: Single column list
      return ListView.builder(
        itemCount: controller.frsList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: Get.height * 0.018),
            child: _buildFrsCard(
              context: context,
              frsItem: controller.frsList[index],
            ),
          );
        },
      );
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isDesktop ? 80 : isTablet ? 70 : 60,
        horizontal: isDesktop ? 32 : isTablet ? 28 : 24,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            PhosphorIcons.folderOpen(PhosphorIconsStyle.duotone),
            size: isDesktop ? 100 : isTablet ? 90 : 80,
            color: AppColors.primary.withOpacity(0.5),
          ),
          SizedBox(height: isDesktop ? 32 : isTablet ? 28 : 24),
          Text(
            'Oops, Data FRS Kosong',
            style: TextStyle(
              fontSize: isDesktop ? 24 : isTablet ? 22 : 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textTitle,
            ),
          ),
          SizedBox(height: isDesktop ? 16 : 12),
          Obx(() => Text(
                'Sepertinya Anda belum mengambil mata kuliah untuk periode ${controller.selectedSemester.value?.toLowerCase() ?? "yang dipilih"} ${controller.selectedTahunAjar.value ?? ""}, atau data tidak dapat ditemukan saat ini.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isDesktop ? 17 : isTablet ? 16 : 15,
                  color: AppColors.textBodySecondary,
                  height: 1.6,
                ),
              )),
          SizedBox(height: isDesktop ? 40 : isTablet ? 35 : 30),
          ElevatedButton.icon(
            icon: Icon(
              PhosphorIcons.arrowsClockwise(PhosphorIconsStyle.bold),
              color: Colors.white,
              size: isDesktop ? 22 : isTablet ? 21 : 20,
            ),
            label: Text(
              'Muat Ulang Data',
              style: TextStyle(
                color: Colors.white,
                fontSize: isDesktop ? 17 : isTablet ? 16 : 15.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: () => controller.fetchFrsData(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 40 : isTablet ? 35 : 30,
                vertical: isDesktop ? 18 : isTablet ? 16 : 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              shadowColor: AppColors.primary.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrsCard({required BuildContext context, required FrsModel frsItem}) {
    String jamMulaiFormatted = frsItem.jamMulai.length >= 5
        ? frsItem.jamMulai.substring(0, 5)
        : frsItem.jamMulai;
    String jamSelesaiFormatted = frsItem.jamSelesai.length >= 5
        ? frsItem.jamSelesai.substring(0, 5)
        : frsItem.jamSelesai;
    String jadwalLengkap =
        "${frsItem.hari.isNotEmpty ? frsItem.hari : 'N/A'}, $jamMulaiFormatted - $jamSelesaiFormatted";

    return Card(
      elevation: isDesktop ? 4 : isTablet ? 3.5 : 3,
      margin: EdgeInsets.symmetric(
        vertical: isDesktop ? 8 : isTablet ? 7 : 6,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isDesktop ? 16 : isTablet ? 14 : 12),
      ),
      color: AppColors.cardBackground,
      shadowColor: Colors.grey.withOpacity(0.15),
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 20 : isTablet ? 18 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    frsItem.namaMatakuliah.isNotEmpty 
                        ? frsItem.namaMatakuliah 
                        : "Nama Mata Kuliah Tidak Tersedia",
                    style: TextStyle(
                      fontSize: isDesktop ? 19 : isTablet ? 18 : 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textTitle,
                    ),
                  ),
                ),
                SizedBox(width: isDesktop ? 16 : isTablet ? 12 : 8),
                _buildStatusChip(frsItem.status),
              ],
            ),
            if (frsItem.tipeMatakuliah.isNotEmpty || frsItem.sks > 0) ...[
              SizedBox(height: isDesktop ? 12 : isTablet ? 10 : 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (frsItem.tipeMatakuliah.isNotEmpty)
                    _buildInfoChip(
                      frsItem.tipeMatakuliah,
                      AppColors.primary.withOpacity(0.1),
                      AppColors.primary,
                    ),
                  if (frsItem.sks > 0)
                    _buildInfoChip(
                      '${frsItem.sks} SKS',
                      AppColors.accent.withOpacity(0.15),
                      Colors.amberAccent,
                    ),
                ],
              ),
            ],
            SizedBox(height: isDesktop ? 20 : isTablet ? 16 : 12),
            _buildCardInfoRow(
              PhosphorIcons.chalkboardTeacher(PhosphorIconsStyle.duotone),
              frsItem.namaDosen.isNotEmpty 
                  ? frsItem.namaDosen 
                  : "Belum ada dosen pengampu",
              color: AppColors.primary,
            ),
            SizedBox(height: isDesktop ? 14 : isTablet ? 12 : 10),
            _buildCardInfoRow(
              PhosphorIcons.clock(PhosphorIconsStyle.duotone),
              jadwalLengkap,
              color: AppColors.accent,
            ),
            SizedBox(height: isDesktop ? 14 : isTablet ? 12 : 10),
            if (isDesktop || isTablet) ...[
              // Desktop/Tablet: Single row untuk kelas dan ruangan
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildCardInfoRow(
                      PhosphorIcons.identificationBadge(PhosphorIconsStyle.duotone),
                      'Kelas ${frsItem.kelas.isNotEmpty ? frsItem.kelas : "-"}',
                    ),
                  ),
                  SizedBox(width: isDesktop ? 20 : 16),
                  Expanded(
                    flex: 3,
                    child: _buildCardInfoRow(
                      PhosphorIcons.mapPinLine(PhosphorIconsStyle.duotone),
                      frsItem.ruangan.isNotEmpty 
                          ? frsItem.ruangan 
                          : "Ruangan belum ditentukan",
                    ),
                  ),
                ],
              ),
            ] else ...[
              // Mobile: Separate rows untuk better readability
              _buildCardInfoRow(
                PhosphorIcons.identificationBadge(PhosphorIconsStyle.duotone),
                'Kelas ${frsItem.kelas.isNotEmpty ? frsItem.kelas : "-"}',
              ),
              const SizedBox(height: 10),
              _buildCardInfoRow(
                PhosphorIcons.mapPinLine(PhosphorIconsStyle.duotone),
                frsItem.ruangan.isNotEmpty 
                    ? frsItem.ruangan 
                    : "Ruangan belum ditentukan",
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, Color backgroundColor, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 8 : isTablet ? 7 : 6,
        vertical: isDesktop ? 4 : isTablet ? 3 : 2,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isDesktop ? 12 : isTablet ? 11.5 : 11,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    String displayText;
    IconData statusIcon;
    Color chipColor;
    Color textColor = Colors.white;

    switch (status.toLowerCase()) {
      case 'approved':
      case 'disetujui':
        displayText = 'Disetujui';
        statusIcon = PhosphorIcons.checkCircle(PhosphorIconsStyle.fill);
        chipColor = AppColors.statusApproved;
        break;
      case 'pending':
        displayText = 'Pending';
        statusIcon = PhosphorIcons.hourglassSimple(PhosphorIconsStyle.fill);
        chipColor = AppColors.statusPending;
        break;
      case 'rejected':
      case 'ditolak':
        displayText = 'Ditolak';
        statusIcon = PhosphorIcons.xCircle(PhosphorIconsStyle.fill);
        chipColor = AppColors.statusRejected;
        break;
      default:
        displayText = status.isNotEmpty ? (status.capitalizeFirst ?? status) : "N/A";
        statusIcon = PhosphorIcons.question(PhosphorIconsStyle.fill);
        chipColor = AppColors.statusDefault;
    }

    return Chip(
      avatar: Icon(
        statusIcon,
        color: textColor,
        size: isDesktop ? 16 : isTablet ? 15.5 : 15,
      ),
      label: Text(
        displayText,
        style: TextStyle(
          fontSize: isDesktop ? 13 : isTablet ? 12.5 : 11.5,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      backgroundColor: chipColor,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 10 : isTablet ? 9 : 8,
        vertical: isDesktop ? 4 : 3,
      ),
      labelPadding: EdgeInsets.only(
        left: isDesktop ? 4 : 3,
        right: isDesktop ? 8 : isTablet ? 7 : 6,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildCardInfoRow(IconData icon, String text, {Color? color, FontWeight? fontWeight}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: isDesktop ? 22 : isTablet ? 21 : 20,
          color: color ?? AppColors.iconColor,
        ),
        SizedBox(width: isDesktop ? 12 : isTablet ? 11 : 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isDesktop ? 16 : isTablet ? 15 : 14,
              color: AppColors.textBody,
              fontWeight: fontWeight ?? FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}