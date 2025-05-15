import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class FrsScreen extends StatefulWidget {
  const FrsScreen({super.key});

  @override
  State<FrsScreen> createState() => _FrsScreenState();
}

class _FrsScreenState extends State<FrsScreen> {
  final tahunAjarItems = ['2023/2024', '2022/2023', '2021/2022'];
  final semesterItems = ['Ganjil', 'Genap', 'Pendek'];
  String? tahunAjarValue;
  String? semesterValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Persetujuan FRS',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu, color: Colors.black),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Upper part - Selections and Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dropdowns
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tahun Ajar Dropdown
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tahun Ajar',
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black12,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  isExpanded: true,
                                  hint: const Text(""),
                                  value: tahunAjarValue,
                                  items:
                                      tahunAjarItems
                                          .map(buildMenuItem)
                                          .toList(),
                                  onChanged:
                                      (value) => setState(
                                        () => tahunAjarValue = value,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Semester Dropdown
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Semester',
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black12,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  isExpanded: true,
                                  hint: const Text(""),
                                  value: semesterValue,
                                  items:
                                      semesterItems.map(buildMenuItem).toList(),
                                  onChanged:
                                      (value) =>
                                          setState(() => semesterValue = value),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Info Fields
                  const SizedBox(height: 16),
                  _buildInfoRow('Dosen Wali', 'S.kom Jakobowo'),
                  const SizedBox(height: 8),
                  _buildKreditRow('Batas / Sisa', '24', '20', 'SKS'),
                  const SizedBox(height: 8),
                  _buildInfoRow('Pengisian', '07-08-2023'),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Course List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildCourseCard(
                    title: 'MW-Bahasa Inggris (SKS 2)',
                    status: 'Ditolak',
                    isApproved: false,
                    lecturer: 'Adolf Ismaran S.kom',
                    time: '08:00 sd 11:00 WIB',
                    classroom: 'Kelas B',
                  ),
                  const SizedBox(height: 16),
                  _buildCourseCard(
                    title: 'MW-Workshop Pemograman Perangkat Bergerak(SKS 2)',
                    status: 'Disetujui',
                    isApproved: true,
                    lecturer: 'Adolf Ismaran S.kom',
                    time: '12:00 sd 14:30 WIB',
                    classroom: 'Kelas B',
                  ),
                  const SizedBox(height: 16),
                  _buildCourseCard(
                    title: 'MW-Workshop Administrasi Jarinaan (SKS 2)',
                    status: '',
                    isApproved: null,
                    lecturer: '',
                    time: '',
                    classroom: '',
                    showDetails: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book, color: Colors.blue),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text('$label :', style: const TextStyle(fontSize: 14)),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildKreditRow(
    String label,
    String value1,
    String value2,
    String unit,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text('$label :', style: const TextStyle(fontSize: 14)),
        ),
        const SizedBox(width: 8),
        Text(
          value1,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const Text(' / '),
        Text(
          value2,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 4),
        Text(
          unit,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildCourseCard({
    required String title,
    required String status,
    required bool? isApproved,
    required String lecturer,
    required String time,
    required String classroom,
    bool showDetails = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isApproved != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isApproved ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            if (showDetails) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(lecturer, style: const TextStyle(fontSize: 14)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(time, style: const TextStyle(fontSize: 14)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.class_, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(classroom, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) =>
      DropdownMenuItem(value: item, child: Text(item));
}
