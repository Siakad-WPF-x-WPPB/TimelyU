// data/services/frs_service.dart

import 'dart:convert';
import 'dart:io'; // Untuk HttpStatus dan SocketException

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timelyu/data/models/frs_model.dart';
import 'package:timelyu/data/models/jadwal_matkul.model.dart';

// --- Kelas ApiResponse ---
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final int? statusCode;
  final Map<String, dynamic>? validationErrors;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.statusCode,
    this.validationErrors,
  });

  factory ApiResponse.success(T data, {String? message, int? statusCode = HttpStatus.ok}) =>
      ApiResponse(
        success: true,
        data: data,
        message: message,
        statusCode: statusCode,
        validationErrors: null,
      );

  factory ApiResponse.error(
    String message, {
    int? statusCode,
    T? data,
    Map<String, dynamic>? validationErrors,
  }) =>
      ApiResponse(
        success: false,
        message: message,
        statusCode: statusCode,
        data: data,
        validationErrors: validationErrors,
      );
}

// --- Layanan untuk FRS ---
class FrsService {
  // Ganti dengan IP address dan port backend Anda yang sebenarnya
  static const String _baseUrl = "http://192.168.183.246:8000/api/mahasiswa";
  static const String _tokenKey = 'auth_token';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Map<String, String> _getHeaders({bool requiresAuth = false, String? token}) {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (requiresAuth && token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Map<String, int> _parseTahunAjar(String tahunAjar) { // Format "YYYY/YYYY"
    try {
      List<String> parts = tahunAjar.split('/');
      if (parts.length == 2) {
        return {
          'tahun_ajar': int.parse(parts[0]),       // Ini akan menjadi tahun_mulai
          'tahun_berakhir': int.parse(parts[1]), // Ini akan menjadi tahun_akhir
        };
      }
    } catch (e) {
      print("Error parsing tahun ajar '$tahunAjar': $e");
    }
    return { // Fallback
      'tahun_ajar': DateTime.now().year,
      'tahun_berakhir': DateTime.now().year + 1,
    };
  }

  Future<ApiResponse<List<FrsModel>>> getFrsData({
    required String tahunAjar, // Format "YYYY/YYYY"
    required String semester,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) return ApiResponse.error('Token tidak ditemukan.', statusCode: HttpStatus.unauthorized);

      final tahunData = _parseTahunAjar(tahunAjar);
      final queryParameters = <String, String>{
        'tahun_ajar': tahunData['tahun_ajar'].toString(), 
        'semester': semester.toLowerCase(),
      };

      final uri = Uri.parse('$_baseUrl/frs').replace(queryParameters: queryParameters);
      print("FrsService (getFrsData): Calling URL - $uri");
      final response = await http.get(uri, headers: _getHeaders(requiresAuth: true, token: token));
      print("FrsService (getFrsData): Response Status - ${response.statusCode}");

      if (response.statusCode == HttpStatus.ok) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['data'] != null && body['data'] is List) {
          final List<FrsModel> frsList = (body['data'] as List)
              .map((item) => FrsModel.fromJson(item as Map<String, dynamic>))
              .toList();
          return ApiResponse.success(frsList, statusCode: response.statusCode);
        }
        return ApiResponse.error('Format data FRS tidak valid.', statusCode: response.statusCode);
      } else if (response.statusCode == HttpStatus.unauthorized) {
        return ApiResponse.error('Sesi berakhir atau token tidak valid.', statusCode: response.statusCode);
      } else {
        String msg = 'Gagal mengambil data FRS.';
        try { msg = jsonDecode(response.body)['message'] ?? msg; } catch (_) {}
        return ApiResponse.error(msg, statusCode: response.statusCode);
      }
    } on SocketException {
      return ApiResponse.error('Tidak ada koneksi internet.');
    } catch (e) {
      print("FrsService (getFrsData): Generic error - $e");
      return ApiResponse.error('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<ApiResponse<List<JadwalMatakuliahModel>>> getJadwalPilihan({
    String? tahunAjar, // Format "YYYY/YYYY", contoh: "2023/2024"
    String? semester,  // Contoh: "Ganjil"
  }) async {
    try {
      final token = await _getToken();
      if (token == null) return ApiResponse.error('Token tidak ditemukan.', statusCode: HttpStatus.unauthorized);

      final queryParameters = <String, String>{};
      if (tahunAjar != null && semester != null && tahunAjar.isNotEmpty && semester.isNotEmpty) {
        final tahunData = _parseTahunAjar(tahunAjar);
        queryParameters['semester'] = semester.toLowerCase();
        queryParameters['tahun_mulai'] = tahunData['tahun_ajar'].toString();
        queryParameters['tahun_akhir'] = tahunData['tahun_berakhir'].toString();
      }

      final uri = Uri.parse('$_baseUrl/jadwal/program-studi').replace(queryParameters: queryParameters);
      print("FrsService (getJadwalPilihan): Calling URL - $uri");
      final response = await http.get(uri, headers: _getHeaders(requiresAuth: true, token: token));
      print("FrsService (getJadwalPilihan): Response Status - ${response.statusCode}");

      if (response.statusCode == HttpStatus.ok) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['data'] != null && body['data'] is List) {
          final List<JadwalMatakuliahModel> jadwalList = (body['data'] as List)
              .map((item) => JadwalMatakuliahModel.fromJson(item as Map<String, dynamic>))
              .toList();
          return ApiResponse.success(jadwalList, statusCode: response.statusCode);
        }
        return ApiResponse.error('Format data jadwal tidak valid.', statusCode: response.statusCode);
      } else if (response.statusCode == HttpStatus.unauthorized) {
        return ApiResponse.error('Sesi berakhir atau token tidak valid.', statusCode: response.statusCode);
      } else {
        String msg = 'Gagal mengambil data jadwal.';
        try { msg = jsonDecode(response.body)['message'] ?? msg; } catch (_) {}
        return ApiResponse.error(msg, statusCode: response.statusCode);
      }
    } on SocketException {
      return ApiResponse.error('Tidak ada koneksi internet.');
    } catch (e) {
      print("FrsService (getJadwalPilihan): Generic error - $e");
      return ApiResponse.error('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<ApiResponse<List<FrsModel>>> storeFrs({
    required List<String> idJadwalDipilih,
    required String tahunAjar, // Format "YYYY/YYYY"
    required String semester,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) return ApiResponse.error('Token tidak ditemukan.', statusCode: HttpStatus.unauthorized);

      final tahunData = _parseTahunAjar(tahunAjar);
      final Map<String, dynamic> requestBody = {
        // PERUBAHAN KUNCI DI SINI:
        'jadwal_ids': idJadwalDipilih, // Diubah dari 'id_jadwal_dipilih' menjadi 'jadwal_ids'
        'tahun_ajar': tahunData['tahun_ajar'],
        'semester': semester.toLowerCase(),
      };

      final uri = Uri.parse('$_baseUrl/frs/store');
      print("FrsService (storeFrs): Calling URL - $uri");
      print("FrsService (storeFrs): Request Body - ${jsonEncode(requestBody)}");
      final response = await http.post(uri, headers: _getHeaders(requiresAuth: true, token: token), body: jsonEncode(requestBody));
      print("FrsService (storeFrs): Response Status - ${response.statusCode}");

      if (response.statusCode == HttpStatus.created || response.statusCode == HttpStatus.ok) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final String? message = body['message'] as String?;
        
        if (body['data'] != null && body['data'] is List) {
          final List<FrsModel> createdFrsList = (body['data'] as List)
              .map((item) => FrsModel.fromJson(item as Map<String, dynamic>))
              .toList();
          return ApiResponse.success(createdFrsList, message: message ?? "FRS berhasil disimpan.", statusCode: response.statusCode);
        } else if (body['data'] != null && body['data'] is Map<String,dynamic>) {
            final FrsModel createdFrs = FrsModel.fromJson(body['data'] as Map<String,dynamic>);
            return ApiResponse.success([createdFrs], message: message ?? "FRS berhasil disimpan.", statusCode: response.statusCode);
        }
        return ApiResponse.success(<FrsModel>[], message: message ?? 'FRS berhasil disimpan.', statusCode: response.statusCode);
      } else if (response.statusCode == HttpStatus.unauthorized) {
        return ApiResponse.error('Sesi berakhir atau token tidak valid.', statusCode: response.statusCode);
      } else if (response.statusCode == HttpStatus.unprocessableEntity) { // 422
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        return ApiResponse.error(
          errorBody['message'] as String? ?? 'Data yang dikirim tidak valid.',
          statusCode: response.statusCode,
          validationErrors: errorBody['errors'] as Map<String, dynamic>?,
        );
      } else {
        String msg = 'Gagal menyimpan FRS.';
        try { msg = jsonDecode(response.body)['message'] ?? msg; } catch (_) {}
        return ApiResponse.error(msg, statusCode: response.statusCode);
      }
    } on SocketException {
      return ApiResponse.error('Tidak ada koneksi internet.');
    } catch (e) {
      print("FrsService (storeFrs): Generic error - $e");
      return ApiResponse.error('Terjadi kesalahan: ${e.toString()}');
    }
  }
}
