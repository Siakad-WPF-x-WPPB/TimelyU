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
      namaKelas: json['nama_kelas']?.toString(),
      namaProdi: json['nama_prodi']?.toString(),
      jenisKelamin: json['jenis_kelamin']?.toString(),
      telepon: json['telepon']?.toString(),
      agama: json['agama']?.toString(),
      semester: json['semester']?.toString(),
      tanggalLahir: _parseDateTime(json['tanggal_lahir']),
      tanggalMasuk: _parseDateTime(json['tanggal_masuk']),
      status: json['status']?.toString(),
      alamatJalan: json['alamat_jalan']?.toString(),
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
    };
  }

  static DateTime? _parseDateTime(dynamic dateValue) {
    if (dateValue != null && dateValue.toString().isNotEmpty) {
      return DateTime.tryParse(dateValue.toString());
    }
    return null;
  }
}