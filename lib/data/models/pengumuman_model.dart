class PengumumanItemModel {
  final String? id;
  final String namaPembuat;
  final String judul;
  final String isi;
  final String tanggalDibuat;
  final String status;

  PengumumanItemModel({
    this.id,
    required this.namaPembuat,
    required this.judul,
    required this.isi,
    required this.tanggalDibuat,
    required this.status,
  });

  factory PengumumanItemModel.fromJson(Map<String, dynamic> json) {
    return PengumumanItemModel(
      id: json['id'] as String?,
      namaPembuat: json['nama_pembuat'] as String? ?? '', // Default ke string kosong jika null
      judul: json['judul'] as String? ?? '',
      isi: json['isi'] as String? ?? '',
      tanggalDibuat: json['tanggal_dibuat'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_pembuat': namaPembuat,
      'judul': judul,
      'isi': isi,
      'tanggal_dibuat': tanggalDibuat,
      'status': status,
    };
  }
}

class PengumumanResponseModel {
  final int draw;
  final int recordsTotal;
  final int recordsFiltered;
  final List<PengumumanItemModel> data;

  PengumumanResponseModel({
    required this.draw,
    required this.recordsTotal,
    required this.recordsFiltered,
    required this.data,
  });

  factory PengumumanResponseModel.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List? ?? []; // Default ke list kosong jika null atau tidak ada
    List<PengumumanItemModel> pengumumanList = list
        .map((item) => PengumumanItemModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return PengumumanResponseModel(
      draw: json['draw'] as int? ?? 0, // Default ke 0 jika null
      recordsTotal: json['recordsTotal'] as int? ?? 0,
      recordsFiltered: json['recordsFiltered'] as int? ?? 0,
      data: pengumumanList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'draw': draw,
      'recordsTotal': recordsTotal,
      'recordsFiltered': recordsFiltered,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}