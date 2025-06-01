// data/models/frs_model.dart

class FrsModel {
  final String id; // ID unik untuk item FRS ini
  final String? idJadwalAsal; // KUNCI: Harus cocok dengan JadwalMatakuliahModel.idJadwal
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
  final int tahunAjar; // KUNCI: Harus integer tahun mulai (misal 2023 untuk 2023/2024)
  final int tahunBerakhir;
  final String semester; // KUNCI: Harus string (misal "Genap", "Ganjil")

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

  // Helper untuk parsing tahun ajar dari string "YYYY/YYYY"
  static Map<String, int?> _parseTahunAjarStringFormat(String? tahunAjarStr) {
    if (tahunAjarStr == null || tahunAjarStr.isEmpty) {
      return {'tahun_ajar': null, 'tahun_berakhir': null};
    }
    try {
      List<String> parts = tahunAjarStr.split('/');
      if (parts.length == 2) {
        return {
          'tahun_ajar': int.tryParse(parts[0]),
          'tahun_berakhir': int.tryParse(parts[1]),
        };
      }
    } catch (e) {
      print("FrsModel (_parseTahunAjarStringFormat): Error parsing '$tahunAjarStr': $e");
    }
    return {'tahun_ajar': null, 'tahun_berakhir': null};
  }

  factory FrsModel.fromJson(Map<String, dynamic> json) {
    // Helper untuk mengambil nilai integer dari field yang mungkin berupa int atau Map
    int? _parseIntFromDynamic(dynamic value, {String keyInMap = 'value'}) {
      if (value is int) {
        return value;
      } else if (value is String) {
        return int.tryParse(value);
      } else if (value is Map<String, dynamic> && value.containsKey(keyInMap) && value[keyInMap] is int) {
        return value[keyInMap] as int?;
      } else if (value is Map<String, dynamic> && value.containsKey(keyInMap) && value[keyInMap] is String) {
        return int.tryParse(value[keyInMap] as String);
      }
      return null;
    }

    int? parsedTahunAjar;
    int? parsedTahunBerakhir;
    dynamic tahunAjarJsonValue = json['tahun_ajar'];

    if (tahunAjarJsonValue is String && tahunAjarJsonValue.contains('/')) {
      // Jika API mengirim "tahun_ajar" sebagai "YYYY/YYYY"
      Map<String, int?> parsedYears = _parseTahunAjarStringFormat(tahunAjarJsonValue);
      parsedTahunAjar = parsedYears['tahun_ajar'];
      parsedTahunBerakhir = parsedYears['tahun_berakhir'];
    } else {
      // Jika API mengirim "tahun_ajar" sebagai integer atau string angka
      parsedTahunAjar = _parseIntFromDynamic(tahunAjarJsonValue);
      // Jika API mengirim "tahun_berakhir" secara terpisah (opsional)
      if (json.containsKey('tahun_berakhir')) {
         parsedTahunBerakhir = _parseIntFromDynamic(json['tahun_berakhir']);
      }
    }

    // Fallback jika parsing gagal atau field tidak ada
    // Penting: Sesuaikan fallback ini jika diperlukan. Menggunakan DateTime.now().year bisa berisiko jika data FRS untuk tahun yang sangat berbeda.
    int finalTahunAjar = parsedTahunAjar ?? DateTime.now().year;
    int finalTahunBerakhir = parsedTahunBerakhir ?? (finalTahunAjar + 1);

    // Pastikan tahun berakhir selalu lebih besar atau sama dengan tahun ajar
    if (finalTahunBerakhir < finalTahunAjar) {
      finalTahunBerakhir = finalTahunAjar + 1;
    }

    return FrsModel(
      id: json['id'] as String? ?? '',
      idJadwalAsal: json['id_jadwal_asal'] as String? ?? json['jadwal_id'] as String?, // SANGAT PENTING
      status: json['status'] as String? ?? 'pending',
      hari: json['hari'] as String? ?? '',
      jamMulai: json['jam_mulai'] as String? ?? '',
      jamSelesai: json['jam_selesai'] as String? ?? '',
      namaMatakuliah: json['nama_matakuliah'] as String? ?? json['matakuliah'] as String? ?? '',
      tipeMatakuliah: json['tipe_matakuliah'] as String? ?? '',
      sks: (json['sks'] is String ? int.tryParse(json['sks']) : json['sks'] as int?) ?? 0,
      namaDosen: json['nama_dosen'] as String? ?? json['dosen'] as String? ?? '',
      kelas: json['kelas'] as String? ?? '',
      ruangan: json['ruangan'] as String? ?? '',
      tahunAjar: finalTahunAjar, // SANGAT PENTING
      tahunBerakhir: finalTahunBerakhir,
      semester: json['semester'] as String? ?? '', // SANGAT PENTING
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
      // data['id_jadwal_asal'] = idJadwalAsal; // Biasanya tidak perlu mengirim ini kembali
    }
    return data;
  }
}