import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/nilai_model.dart';

// kelas ApiResponse (seperti yang Anda berikan)
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
    T? data, // Memungkinkan untuk mengirim data parsial atau informasi error tambahan
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

// Layanan untuk mengelola nilai
class NilaiService {
  static const String _baseUrl = "http://192.168.68.200:8000/api/mahasiswa";
  static const String _tokenKey = 'auth_token';

  // Method untuk mendapatkan token dari SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Method untuk membuat headers HTTP
  Map<String, String> _getHeaders({bool requiresAuth = false, String? token}) {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (requiresAuth && token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // Method untuk mengambil daftar nilai mahasiswa
  Future<ApiResponse<List<NilaiModel>>> getNilai() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return ApiResponse.error(
          "Autentikasi gagal: Token tidak ditemukan.",
          statusCode: HttpStatus.unauthorized,
        );
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/nilai'), // Endpoint untuk mendapatkan nilai
        headers: _getHeaders(requiresAuth: true, token: token),
      );

      if (response.statusCode == HttpStatus.ok) {
        // Berhasil mendapatkan data
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // API Anda mengembalikan data dalam field 'data' yang berisi list
        if (responseData.containsKey('data') && responseData['data'] is List) {
          final List<dynamic> nilaiListJson = responseData['data'];
          final List<NilaiModel> nilaiList = nilaiListJson
              .map((jsonItem) => NilaiModel.fromJson(jsonItem as Map<String, dynamic>))
              .toList();
          return ApiResponse.success(nilaiList, message: "Data nilai berhasil diambil.");
        } else {
          return ApiResponse.error(
            "Format respons tidak valid: field 'data' tidak ditemukan atau bukan list.",
            statusCode: response.statusCode,
          );
        }
      } else {
        // Gagal mendapatkan data, tangani berbagai status code error
        String errorMessage = "Gagal mengambil data nilai.";
        Map<String, dynamic>? validationErrors;
        try {
          // Coba parse body error jika ada pesan dari server
          final Map<String, dynamic> errorData = jsonDecode(response.body);
          if (errorData.containsKey('message') && errorData['message'] is String) {
            errorMessage = errorData['message'];
          }
          if (errorData.containsKey('errors') && errorData['errors'] is Map) {
            validationErrors = errorData['errors'] as Map<String, dynamic>;
          }
        } catch (e) {
          // Jika body error bukan JSON atau tidak ada pesan, gunakan pesan default
          // atau response.reasonPhrase jika tersedia
          errorMessage = response.reasonPhrase ?? errorMessage;
        }
        return ApiResponse.error(
          errorMessage,
          statusCode: response.statusCode,
          validationErrors: validationErrors,
        );
      }
    } on SocketException {
      // Error koneksi jaringan (misalnya, tidak ada internet, server tidak terjangkau)
      return ApiResponse.error(
        "Kesalahan jaringan: Tidak dapat terhubung ke server. Periksa koneksi internet Anda.",
        statusCode: HttpStatus.serviceUnavailable, // Atau kode status lain yang sesuai
      );
    } on HttpException {
      // Error HTTP lainnya yang tidak tertangkap oleh status code di atas
      return ApiResponse.error(
        "Kesalahan koneksi: Terjadi masalah saat berkomunikasi dengan server.",
      );
    } on FormatException {
      // Error jika respons dari server bukan JSON yang valid
      return ApiResponse.error(
        "Kesalahan format data: Respons dari server tidak valid.",
      );
    } catch (e) {
      // Error tidak terduga lainnya
      print('Error di getNilai: $e'); // Logging error untuk debugging
      return ApiResponse.error("Terjadi kesalahan yang tidak terduga: ${e.toString()}");
    }
  }
}
