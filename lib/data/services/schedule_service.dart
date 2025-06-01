import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:timelyu/data/models/jadwal_besok_model.dart';
import 'package:timelyu/data/models/schedule.dart';
import 'package:timelyu/data/client/api_client.dart';
import 'package:timelyu/data/models/schedule_today.dart';

class ScheduleService extends BaseApiService {
  // Fungsi untuk mendapatkan data FRS dengan better null handling
  Future<ApiResponse<MyFrsResponseModel>> getMyFrs() async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        return ApiResponse.error(
          "Autentikasi gagal: Token tidak ditemukan.",
          statusCode: HttpStatus.unauthorized,
        );
      }

      final response = await http
          .get(
            Uri.parse('${BaseApiService.baseUrl}/frs/my-frs'),
            headers: getHeaders(requiresAuth: true, token: token),
          )
          .timeout(const Duration(seconds: 20));

      print('=== FRS API Response Debug ===');
      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body length: ${response.body.length}');
      print('Response body: ${response.body}');
      print('===============================');

      if (response.body.isEmpty) {
        return ApiResponse.error(
          "Server mengembalikan response kosong.",
          statusCode: response.statusCode,
        );
      }

      final Map<String, dynamic> responseData;
      try {
        responseData = jsonDecode(response.body);
        print('Parsed JSON successfully');
      } catch (e) {
        print('JSON Parse Error: $e');
        return ApiResponse.error(
          "Response dari server tidak valid (bukan JSON): $e",
          statusCode: response.statusCode,
        );
      }

      print('Response data keys: ${responseData.keys.toList()}');
      print('Response data: $responseData');

      if (response.statusCode == HttpStatus.ok) {
        try {
          // Validasi struktur response terlebih dahulu
          _validateResponseStructure(responseData);

          final myFrsData = MyFrsResponseModel.fromJson(responseData);
          print('MyFrsResponseModel created successfully');
          print('Success: ${myFrsData.success}');
          print('Data null check: ${myFrsData.data == null}');

          if (myFrsData.success) {
            if (myFrsData.data != null) {
              print(
                'Data details count: ${myFrsData.data?.details.length ?? 0}',
              );
              return ApiResponse.success(
                myFrsData,
                message:
                    _safeGetString(responseData, 'message') ??
                    "Data FRS berhasil diambil.",
              );
            } else {
              return ApiResponse.error(
                _safeGetString(responseData, 'message') ??
                    "Data FRS tidak ditemukan meskipun respons sukses.",
                statusCode: response.statusCode,
              );
            }
          } else {
            return ApiResponse.error(
              _safeGetString(responseData, 'message') ??
                  "Gagal mengambil data FRS dari server.",
              statusCode: response.statusCode,
              validationErrors: _safeGetMap(responseData, 'errors'),
            );
          }
        } catch (e) {
          print('Error creating MyFrsResponseModel: $e');
          print('Error type: ${e.runtimeType}');
          return ApiResponse.error(
            "Error parsing response data: ${e.toString()}",
            statusCode: response.statusCode,
          );
        }
      } else {
        String errorMessage = "Gagal mengambil data FRS.";
        Map<String, dynamic>? validationErrors;

        if (responseData.containsKey('message') &&
            responseData['message'] != null) {
          errorMessage = responseData['message'].toString();
        }
        if (responseData.containsKey('errors') &&
            responseData['errors'] is Map<String, dynamic>) {
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
    } on HttpException catch (e) {
      print('HttpException di getMyFrs: ${e.message}');
      return ApiResponse.error("Kesalahan koneksi HTTP: ${e.message}");
    } on FormatException catch (e) {
      print('FormatException di getMyFrs: $e');
      return ApiResponse.error(
        "Kesalahan format data: Respons dari server tidak valid.",
      );
    } on TimeoutException {
      return ApiResponse.error(
        "Kesalahan: Waktu tunggu koneksi ke server habis.",
      );
    } catch (e, stackTrace) {
      print('Error tidak terduga di getMyFrs: $e');
      print('Error type: ${e.runtimeType}');
      print('Stack trace: $stackTrace');
      return ApiResponse.error(
        "Terjadi kesalahan yang tidak terduga: ${e.toString()}",
      );
    }
  }

  // Helper method untuk safely get string from map
  String? _safeGetString(Map<String, dynamic> map, String key) {
    final value = map[key];
    return value?.toString();
  }

  // Helper method untuk safely get map from map
  Map<String, dynamic>? _safeGetMap(Map<String, dynamic> map, String key) {
    final value = map[key];
    if (value is Map<String, dynamic>) {
      return value;
    }
    return null;
  }

  // Helper method untuk validate response structure
  void _validateResponseStructure(Map<String, dynamic> responseData) {
    print('Validating response structure...');

    // Check basic structure
    if (!responseData.containsKey('success')) {
      throw FormatException('Response missing "success" field');
    }

    print('Success field exists: ${responseData['success']}');

    if (responseData['success'] == true) {
      if (!responseData.containsKey('data')) {
        print('Warning: Success response without data field');
      } else {
        final data = responseData['data'];
        print('Data field type: ${data.runtimeType}');

        if (data != null && data is Map<String, dynamic>) {
          print('Data keys: ${data.keys.toList()}');

          if (data.containsKey('details')) {
            final details = data['details'];
            print('Details type: ${details.runtimeType}');
            if (details is List) {
              print('Details count: ${details.length}');

              // Check first detail structure if exists
              if (details.isNotEmpty) {
                final firstDetail = details[0];
                print('First detail type: ${firstDetail.runtimeType}');
                if (firstDetail is Map<String, dynamic>) {
                  print('First detail keys: ${firstDetail.keys.toList()}');
                }
              }
            }
          }
        }
      }
    }

    print('Response structure validation completed');
  }

  // Rest of the methods remain the same...
  Future<ApiResponse<ScheduleListData>> getJadwalHariIni() async {
    // ... existing implementation
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        return ApiResponse.error(
          "Autentikasi gagal: Token tidak ditemukan.",
          statusCode: HttpStatus.unauthorized,
        );
      }

      final String apiPath = "/jadwal/today";
      final Uri requestUri = Uri.parse('${BaseApiService.baseUrl}$apiPath');

      print('Requesting Schedule Today from: $requestUri');

      final response = await http
          .get(
            requestUri,
            headers: getHeaders(requiresAuth: true, token: token),
          )
          .timeout(const Duration(seconds: 20));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == HttpStatus.ok) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final scheduleListData = ScheduleListData.fromJson(responseData);

        return ApiResponse.success(
          scheduleListData,
          message:
              scheduleListData.data.isNotEmpty
                  ? "Jadwal hari ini berhasil diambil."
                  : "Tidak ada jadwal untuk hari ini.",
        );
      } else {
        String errorMessage =
            "Gagal mengambil data jadwal (HTTP ${response.statusCode}).";
        Map<String, dynamic>? validationErrors;

        try {
          final Map<String, dynamic> errorBody = jsonDecode(response.body);
          if (errorBody.containsKey('message') &&
              errorBody['message'] != null) {
            errorMessage = errorBody['message'].toString();
          }
          if (errorBody.containsKey('errors') &&
              errorBody['errors'] is Map<String, dynamic>) {
            validationErrors = errorBody['errors'] as Map<String, dynamic>;
          }
        } catch (e) {
          print("Gagal parse body error di getJadwalHariIni: $e");
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
    } on FormatException catch (e) {
      print('FormatException di getJadwalHariIni: $e');
      return ApiResponse.error(
        "Kesalahan format data: Respons dari server tidak valid.",
      );
    } on TimeoutException {
      return ApiResponse.error(
        "Kesalahan: Waktu tunggu koneksi ke server habis.",
      );
    } catch (e) {
      print('Error tidak terduga di getJadwalHariIni: $e');
      print('Error type: ${e.runtimeType}');
      return ApiResponse.error(
        "Terjadi kesalahan yang tidak terduga: ${e.toString()}",
      );
    }
  }

  Future<ApiResponse<JadwalBesokListData>> getTomorrowSchedule() async {
    // ... existing implementation remains the same
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        return ApiResponse.error(
          "Autentikasi gagal: Token tidak ditemukan.",
          statusCode: HttpStatus.unauthorized,
        );
      }

      final String apiPath = "/jadwal/tomorrow";
      final Uri requestUri = Uri.parse('${BaseApiService.baseUrl}$apiPath');

      print('(Jadwal Besok) Requesting from: $requestUri');

      final response = await http
          .get(
            requestUri,
            headers: getHeaders(requiresAuth: true, token: token),
          )
          .timeout(const Duration(seconds: 20));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == HttpStatus.ok) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final jadwalBesokListData = JadwalBesokListData.fromJson(responseData);

        return ApiResponse.success(
          jadwalBesokListData,
          message:
              jadwalBesokListData.data.isNotEmpty
                  ? "Jadwal besok berhasil diambil."
                  : "Tidak ada jadwal untuk besok.",
        );
      } else {
        String errorMessage =
            "Gagal mengambil data jadwal besok (HTTP ${response.statusCode}).";
        Map<String, dynamic>? validationErrors;

        try {
          final Map<String, dynamic> errorBody = jsonDecode(response.body);
          if (errorBody.containsKey('message') &&
              errorBody['message'] != null) {
            errorMessage = errorBody['message'].toString();
          }
          if (errorBody.containsKey('errors') &&
              errorBody['errors'] is Map<String, dynamic>) {
            validationErrors = errorBody['errors'] as Map<String, dynamic>;
          }
        } catch (e) {
          print("Gagal parse body error di getTomorrowSchedule: $e");
        }

        return ApiResponse.error(
          errorMessage,
          statusCode: response.statusCode,
          validationErrors: validationErrors,
        );
      }
    } on SocketException {
      return ApiResponse.error(
        "Kesalahan jaringan.",
        statusCode: HttpStatus.serviceUnavailable,
      );
    } on HttpException catch (e) {
      print('HttpException di getTomorrowSchedule: ${e.message}');
      return ApiResponse.error("Kesalahan koneksi HTTP: ${e.message}");
    } on FormatException catch (e) {
      print('FormatException di getTomorrowSchedule: $e');
      return ApiResponse.error("Kesalahan format data dari server.");
    } on TimeoutException {
      return ApiResponse.error("Waktu tunggu koneksi habis.");
    } catch (e) {
      print('Error tidak terduga di getTomorrowSchedule: $e');
      print('Error type: ${e.runtimeType}');
      return ApiResponse.error(
        "Terjadi kesalahan yang tidak terduga: ${e.toString()}",
      );
    }
  }
}
