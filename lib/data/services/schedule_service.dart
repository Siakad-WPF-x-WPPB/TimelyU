import 'dart:convert';
import 'dart:async'; // Untuk TimeoutException
import 'dart:io';   // Untuk SocketException, HttpException, dan HttpStatus
import 'package:http/http.dart' as http;
import 'package:timelyu/data/models/schedule.dart';
import 'package:timelyu/data/client/api_client.dart';

class ScheduleService extends BaseApiService { 

  Future<ApiResponse<MyFrsResponseModel>> getMyFrs() async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        return ApiResponse.error(
          "Autentikasi gagal: Token tidak ditemukan.",
          statusCode: HttpStatus.unauthorized,
        );
      }

      final response = await http.get(
        // Gunakan BaseApiService.baseUrl
        Uri.parse('${BaseApiService.baseUrl}/frs/my-frs'),
        headers: getHeaders(requiresAuth: true, token: token),
      ).timeout(const Duration(seconds: 20));

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == HttpStatus.ok) {
        final myFrsData = MyFrsResponseModel.fromJson(responseData);

        if (myFrsData.success) {
          // Jika 'success' di dalam body adalah true
          if (myFrsData.data != null) { // Memastikan payload data utama ada
            return ApiResponse.success(
              myFrsData, // Kembalikan seluruh MyFrsResponseModel jika itu yang diinginkan
              message: responseData['message'] as String? ?? "Data FRS berhasil diambil."
            );
          } else {
            // Kasus success true tapi data payload null
            return ApiResponse.error(
              responseData['message'] as String? ?? "Data FRS tidak ditemukan meskipun respons sukses.",
              statusCode: response.statusCode,
            );
          }
        } else {
          // Jika 'success' di dalam body adalah false (meskipun status code HTTP mungkin 200 OK)
          return ApiResponse.error(
            responseData['message'] as String? ?? "Gagal mengambil data FRS dari server.",
            statusCode: response.statusCode,
            validationErrors: responseData.containsKey('errors') ? responseData['errors'] as Map<String, dynamic> : null,
          );
        }
      } else {
        // Gagal mendapatkan data (status code HTTP bukan 200 OK)
        String errorMessage = "Gagal mengambil data FRS.";
        Map<String, dynamic>? validationErrors;
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
        statusCode: HttpStatus.serviceUnavailable,
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
