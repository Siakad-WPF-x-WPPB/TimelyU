// data/models/frs_model.dart

class FrsModel {
  final String id; // ID unik untuk item FRS ini
  final String? idJadwalAsal; // ID dari JadwalMatakuliahModel asli
  final String status;
  final String hari;
  final String jamMulai;
  final String jamSelesai;
  final String namaMatakuliah;
  final String tipeMatakuliah;
  final int sks;             
  final String namaDosen;
  final String kelas;
  final String ruangan;
  final int tahunAjar; // Tahun akademik FRS ini berlaku (misal 2023 untuk periode 2023/2024)
  final int tahunBerakhir; // Tahun akademik FRS ini berakhir (misal 2024 untuk periode 2023/2024)
  final String semester;

  FrsModel({
    required this.id,
    this.idJadwalAsal, 
    required this.status,
    required this.hari,
    required this.jamMulai,
    required this.jamSelesai,
    required this.namaMatakuliah,
    required this.tipeMatakuliah,
    required this.sks,
    required this.namaDosen,
    required this.kelas,
    required this.ruangan,
    required this.tahunAjar, 
    required this.tahunBerakhir,
    required this.semester,
  });

  factory FrsModel.fromJson(Map<String, dynamic> json) {
    return FrsModel(
      id: json['id'] as String? ?? '',
      // Sesuaikan 'id_jadwal_asal' dengan nama field aktual dari API FRS Anda
      idJadwalAsal: json['id_jadwal_asal'] as String? ?? json['jadwal_id'] as String?, 
      status: json['status'] as String? ?? 'pending',
      hari: json['hari'] as String? ?? '',
      jamMulai: json['jam_mulai'] as String? ?? '',
      jamSelesai: json['jam_selesai'] as String? ?? '',
      namaMatakuliah: json['nama_matakuliah'] as String? ?? json['matakuliah'] as String? ?? '',
      tipeMatakuliah: json['tipe_matakuliah'] as String? ?? '', 
      sks: json['sks'] as int? ?? 0, 
      namaDosen: json['nama_dosen'] as String? ?? json['dosen'] as String? ?? '',
      kelas: json['kelas'] as String? ?? '',
      ruangan: json['ruangan'] as String? ?? '',
      tahunAjar: json['tahun_ajar'] as int? ?? DateTime.now().year, 
      tahunBerakhir: json['tahun_berakhir'] as int? ?? (json['tahun_ajar'] as int? ?? DateTime.now().year) + 1,
      semester: json['semester'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'status': status,
      'hari': hari,
      'jam_mulai': jamMulai,
      'jam_selesai': jamSelesai,
      'nama_matakuliah': namaMatakuliah,
      'tipe_matakuliah': tipeMatakuliah,
      'sks': sks,
      'nama_dosen': namaDosen,
      'kelas': kelas,
      'ruangan': ruangan,
      'tahun_ajar': tahunAjar,
      'tahun_berakhir': tahunBerakhir,
      'semester': semester,
    };
    if (idJadwalAsal != null) {
      // Biasanya tidak perlu mengirim balik idJadwalAsal saat update,
      // kecuali API Anda secara spesifik memerlukannya.
      // Untuk pembuatan baru (storeFrs), idJadwalAsal biasanya tidak dikirim dari client
      // karena FRS dibuat berdasarkan pilihan jadwal, bukan dari FRS lain.
      // data['id_jadwal_asal'] = idJadwalAsal; 
    }
    return data;
  }
}
