// data/models/jadwal_matakuliah_model.dart

class JadwalMatakuliahModel {
  final String idJadwal;
  final String namaMatakuliah;
  final String hari;
  final String jamMulai;
  final String jamSelesai;
  final String ruangan;
  final String namaDosen;
  final String kelas;
  // Anda bisa menambahkan field lain seperti 'sks', 'kode_matakuliah' jika API menyediakannya
  // dan Anda membutuhkannya di UI. Berdasarkan JSON yang diberikan, field-field ini tidak ada.

  JadwalMatakuliahModel({
    required this.idJadwal,
    required this.namaMatakuliah,
    required this.hari,
    required this.jamMulai,
    required this.jamSelesai,
    required this.ruangan,
    required this.namaDosen,
    required this.kelas,
  });

  factory JadwalMatakuliahModel.fromJson(Map<String, dynamic> json) {
    return JadwalMatakuliahModel(
      idJadwal: json['id'] as String? ?? '', // Dari JSON: "id"
      namaMatakuliah: json['matakuliah'] as String? ?? '', // Dari JSON: "matakuliah"
      hari: json['hari'] as String? ?? '',
      jamMulai: json['jam_mulai'] as String? ?? '',
      jamSelesai: json['jam_selesai'] as String? ?? '',
      ruangan: json['ruangan'] as String? ?? '',
      namaDosen: json['dosen'] as String? ?? '', // Dari JSON: "dosen"
      kelas: json['kelas'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': idJadwal, // Konsisten dengan pembacaan dari 'id'
      'matakuliah': namaMatakuliah,
      'hari': hari,
      'jam_mulai': jamMulai,
      'jam_selesai': jamSelesai,
      'ruangan': ruangan,
      'dosen': namaDosen,
      'kelas': kelas,
    };
  }
}