 import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:timelyu/data/client/api_client.dart';
import 'package:timelyu/data/models/pengumuman_model.dart';


class PengumumanService extends BaseApiService { 
  Future<ApiResponse<PengumumanResponseModel>> getPengumuman() async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        return ApiResponse.error(
          "Autentikasi gagal: Token tidak ditemukan.",
          statusCode: HttpStatus.unauthorized,
        );
      }
      final String apiPath = "/pengumuman";
      final Uri requestUri = Uri.parse('${BaseApiService.baseUrl}$apiPath');

      print('(Pengumuman) Requesting from: $requestUri');

      final response = await http.get(
        requestUri,
        headers: getHeaders(requiresAuth: true, token: token),
      ).timeout(const Duration(seconds: 20));
      if (response.statusCode == HttpStatus.ok) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final pengumumanResponse = PengumumanResponseModel.fromJson(responseData);
        return ApiResponse.success(
          pengumumanResponse,
          message: "Data pengumuman berhasil diambil."
        );
      } else {
        String errorMessage = "Gagal mengambil data pengumuman (HTTP ${response.statusCode}).";
        Map<String, dynamic>? validationErrors;
        try {
          final Map<String, dynamic> errorBody = jsonDecode(response.body);
          if (errorBody.containsKey('message') && errorBody['message'] is String) {
            errorMessage = errorBody['message'];
          }
          if (errorBody.containsKey('errors') && errorBody['errors'] is Map) {
            validationErrors = errorBody['errors'] as Map<String, dynamic>;
          }
        } catch (e) {
          print("Gagal parse body error di getPengumuman: $e");
        }
        return ApiResponse.error(
          errorMessage,
          statusCode: response.statusCode,
          validationErrors: validationErrors,
        );
      }
    } on SocketException {
      return ApiResponse.error("Kesalahan jaringan: Tidak dapat terhubung ke server.", statusCode: HttpStatus.serviceUnavailable);
    } on HttpException catch (e) {
      print('HttpException di getPengumuman: ${e.message}');
      return ApiResponse.error("Kesalahan koneksi HTTP: ${e.message}");
    } on FormatException {
      return ApiResponse.error("Kesalahan format data: Respons dari server tidak valid.");
    } on TimeoutException {
      return ApiResponse.error("Kesalahan: Waktu tunggu koneksi ke server habis.");
    } catch (e) {
      print('Error tidak terduga di getPengumuman: $e');
      return ApiResponse.error("Terjadi kesalahan yang tidak terduga: ${e.toString()}");
    }
  }
}