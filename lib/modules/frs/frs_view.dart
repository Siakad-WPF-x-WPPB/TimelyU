import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class FrsView extends StatefulWidget {
  const FrsView({super.key});

  @override
  State<FrsView> createState() => _FrsViewState();
}

class _FrsViewState extends State<FrsView> {
  final items = ['Item 1', 'Item 2', 'Item 3', 'Item 4'];
  String? value;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Persetubuhan FRS'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
              vertical: height * 0.02,
            ),
            child: Column(
              children: [
                // * Tahun Ajar dan Semester Dropdown --------------------------------
                Row(
                  spacing: 8,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tahun Ajar', style: TextStyle(fontSize: 14)),
                          SizedBox(
                            height: height * 0.04,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black26,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  icon: Icon(
                                    PhosphorIcons.caretDown(
                                      PhosphorIconsStyle.regular,
                                    ),
                                    size: 14,
                                  ),
                                  isExpanded: true,
                                  value: value,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                  items: items.map(buildMenuItem).toList(),
                                  onChanged:
                                      (value) =>
                                          setState(() => this.value = value),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // * Semester ------------------------------------------------
                          Text('Semester', style: TextStyle(fontSize: 16)),
                         SizedBox(
                            height: height * 0.04,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black26,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  icon: Icon(
                                    PhosphorIcons.caretDown(
                                      PhosphorIconsStyle.regular,
                                    ),
                                    size: 14,
                                  ),
                                  isExpanded: true,
                                  value: value,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                  items: items.map(buildMenuItem).toList(),
                                  onChanged:
                                      (value) =>
                                          setState(() => this.value = value),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // * Info Fields ----------------------------------------------------------
                const SizedBox(height: 16),
                _buildInfoRow('Dosen Wali', 'S.kom Jakobowo'),
                const SizedBox(height: 8),
                _buildKreditRow('Batas / Sisa', '24', '20'),
                const SizedBox(height: 8),
                _buildInfoRow('Pengisian', '07-08-2023'),
                const SizedBox(height: 16),

                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: height * 0.02),
                      child: buildFrsCard(
                        namaMatakuliah: "Adolf Ismaran S.kom",
                        status: "Ditolak",
                        pengajar: "Adolf Ismaran S.kom",
                        waktu: "08:00 sd 11:00 WIB",
                        kelas: "Kelas B",
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        // * Label --------------------------------------------------------------------------
        SizedBox(
          width: width * 0.25,
          child: Text(label, style: const TextStyle(fontSize: 14)),
        ),
        Text(':', style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 8),
        // * Value --------------------------------------------------------------------------
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildKreditRow(String label, String batas, String sisa) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        // * Label --------------------------------------------------------------------------
        SizedBox(
          width: width * 0.25,
          child: Text(label, style: const TextStyle(fontSize: 14)),
        ),
        Text(':', style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 8),
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 14, color: Colors.black),
            children: [
              // * Batas --------------------------------------------------------------------------
              // TODO: Ganti Warna Batas dan Sisa Dan font dan poop
              TextSpan(
                text: batas,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
              ),
              const TextSpan(text: ' / '),
              // * Sisa --------------------------------------------------------------------------
              TextSpan(
                text: sisa,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.yellow,
                ),
              ),
              TextSpan(
                text: " SKS",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // * FRS Card --------------------------------------------------------------------------
  // TODO: Ganti warna menggunakan template dan sesuai dengan status, dan ubah font
  Widget buildFrsCard({
    required String namaMatakuliah,
    required String status,
    required String pengajar,
    required String waktu,
    required String kelas,
    Color statusColor = const Color.fromARGB(255, 183, 40, 40),
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
          // * Matakuliah ---------------------------------------------------------------
          Text(
            namaMatakuliah,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          // * Status --------------------------------------------------------------------
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 183, 40, 40),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.02,
              vertical: height * 0.005,
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
                  'Ditolak',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // * Pengajar ---------------------------------------------------------------
          Row(
            children: [
              Icon(
                PhosphorIcons.student(PhosphorIconsStyle.regular),
                size: 18,
                color: Colors.black,
              ),
              const SizedBox(width: 8),
              Text(pengajar, style: const TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 4),
          // * Waktu --------------------------------------------------------------------
          Row(
            children: [
              Icon(
                PhosphorIcons.clock(PhosphorIconsStyle.regular),
                size: 18,
                color: Colors.black,
              ),
              const SizedBox(width: 8),
              Text(waktu, style: const TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 4),
          // * Kelas --------------------------------------------------------------------
          Row(
            children: [
              Icon(
                PhosphorIcons.chalkboardSimple(PhosphorIconsStyle.regular),
                size: 18,
                color: Colors.black,
              ),
              const SizedBox(width: 8),
              Text(kelas, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) =>
      DropdownMenuItem(value: item, child: Text(item));
}
