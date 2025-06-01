import 'dart:convert';
import 'dart:async'; // Untuk TimeoutException
import 'dart:io';   // Untuk SocketException, HttpException, dan HttpStatus
import 'package:http/http.dart' as http;
import 'package:timelyu/data/models/jadwal_besok_model.dart';
import 'package:timelyu/data/models/schedule.dart';
import 'package:timelyu/data/client/api_client.dart';
import 'package:timelyu/data/models/schedule_today.dart';

class ScheduleService extends BaseApiService { 

  // Fungsi untuk mendapatkan data FRS (Form Rencana Studi) pengguna dan dijadikan sebagai jadwal mahasiswa tersebut
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

  // Fungsi untuk mendapatkan jadwal hari ini
  Future<ApiResponse<ScheduleListData>> getJadwalHariIni() async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        return ApiResponse.error(
          "Autentikasi gagal: Token tidak ditemukan.",
          statusCode: HttpStatus.unauthorized,
        );
      }
      final String apiPath = "/jadwal/today"; // Sesuaikan ini dengan baseUrl Anda
      
      final Uri requestUri = Uri.parse('${BaseApiService.baseUrl}$apiPath');
      
      print('Requesting Schedule Today from: $requestUri'); // Untuk debug URL

      final response = await http.get(
        requestUri,
        headers: getHeaders(requiresAuth: true, token: token), // Asumsi method ini ada
      ).timeout(const Duration(seconds: 20));
      if (response.statusCode == HttpStatus.ok) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final scheduleListData = ScheduleListData.fromJson(responseData);

        return ApiResponse.success(
          scheduleListData,
          message: scheduleListData.data.isNotEmpty
              ? "Jadwal hari ini berhasil diambil."
              : "Tidak ada jadwal untuk hari ini."
        );
      } else {
        String errorMessage = "Gagal mengambil data jadwal (HTTP ${response.statusCode}).";
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
          print("Gagal parse body error di getJadwalHariIni: $e");
          // errorMessage tetap menggunakan nilai default jika parsing gagal
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
    } on HttpException catch (e) {
      print('HttpException di getJadwalHariIni: ${e.message}');
      return ApiResponse.error("Kesalahan koneksi HTTP: ${e.message}");
    } on FormatException {
      return ApiResponse.error("Kesalahan format data: Respons dari server tidak valid.");
    } on TimeoutException {
      return ApiResponse.error("Kesalahan: Waktu tunggu koneksi ke server habis.");
    } catch (e) {
      print('Error tidak terduga di getJadwalHariIni: $e');
      return ApiResponse.error("Terjadi kesalahan yang tidak terduga: ${e.toString()}");
    }
  }

      // --- Method untuk Jadwal Besok disesuaikan dengan JadwalBesokModel ---
       Future<ApiResponse<JadwalBesokListData>> getTomorrowSchedule() async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        return ApiResponse.error("Autentikasi gagal: Token tidak ditemukan.", statusCode: HttpStatus.unauthorized);
      }
      final String apiPath = "/jadwal/tomorrow";
      final Uri requestUri = Uri.parse('${BaseApiService.baseUrl}$apiPath');

      print('(Jadwal Besok) Requesting from: $requestUri');

      final response = await http.get(
        requestUri,
        headers: getHeaders(requiresAuth: true, token: token),
      ).timeout(const Duration(seconds: 20));
      if (response.statusCode == HttpStatus.ok) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final jadwalBesokListData = JadwalBesokListData.fromJson(responseData);

        return ApiResponse.success(
          jadwalBesokListData,
          message: jadwalBesokListData.data.isNotEmpty
              ? "Jadwal besok berhasil diambil."
              : "Tidak ada jadwal untuk besok."
        );
      } else {
        String errorMessage = "Gagal mengambil data jadwal besok (HTTP ${response.statusCode}).";
        // ... (logika parsing error message dari body seperti sebelumnya) ...
        try {
          final Map<String, dynamic> errorBody = jsonDecode(response.body);
          if (errorBody.containsKey('message') && errorBody['message'] is String) {
            errorMessage = errorBody['message'];
          }
        } catch (e) { /* Gagal parse body error */ }
        return ApiResponse.error(errorMessage, statusCode: response.statusCode);
      }
    } on SocketException {
      return ApiResponse.error("Kesalahan jaringan.", statusCode: HttpStatus.serviceUnavailable);
    } on HttpException catch (e) {
      return ApiResponse.error("Kesalahan koneksi HTTP: ${e.message}");
    } on FormatException {
      return ApiResponse.error("Kesalahan format data dari server.");
    } on TimeoutException {
      return ApiResponse.error("Waktu tunggu koneksi habis.");
    } catch (e) {
      print('Error tidak terduga di getTomorrowSchedule: $e');
      return ApiResponse.error("Terjadi kesalahan yang tidak terduga: ${e.toString()}");
    }
  }
}
