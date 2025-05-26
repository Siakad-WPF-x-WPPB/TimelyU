// lib/models/frs_models.dart

// Model untuk Ruangan
class RuanganModel {
  final String id;
  final String kode;
  final String nama;
  final String gedung;
  final DateTime createdAt;
  final DateTime updatedAt;

  RuanganModel({
    required this.id,
    required this.kode,
    required this.nama,
    required this.gedung,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RuanganModel.fromJson(Map<String, dynamic> json) {
    return RuanganModel(
      id: json['id'] as String,
      kode: json['kode'] as String,
      nama: json['nama'] as String,
      gedung: json['gedung'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kode': kode,
      'nama': nama,
      'gedung': gedung,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// Model untuk Kelas
class KelasModel {
  final String id;
  final String prodiId;
  final String dosenId;
  final String pararel;
  final DateTime createdAt;
  final DateTime updatedAt;

  KelasModel({
    required this.id,
    required this.prodiId,
    required this.dosenId,
    required this.pararel,
    required this.createdAt,
    required this.updatedAt,
  });

  factory KelasModel.fromJson(Map<String, dynamic> json) {
    return KelasModel(
      id: json['id'] as String,
      prodiId: json['prodi_id'] as String,
      dosenId: json['dosen_id'] as String,
      pararel: json['pararel'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prodi_id': prodiId,
      'dosen_id': dosenId,
      'pararel': pararel,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// Model untuk Matakuliah
class MatakuliahModel {
  final String id;
  final String prodiId;
  final String kode;
  final String nama;
  final String semester;
  final int sks;
  final String tipe;
  final DateTime createdAt;
  final DateTime updatedAt;

  MatakuliahModel({
    required this.id,
    required this.prodiId,
    required this.kode,
    required this.nama,
    required this.semester,
    required this.sks,
    required this.tipe,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MatakuliahModel.fromJson(Map<String, dynamic> json) {
    return MatakuliahModel(
      id: json['id'] as String,
      prodiId: json['prodi_id'] as String,
      kode: json['kode'] as String,
      nama: json['nama'] as String,
      semester: json['semester'] as String,
      sks: json['sks'] as int,
      tipe: json['tipe'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prodi_id': prodiId,
      'kode': kode,
      'nama': nama,
      'semester': semester,
      'sks': sks,
      'tipe': tipe,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// Model untuk Dosen
class DosenModel {
  final String id;
  final String prodiId;
  final String nip;
  final String nama;
  final String jenisKelamin;
  final String telepon;
  final String email;
  final DateTime tanggalLahir;
  final String jabatan;
  final String golonganAkhir;
  final bool isWali;
  final DateTime createdAt;
  final DateTime updatedAt;

  DosenModel({
    required this.id,
    required this.prodiId,
    required this.nip,
    required this.nama,
    required this.jenisKelamin,
    required this.telepon,
    required this.email,
    required this.tanggalLahir,
    required this.jabatan,
    required this.golonganAkhir,
    required this.isWali,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DosenModel.fromJson(Map<String, dynamic> json) {
    return DosenModel(
      id: json['id'] as String,
      prodiId: json['prodi_id'] as String,
      nip: json['nip'] as String,
      nama: json['nama'] as String,
      jenisKelamin: json['jenis_kelamin'] as String,
      telepon: json['telepon'] as String,
      email: json['email'] as String,
      tanggalLahir: DateTime.parse(json['tanggal_lahir'] as String),
      jabatan: json['jabatan'] as String,
      golonganAkhir: json['golongan_akhir'] as String,
      isWali: json['is_wali'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prodi_id': prodiId,
      'nip': nip,
      'nama': nama,
      'jenis_kelamin': jenisKelamin,
      'telepon': telepon,
      'email': email,
      'tanggal_lahir': tanggalLahir.toIso8601String(),
      'jabatan': jabatan,
      'golongan_akhir': golonganAkhir,
      'is_wali': isWali,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// Model Utama untuk Jadwal
class JadwalModel {
  final String id;
  final String kelasId;
  final String dosenId;
  final String mkId;
  final String ruanganId;
  final String tahunAjarId;
  final String jamMulai; // Tetap String, bisa diolah lebih lanjut jika perlu
  final String jamSelesai; // Tetap String
  final String hari;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DosenModel dosen;
  final MatakuliahModel matakuliah;
  final KelasModel kelas;
  final RuanganModel ruangan;

  JadwalModel({
    required this.id,
    required this.kelasId,
    required this.dosenId,
    required this.mkId,
    required this.ruanganId,
    required this.tahunAjarId,
    required this.jamMulai,
    required this.jamSelesai,
    required this.hari,
    required this.createdAt,
    required this.updatedAt,
    required this.dosen,
    required this.matakuliah,
    required this.kelas,
    required this.ruangan,
  });

  factory JadwalModel.fromJson(Map<String, dynamic> json) {
    return JadwalModel(
      id: json['id'] as String,
      kelasId: json['kelas_id'] as String,
      dosenId: json['dosen_id'] as String,
      mkId: json['mk_id'] as String,
      ruanganId: json['ruangan_id'] as String,
      tahunAjarId: json['tahun_ajar_id'] as String,
      jamMulai: json['jam_mulai'] as String,
      jamSelesai: json['jam_selesai'] as String,
      hari: json['hari'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      dosen: DosenModel.fromJson(json['dosen'] as Map<String, dynamic>),
      matakuliah: MatakuliahModel.fromJson(json['matakuliah'] as Map<String, dynamic>),
      kelas: KelasModel.fromJson(json['kelas'] as Map<String, dynamic>),
      ruangan: RuanganModel.fromJson(json['ruangan'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kelas_id': kelasId,
      'dosen_id': dosenId,
      'mk_id': mkId,
      'ruangan_id': ruanganId,
      'tahun_ajar_id': tahunAjarId,
      'jam_mulai': jamMulai,
      'jam_selesai': jamSelesai,
      'hari': hari,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'dosen': dosen.toJson(),
      'matakuliah': matakuliah.toJson(),
      'kelas': kelas.toJson(),
      'ruangan': ruangan.toJson(),
    };
  }
}

// Model untuk objek "tahun_ajar" yang ada di root level JSON
class TahunAjarDisplayModel {
  final String id;
  final String semester;
  final int tahunMulai;
  final int tahunAkhir;
  final String displayName;
  final String frsStatus;

  TahunAjarDisplayModel({
    required this.id,
    required this.semester,
    required this.tahunMulai,
    required this.tahunAkhir,
    required this.displayName,
    required this.frsStatus,
  });

  factory TahunAjarDisplayModel.fromJson(Map<String, dynamic> json) {
    return TahunAjarDisplayModel(
      id: json['id'] as String,
      semester: json['semester'] as String,
      tahunMulai: json['tahun_mulai'] as int,
      tahunAkhir: json['tahun_akhir'] as int,
      displayName: json['display_name'] as String,
      frsStatus: json['frs_status'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'semester': semester,
    'tahun_mulai': tahunMulai,
    'tahun_akhir': tahunAkhir,
    'display_name': displayName,
    'frs_status': frsStatus,
  };
}

// Model untuk objek "tahun_ajar" yang ada di dalam "data"
class TahunAjarDataModel { // Diganti nama dari TahunAjarModel agar tidak konflik jika berada di file yang sama
  final String id;
  final String semester;
  final int tahunMulai;
  final int tahunAkhir;
  final String status;
  final DateTime mulaiFrs;
  final DateTime selesaiFrs;
  final DateTime mulaiEditFrs;
  final DateTime selesaiEditFrs;
  final DateTime mulaiDropFrs;
  final DateTime selesaiDropFrs;
  final DateTime createdAt;
  final DateTime updatedAt;

  TahunAjarDataModel({
    required this.id,
    required this.semester,
    required this.tahunMulai,
    required this.tahunAkhir,
    required this.status,
    required this.mulaiFrs,
    required this.selesaiFrs,
    required this.mulaiEditFrs,
    required this.selesaiEditFrs,
    required this.mulaiDropFrs,
    required this.selesaiDropFrs,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TahunAjarDataModel.fromJson(Map<String, dynamic> json) {
    return TahunAjarDataModel(
      id: json['id'] as String,
      semester: json['semester'] as String,
      tahunMulai: json['tahun_mulai'] as int,
      tahunAkhir: json['tahun_akhir'] as int,
      status: json['status'] as String,
      mulaiFrs: DateTime.parse(json['mulai_frs'] as String),
      selesaiFrs: DateTime.parse(json['selesai_frs'] as String),
      mulaiEditFrs: DateTime.parse(json['mulai_edit_frs'] as String),
      selesaiEditFrs: DateTime.parse(json['selesai_edit_frs'] as String),
      mulaiDropFrs: DateTime.parse(json['mulai_drop_frs'] as String),
      selesaiDropFrs: DateTime.parse(json['selesai_drop_frs'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'semester': semester,
        'tahun_mulai': tahunMulai,
        'tahun_akhir': tahunAkhir,
        'status': status,
        'mulai_frs': mulaiFrs.toIso8601String(),
        'selesai_frs': selesaiFrs.toIso8601String(),
        'mulai_edit_frs': mulaiEditFrs.toIso8601String(),
        'selesai_edit_frs': selesaiEditFrs.toIso8601String(),
        'mulai_drop_frs': mulaiDropFrs.toIso8601String(),
        'selesai_drop_frs': selesaiDropFrs.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}

// Model untuk setiap item dalam list "details"
class FrsDetailModel {
  final String id;
  final String frsId;
  final String jadwalId;
  final String status;
  final DateTime tanggalPersetujuan;
  final DateTime createdAt;
  final DateTime updatedAt;
  final JadwalModel jadwal;

  FrsDetailModel({
    required this.id,
    required this.frsId,
    required this.jadwalId,
    required this.status,
    required this.tanggalPersetujuan,
    required this.createdAt,
    required this.updatedAt,
    required this.jadwal,
  });

  factory FrsDetailModel.fromJson(Map<String, dynamic> json) {
    return FrsDetailModel(
      id: json['id'] as String,
      frsId: json['frs_id'] as String,
      jadwalId: json['jadwal_id'] as String,
      status: json['status'] as String,
      tanggalPersetujuan: DateTime.parse(json['tanggal_persetujuan'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      jadwal: JadwalModel.fromJson(json['jadwal'] as Map<String, dynamic>),
    );
  }

   Map<String, dynamic> toJson() => {
    'id': id,
    'frs_id': frsId,
    'jadwal_id': jadwalId,
    'status': status,
    'tanggal_persetujuan': tanggalPersetujuan.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'jadwal': jadwal.toJson(),
  };
}

// Model untuk objek "data" utama
class FrsDataPayloadModel { // Diganti nama dari FrsDataModel agar tidak konflik
  final String id;
  final String mahasiswaId;
  final String tahunAjarId;
  final DateTime tanggalPengisian; // 'YYYY-MM-DD'
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<FrsDetailModel> details;
  final TahunAjarDataModel tahunAjar;

  FrsDataPayloadModel({
    required this.id,
    required this.mahasiswaId,
    required this.tahunAjarId,
    required this.tanggalPengisian,
    required this.createdAt,
    required this.updatedAt,
    required this.details,
    required this.tahunAjar,
  });

  factory FrsDataPayloadModel.fromJson(Map<String, dynamic> json) {
    var detailsList = json['details'] as List;
    List<FrsDetailModel> frsDetails = detailsList.map((i) => FrsDetailModel.fromJson(i as Map<String, dynamic>)).toList();
    return FrsDataPayloadModel(
      id: json['id'] as String,
      mahasiswaId: json['mahasiswa_id'] as String,
      tahunAjarId: json['tahun_ajar_id'] as String,
      tanggalPengisian: DateTime.parse(json['tanggal_pengisian'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      details: frsDetails,
      tahunAjar: TahunAjarDataModel.fromJson(json['tahun_ajar'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'mahasiswa_id': mahasiswaId,
    'tahun_ajar_id': tahunAjarId,
    'tanggal_pengisian': "${tanggalPengisian.year.toString().padLeft(4, '0')}-${tanggalPengisian.month.toString().padLeft(2, '0')}-${tanggalPengisian.day.toString().padLeft(2, '0')}",
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'details': details.map((d) => d.toJson()).toList(),
    'tahun_ajar': tahunAjar.toJson(),
  };
}

// Model utama untuk seluruh respons API
class MyFrsResponseModel {
  final bool success;
  final FrsDataPayloadModel? data; // Menggunakan FrsDataPayloadModel
  final TahunAjarDisplayModel? tahunAjar;

  MyFrsResponseModel({
    required this.success,
    this.data,
    this.tahunAjar,
  });

  factory MyFrsResponseModel.fromJson(Map<String, dynamic> json) {
    return MyFrsResponseModel(
      success: json['success'] as bool,
      data: json['data'] != null ? FrsDataPayloadModel.fromJson(json['data'] as Map<String, dynamic>) : null,
      tahunAjar: json['tahun_ajar'] != null ? TahunAjarDisplayModel.fromJson(json['tahun_ajar'] as Map<String, dynamic>) : null,
    );
  }

   Map<String, dynamic> toJson() => {
    'success': success,
    'data': data?.toJson(),
    'tahun_ajar': tahunAjar?.toJson(),
  };
}