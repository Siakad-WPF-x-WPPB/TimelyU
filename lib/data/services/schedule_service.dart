import 'dart:convert';
import 'dart:async'; // Untuk TimeoutException
import 'dart:io';   // Untuk SocketException, HttpException, dan HttpStatus
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timelyu/data/models/schedule.dart';


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

class ScheduleService {
  // Sesuaikan IP Address ini jika server Anda berbeda atau jika menggunakan emulator
  // Untuk Android emulator, '10.0.2.2' biasanya merujuk ke localhost mesin host.
  // '127.0.0.1' untuk iOS simulator jika server berjalan di mesin yang sama.
  static const String _baseUrl = "http://192.168.183.246:8000/api/mahasiswa";
  static const String _tokenKey = "auth_token";

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

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

  Future<ApiResponse<MyFrsResponseModel>> getMyFrs() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return ApiResponse.error(
          "Autentikasi gagal: Token tidak ditemukan.",
          statusCode: HttpStatus.unauthorized,
        );
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/frs/my-frs'),
        headers: _getHeaders(requiresAuth: true, token: token),
      ).timeout(const Duration(seconds: 20));

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == HttpStatus.ok) {
        final myFrsData = MyFrsResponseModel.fromJson(responseData);
        
        if (myFrsData.success) {
          if (myFrsData.data != null) { // Memastikan data utama ada jika sukses true
              return ApiResponse.success(myFrsData, message: responseData['message'] as String? ?? "Data FRS berhasil diambil.");
          } else {
              // Kasus success true tapi data utama (payload) null
              return ApiResponse.error(
                responseData['message'] as String? ?? "Data FRS tidak ditemukan meskipun respons sukses.",
                statusCode: response.statusCode,
              );
          }
        } else {
          // Jika API mengembalikan success: false di body JSON (tapi status code mungkin 200 OK)
          return ApiResponse.error(
            responseData['message'] as String? ?? "Gagal mengambil data FRS dari server.",
            statusCode: response.statusCode, // Bisa jadi 200 OK tapi success: false
            validationErrors: responseData.containsKey('errors') ? responseData['errors'] as Map<String, dynamic> : null,
          );
        }
      } else {
        // Gagal mendapatkan data (status code bukan 200 OK)
        String errorMessage = "Gagal mengambil data FRS.";
        Map<String, dynamic>? validationErrors;
        // responseData sudah di-decode di atas, bisa langsung digunakan
        if (responseData.containsKey('message') && responseData['message'] is String) {
          errorMessage = responseData['message'];
        }
        if (responseData.containsKey('errors') && responseData['errors'] is Map) {
          validationErrors = responseData['errors'] as Map<String, dynamic>;
        }
        return ApiResponse.error(
          errorMessage,
          statusCode: response.statusCode,
          validationErrors: validationErrors,
        );
      }
    } on SocketException {
      return ApiResponse.error(
        "Kesalahan jaringan: Tidak dapat terhubung ke server.",
        statusCode: HttpStatus.serviceUnavailable, // Kode status buatan untuk identifikasi
      );
    } on HttpException catch(e) {
        print('HttpException di getMyFrs: ${e.message}');
        return ApiResponse.error("Kesalahan koneksi HTTP: ${e.message}");
    } on FormatException {
      return ApiResponse.error("Kesalahan format data: Respons dari server tidak valid.");
    } on TimeoutException {
        return ApiResponse.error("Kesalahan: Waktu tunggu koneksi ke server habis.");
    } catch (e) {
      print('Error tidak terduga di getMyFrs: $e');
      return ApiResponse.error("Terjadi kesalahan yang tidak terduga: ${e.toString()}");
    }
  }
}