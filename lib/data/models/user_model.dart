import 'dart:convert'; // Tidak perlu jika toJson tidak digunakan untuk stringify langsung

class UserModel {
  final String id;
  final String nama;
  final String email;
  final String? nrp;
  final String? namaKelas;
  final String? namaProdi;
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
    this.namaKelas,
    this.namaProdi,
    this.jenisKelamin,
    this.telepon,
    this.agama,
    this.semester,
    this.tanggalLahir,
    this.tanggalMasuk,
    this.status,
    this.alamatJalan,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      nama: json['nama']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      nrp: json['nrp']?.toString(),

      namaKelas: json['nama_kelas']?.toString(), // Pastikan key 'nama_kelas' ada di JSON dari /profile
      namaProdi: json['nama_prodi']?.toString(), // Pastikan key 'nama_prodi' ada di JSON dari /profile
      jenisKelamin: json['jenis_kelamin']?.toString(),
      telepon: json['telepon']?.toString(),
      agama: json['agama']?.toString(),
      semester: json['semester']?.toString(),
      tanggalLahir: json['tanggal_lahir'] != null && json['tanggal_lahir'].toString().isNotEmpty
          ? DateTime.tryParse(json['tanggal_lahir'].toString())
          : null,
      tanggalMasuk: json['tanggal_masuk'] != null && json['tanggal_masuk'].toString().isNotEmpty
          ? DateTime.tryParse(json['tanggal_masuk'].toString())
          : null,
      status: json['status']?.toString(),
      alamatJalan: json['alamat_jalan']?.toString(),
      // provinsi: json['provinsi']?.toString(),
      // kodePos: json['kode_pos']?.toString(),
      // negara: json['negara']?.toString(),
      // kelurahan: json['kelurahan']?.toString(),
      // kecamatan: json['kecamatan']?.toString(),
      // kota: json['kota']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'nrp': nrp,
      'nama_kelas': namaKelas,
      'nama_prodi': namaProdi,
      'jenis_kelamin': jenisKelamin,
      'telepon': telepon,
      'agama': agama,
      'semester': semester,
      'tanggal_lahir': tanggalLahir?.toIso8601String(),
      'tanggal_masuk': tanggalMasuk?.toIso8601String(),
      'status': status,
      'alamat_jalan': alamatJalan,
      // 'provinsi': provinsi,
      // 'kode_pos': kodePos,
      // 'negara': negara,
      // 'kelurahan': kelurahan,
      // 'kecamatan': kecamatan,
      // 'kota': kota,
    };
  }
}