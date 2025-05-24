import 'dart:convert';

class UserModel {
  final String id;
  final String nama; 
  final String email;
  final String? nrp;
  final String? role;
  final String? prodiId;
  final String? kelasId;
  final String? jenisKelamin;
  final String? telepon;
  final String? agama;
  final String? semester;
  final DateTime? tanggalLahir;
  final DateTime? tanggalMasuk;
  final String? status;
  final String? alamatJalan;

  UserModel({
    required this.id,
    required this.nama,
    required this.email,
    this.nrp,
    this.role,
    this.prodiId,
    this.kelasId,
    this.jenisKelamin,
    this.telepon,
    this.agama,
    this.semester,
    this.tanggalLahir,
    this.tanggalMasuk,
    this.status,
    this.alamatJalan,
    // Tambahkan di constructor jika ada properti baru
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      nama: json['nama']?.toString() ?? '', // Pastikan ini 'nama'
      email: json['email']?.toString() ?? '',
      nrp: json['nrp']?.toString(),
      role: json['role']?.toString(),
      prodiId: json['prodi_id']?.toString(),
      kelasId: json['kelas_id']?.toString(),
      jenisKelamin: json['jenis_kelamin']?.toString(),
      telepon: json['telepon']?.toString(),
      agama: json['agama']?.toString(),
      semester: json['semester']?.toString(),
      tanggalLahir: json['tanggal_lahir'] != null
          ? DateTime.tryParse(json['tanggal_lahir'].toString()) // Ensure string before parse
          : null,
      tanggalMasuk: json['tanggal_masuk'] != null
          ? DateTime.tryParse(json['tanggal_masuk'].toString()) // Ensure string before parse
          : null,
      status: json['status']?.toString(),
      alamatJalan: json['alamat_jalan']?.toString(),
      // Parsing properti lain
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'nrp': nrp,
      'role': role,
      'prodi_id': prodiId,
      'kelas_id': kelasId,
      'jenis_kelamin': jenisKelamin,
      'telepon': telepon,
      'agama': agama,
      'semester': semester,
      'tanggal_lahir': tanggalLahir?.toIso8601String(),
      'tanggal_masuk': tanggalMasuk?.toIso8601String(),
      'status': status,
      'alamat_jalan': alamatJalan,
      // Tambahkan properti lain
    };
  }
}