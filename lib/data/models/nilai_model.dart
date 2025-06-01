class NilaiModel {
  final String id;
  final String matakuliah;
  final String kodemk;
  final int nilaiAngka;
  final String status;
  final String nilaiHuruf;
  final String semester;
  final int tahunMulai;
  final int tahunAkhir;


  NilaiModel({
    required this.id,
    required this.matakuliah,
    required this.kodemk,
    required this.nilaiAngka,
    required this.status,
    required this.nilaiHuruf,
    required this.semester,
    required this.tahunMulai,
    required this.tahunAkhir,
  });

  factory NilaiModel.fromJson(Map<String, dynamic> json) {
    return NilaiModel(
      id: json['id'] as String,
      matakuliah: json['nama_matakuliah'] as String,
      kodemk: json['kode_matakuliah'] as String,
      nilaiAngka: json['nilai_angka'] as int,
      status: json['status'] as String,
      nilaiHuruf: json['nilai_huruf'] as String,
      semester: json['semester'] as String,
      tahunMulai: json['tahun_mulai'] as int,
      tahunAkhir: json['tahun_akhir'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matakuliah': matakuliah,
      'kodemk': kodemk,
      'nilai_angka': nilaiAngka,
      'status': status,
      'nilai_huruf': nilaiHuruf,
      'semester': semester,
      'tahun_mulai': tahunMulai,
      'tahun_akhir': tahunAkhir,
    };
  }
}