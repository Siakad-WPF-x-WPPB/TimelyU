class Schedule {
  final int id;
  final String hari;
  final String jamMulai;
  final String jamSelesai;
  final String mataKuliah;
  final String dosen;
  final String kelas;
  final String ruangan;

  Schedule({
    required this.id,
    required this.hari,
    required this.jamMulai,
    required this.jamSelesai,
    required this.mataKuliah,
    required this.dosen,
    required this.kelas,
    required this.ruangan,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    try {
      // Handle berbagai kemungkinan field names dari API
      return Schedule(
        id: _parseId(json),
        hari: _parseString(json['hari']),
        jamMulai: _parseTimeString(json['jam_mulai']),
        jamSelesai: _parseTimeString(json['jam_selesai']),
        mataKuliah: _parseString(json['mata_kuliah'] ?? json['matakuliah']),
        dosen: _parseString(json['dosen'] ?? json['nama_dosen']),
        kelas: _parseString(json['kelas']),
        ruangan: _parseString(json['ruangan']),
      );
    } catch (e) {
      print('❌ Error parsing Schedule from JSON: $json');
      print('❌ Error details: $e');
      rethrow;
    }
  }

  // Helper method untuk parsing ID
  static int _parseId(Map<String, dynamic> json) {
    final id = json['id'];
    if (id is int) return id;
    if (id is String) return int.tryParse(id) ?? 0;
    return 0; // Default fallback
  }

  // Helper method untuk parsing String
  static String _parseString(dynamic value) {
    if (value == null) return '';
    return value.toString().trim();
  }

  // Helper method untuk parsing waktu
  static String _parseTimeString(dynamic value) {
    if (value == null) return '00:00';
    String timeStr = value.toString().trim();
    
    // Jika format "HH:mm:ss", ambil hanya "HH:mm"
    if (timeStr.contains(':') && timeStr.split(':').length >= 2) {
      List<String> parts = timeStr.split(':');
      return '${parts[0]}:${parts[1]}';
    }
    
    return timeStr.isEmpty ? '00:00' : timeStr;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hari': hari,
      'jam_mulai': jamMulai,
      'jam_selesai': jamSelesai,
      'mata_kuliah': mataKuliah,
      'dosen': dosen,
      'kelas': kelas,
      'ruangan': ruangan,
    };
  }

  /// Representasi objek Schedule sebagai String untuk debugging
  @override
  String toString() => 'Schedule(id: $id, mataKuliah: $mataKuliah, hari: $hari, waktu: $jamMulai-$jamSelesai)';
  
  /// Method untuk validasi data schedule
  bool isValid() {
    return id > 0 && 
           hari.isNotEmpty && 
           jamMulai.isNotEmpty && 
           jamSelesai.isNotEmpty && 
           mataKuliah.isNotEmpty;
  }
}