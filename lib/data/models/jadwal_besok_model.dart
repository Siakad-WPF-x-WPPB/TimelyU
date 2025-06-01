// models/jadwal_besok_model.dart
class JadwalBesokModel {
  final String? id;
  final String hari;
  final String jamMulai;
  final String jamSelesai;
  final String matakuliah;
  final String kelas;
  final String dosen;
  final String ruang;

  JadwalBesokModel({
    this.id,
    required this.hari,
    required this.jamMulai,
    required this.jamSelesai,
    required this.matakuliah,
    required this.kelas,
    required this.dosen,
    required this.ruang,
  });

  factory JadwalBesokModel.fromJson(Map<String, dynamic> json) {
    return JadwalBesokModel(
      id: json['id'] as String?,
      hari: json['hari'] as String,
      jamMulai: json['jam_mulai'] as String,
      jamSelesai: json['jam_selesai'] as String,
      matakuliah: json['matakuliah'] as String,
      kelas: json['kelas'] as String,
      dosen: json['dosen'] as String,
      ruang: json['ruangan'] as String, // Mengambil dari key 'ruangan' di JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hari': hari,
      'jam_mulai': jamMulai,
      'jam_selesai': jamSelesai,
      'matakuliah': matakuliah,
      'kelas': kelas,
      'dosen': dosen,
      'ruangan': ruang, // Menggunakan key 'ruangan' saat konversi ke JSON
    };
  }
}

class JadwalBesokListData {
  final List<JadwalBesokModel> data;

  JadwalBesokListData({required this.data});

  factory JadwalBesokListData.fromJson(Map<String, dynamic> jsonMap) {
    // Model ini mengharapkan input jsonMap berupa: {"data": [ ... list item JadwalBesokModel ... ]}
    if (jsonMap.containsKey('data') && jsonMap['data'] is List) {
      return JadwalBesokListData(
        data: (jsonMap['data'] as List)
            .map((item) => JadwalBesokModel.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
    } else {
      print("Warning: Kunci 'data' di JadwalBesokListData.fromJson tidak ditemukan atau bukan List. Mengembalikan list kosong.");
      return JadwalBesokListData(data: []);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "data": data.map((item) => item.toJson()).toList(),
    };
  }
}