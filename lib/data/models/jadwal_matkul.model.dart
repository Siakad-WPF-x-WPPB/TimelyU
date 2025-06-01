// data/models/jadwal_matkul_model.dart

class JadwalMatakuliahModel {
  final String idJadwal; // KUNCI: Harus cocok dengan FrsModel.idJadwalAsal
  final String namaMatakuliah;
  final String hari;
  final String jamMulai;
  final String jamSelesai;
  final String ruangan;
  final String namaDosen;
  final String kelas;

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
      idJadwal: json['id'] as String? ?? '', 
      namaMatakuliah: json['matakuliah'] as String? ?? '', 
      hari: json['hari'] as String? ?? '',
      jamMulai: json['jam_mulai'] as String? ?? '',
      jamSelesai: json['jam_selesai'] as String? ?? '',
      ruangan: json['ruangan'] as String? ?? '',
      namaDosen: json['dosen'] as String? ?? '', 
      kelas: json['kelas'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': idJadwal, 
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