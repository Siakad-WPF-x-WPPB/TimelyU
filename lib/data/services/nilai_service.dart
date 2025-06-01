// timelyu/data/services/nilai_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:timelyu/data/models/nilai_model.dart';
// Pastikan path ini benar dan BaseApiService serta ApiResponse terdefinisi di sana
import 'package:timelyu/data/client/api_client.dart';

class NilaiService extends BaseApiService {
  // Fungsi untuk mendapatkan nilai
  Future<ApiResponse<List<NilaiModel>>> getNilai() async {
    try {
      final token = await getToken(); // Asumsi getToken() ada di BaseApiService atau di sini
      if (token == null || token.isEmpty) {
        return ApiResponse.error(
          "Autentikasi gagal: Token tidak ditemukan.",
          statusCode: HttpStatus.unauthorized,
        );
      }

      final response = await http.get(
        Uri.parse('${BaseApiService.baseUrl}/nilai'), // Asumsi baseUrl ada di BaseApiService
        headers: getHeaders(requiresAuth: true, token: token), // Asumsi getHeaders ada di BaseApiService
      );

      if (response.statusCode == HttpStatus.ok) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
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
        String errorMessage = "Gagal mengambil data nilai.";
        Map<String, dynamic>? validationErrors;
        try {
          final Map<String, dynamic> errorData = jsonDecode(response.body);
          if (errorData.containsKey('message') && errorData['message'] is String) {
            errorMessage = errorData['message'];
          }
          if (errorData.containsKey('errors') && errorData['errors'] is Map) {
            validationErrors = errorData['errors'] as Map<String, dynamic>;
          }
        } catch (e) {
          errorMessage = response.reasonPhrase ?? errorMessage;
        }
        return ApiResponse.error(
          errorMessage,
          statusCode: response.statusCode,
          validationErrors: validationErrors,
        );
      }
    } on SocketException {
      return ApiResponse.error(
        "Kesalahan jaringan: Tidak dapat terhubung ke server. Periksa koneksi internet Anda.",
        statusCode: HttpStatus.serviceUnavailable,
      );
    } on HttpException {
      return ApiResponse.error(
        "Kesalahan koneksi: Terjadi masalah saat berkomunikasi dengan server.",
      );
    } on FormatException {
      return ApiResponse.error(
        "Kesalahan format data: Respons dari server tidak valid.",
      );
    } catch (e) {
      print('Error di getNilai: $e');
      return ApiResponse.error("Terjadi kesalahan yang tidak terduga: ${e.toString()}");
    }
  }
}