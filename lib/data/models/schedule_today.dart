class ScheduleToday {
  final String? id;
  final String hari;
  final String jamMulai;
  final String jamSelesai;
  final String matakuliah;
  final String kelas;
  final String dosen;
  final String ruang; // Nama field di Dart

  ScheduleToday({
    this.id,
    required this.hari,
    required this.jamMulai,
    required this.jamSelesai,
    required this.matakuliah,
    required this.kelas,
    required this.dosen,
    required this.ruang,
  });

  factory ScheduleToday.fromJson(Map<String, dynamic> json) {
    return ScheduleToday(
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

   // Tambahkan helper methods untuk notifikasi
  DateTime get startDateTime {
    final now = DateTime.now();
    final timeParts = jamMulai.split(':');
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );
  }

  DateTime get endDateTime {
    final now = DateTime.now();
    final timeParts = jamSelesai.split(':');
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );
  }

  DateTime get notificationTime {
    return startDateTime.subtract(const Duration(minutes: 30));
  }

  bool get canScheduleNotification {
    final now = DateTime.now();
    return notificationTime.isAfter(now);
  }

  int get notificationId {
    return id != null ? int.tryParse(id!) ?? hashCode : hashCode;
  }
}

class ScheduleListData {
  final List<ScheduleToday> data;

  ScheduleListData({required this.data});

  factory ScheduleListData.fromJson(Map<String, dynamic> jsonMap) {
    if (jsonMap.containsKey('data') && jsonMap['data'] is List) {
      return ScheduleListData(
        data: (jsonMap['data'] as List)
            .map((item) => ScheduleToday.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
    } else {
      print("Warning: Kunci 'data' di ScheduleListData.fromJson tidak ditemukan atau bukan List. Mengembalikan list kosong.");
      return ScheduleListData(data: []);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "data": data.map((item) => item.toJson()).toList(),
    };
  }
  
}

