// file: lib/services/frs_service.dart (sesuaikan path jika perlu)
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:timelyu/data/models/frs_model.dart';
import 'package:timelyu/data/models/jadwal_matkul.model.dart';
import 'package:timelyu/data/client/api_client.dart';

class FrsService extends BaseApiService {
  // _parseTahunAjar tetap di sini karena spesifik untuk FRS
  Map<String, int> _parseTahunAjar(String tahunAjar) {
    try {
      List<String> parts = tahunAjar.split('/');
      if (parts.length == 2) {
        return {
          'tahun_ajar': int.parse(parts[0]),
          'tahun_berakhir': int.parse(parts[1]),
        };
      }
    } catch (e) {
      print(
        "FrsService (_parseTahunAjar): Error parsing tahun ajar '$tahunAjar': $e",
      );
    }
    int currentYear = DateTime.now().year;
    print(
      "FrsService (_parseTahunAjar): Fallback, using $currentYear/${currentYear + 1}",
    );
    return {'tahun_ajar': currentYear, 'tahun_berakhir': currentYear + 1};
  }

  /// Mengambil data FRS berdasarkan tahun ajar dan semester
  Future<ApiResponse<List<FrsModel>>> getFrsData({
    required String tahunAjar,
    required String semester,
  }) async {
    try {
      final token = await getToken(); // Diwarisi
      if (token == null)
        return ApiResponse.error(
          'Token tidak ditemukan.',
          statusCode: HttpStatus.unauthorized,
        );

      final tahunData = _parseTahunAjar(tahunAjar);
      final queryParameters = <String, String>{
        'tahun_ajar': tahunData['tahun_ajar'].toString(),
        'semester': semester.toLowerCase(),
      };

      final uri = Uri.parse(
        '${BaseApiService.baseUrl}/frs',
      ).replace(queryParameters: queryParameters);
      print("FrsService (getFrsData): Calling URL - $uri");
      // Gunakan getHeaders() yang diwarisi
      final response = await http.get(
        uri,
        headers: getHeaders(requiresAuth: true, token: token),
      );
      print(
        "FrsService (getFrsData): Response Status - ${response.statusCode}",
      );

      if (response.statusCode == HttpStatus.ok) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['data'] != null && body['data'] is List) {
          final List<FrsModel> frsList =
              (body['data'] as List)
                  .map(
                    (item) => FrsModel.fromJson(item as Map<String, dynamic>),
                  )
                  .toList();
          return ApiResponse.success(frsList, statusCode: response.statusCode);
        }
        return ApiResponse.error(
          'Format data FRS tidak valid dari API.',
          statusCode: response.statusCode,
        );
      } else if (response.statusCode == HttpStatus.unauthorized) {
        return ApiResponse.error(
          'Sesi berakhir atau token tidak valid.',
          statusCode: response.statusCode,
        );
      } else {
        String msg = 'Gagal mengambil data FRS.';
        try {
          msg = jsonDecode(response.body)['message'] ?? msg;
        } catch (_) {}
        return ApiResponse.error(msg, statusCode: response.statusCode);
      }
    } on SocketException {
      print(
        "FrsService (getFrsData): SocketException - Tidak ada koneksi internet.",
      );
      return ApiResponse.error('Tidak ada koneksi internet.');
    } catch (e) {
      print("FrsService (getFrsData): Generic error - $e");
      return ApiResponse.error('Terjadi kesalahan: ${e.toString()}');
    }
  }

  /// Mengambil jadwal pilihan yang tersedia untuk FRS
  Future<ApiResponse<List<JadwalMatakuliahModel>>> getJadwalPilihan({
    String? tahunAjar,
    String? semester,
  }) async {
    try {
      final token = await getToken(); // Diwarisi
      if (token == null)
        return ApiResponse.error(
          'Token tidak ditemukan.',
          statusCode: HttpStatus.unauthorized,
        );

      final queryParameters = <String, String>{};
      if (tahunAjar != null &&
          semester != null &&
          tahunAjar.isNotEmpty &&
          semester.isNotEmpty) {
        final tahunData = _parseTahunAjar(tahunAjar);
        queryParameters['semester'] = semester.toLowerCase();
        queryParameters['tahun_mulai'] = tahunData['tahun_ajar'].toString();
        queryParameters['tahun_akhir'] = tahunData['tahun_berakhir'].toString();
      } else {
        print(
          "FrsService (getJadwalPilihan): Tahun ajar atau semester tidak disediakan sepenuhnya.",
        );
      }

      // Gunakan BaseApiService.baseUrl
      final uri = Uri.parse(
        '${BaseApiService.baseUrl}/jadwal/available-for-frs',
      ).replace(queryParameters: queryParameters);
      print("FrsService (getJadwalPilihan): Calling URL - $uri");
      // Gunakan getHeaders() yang diwarisi
      final response = await http.get(
        uri,
        headers: getHeaders(requiresAuth: true, token: token),
      );
      print(
        "FrsService (getJadwalPilihan): Response Status - ${response.statusCode}",
      );

      if (response.statusCode == HttpStatus.ok) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['data'] != null && body['data'] is List) {
          final List<JadwalMatakuliahModel> jadwalList =
              (body['data'] as List)
                  .map(
                    (item) => JadwalMatakuliahModel.fromJson(
                      item as Map<String, dynamic>,
                    ),
                  )
                  .toList();
          return ApiResponse.success(
            jadwalList,
            statusCode: response.statusCode,
          );
        }
        return ApiResponse.error(
          'Format data jadwal tidak valid dari API.',
          statusCode: response.statusCode,
        );
      } else if (response.statusCode == HttpStatus.unauthorized) {
        return ApiResponse.error(
          'Sesi berakhir atau token tidak valid.',
          statusCode: response.statusCode,
        );
      } else {
        String msg = 'Gagal mengambil data jadwal pilihan.';
        try {
          msg = jsonDecode(response.body)['message'] ?? msg;
        } catch (_) {}
        return ApiResponse.error(msg, statusCode: response.statusCode);
      }
    } on SocketException {
      print(
        "FrsService (getJadwalPilihan): SocketException - Tidak ada koneksi internet.",
      );
      return ApiResponse.error('Tidak ada koneksi internet.');
    } catch (e) {
      print("FrsService (getJadwalPilihan): Generic error - $e");
      return ApiResponse.error('Terjadi kesalahan: ${e.toString()}');
    }
  }

  /// Menyimpan FRS berdasarkan jadwal yang dipilih
  Future<ApiResponse<List<FrsModel>>> storeFrs({
    required List<String> idJadwalDipilih,
    required String tahunAjar,
    required String semester,
  }) async {
    try {
      final token = await getToken(); // Diwarisi
      if (token == null)
        return ApiResponse.error(
          'Token tidak ditemukan.',
          statusCode: HttpStatus.unauthorized,
        );

      final tahunData = _parseTahunAjar(tahunAjar);
      final Map<String, dynamic> requestBody = {
        'jadwal_ids': idJadwalDipilih,
        'tahun_ajar': tahunData['tahun_ajar'],
        'semester': semester.toLowerCase(),
      };

      final uri = Uri.parse('${BaseApiService.baseUrl}/frs/store');
      print("FrsService (storeFrs): Calling URL - $uri");
      print("FrsService (storeFrs): Request Body - ${jsonEncode(requestBody)}");
      // Gunakan getHeaders() yang diwarisi
      final response = await http.post(
        uri,
        headers: getHeaders(requiresAuth: true, token: token),
        body: jsonEncode(requestBody),
      );
      print("FrsService (storeFrs): Response Status - ${response.statusCode}");

      if (response.statusCode == HttpStatus.created ||
          response.statusCode == HttpStatus.ok) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final String? message = body['message'] as String?;

        if (body['data'] != null && body['data'] is List) {
          final List<FrsModel> createdFrsList =
              (body['data'] as List)
                  .map(
                    (item) => FrsModel.fromJson(item as Map<String, dynamic>),
                  )
                  .toList();
          return ApiResponse.success(
            createdFrsList,
            message: message ?? "FRS berhasil disimpan.",
            statusCode: response.statusCode,
          );
        } else if (body['data'] != null &&
            body['data'] is Map<String, dynamic>) {
          final FrsModel createdFrs = FrsModel.fromJson(
            body['data'] as Map<String, dynamic>,
          );
          return ApiResponse.success(
            [createdFrs],
            message: message ?? "FRS berhasil disimpan.",
            statusCode: response.statusCode,
          );
        }
        return ApiResponse.success(
          <FrsModel>[],
          message: message ?? 'FRS berhasil disimpan.',
          statusCode: response.statusCode,
        );
      } else if (response.statusCode == HttpStatus.unauthorized) {
        return ApiResponse.error(
          'Sesi berakhir atau token tidak valid.',
          statusCode: response.statusCode,
        );
      } else if (response.statusCode == HttpStatus.unprocessableEntity) {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        return ApiResponse.error(
          errorBody['message'] as String? ?? 'Data yang dikirim tidak valid.',
          statusCode: response.statusCode,
          validationErrors: errorBody['errors'] as Map<String, dynamic>?,
        );
      } else {
        String msg = 'Gagal menyimpan FRS.';
        try {
          msg = jsonDecode(response.body)['message'] ?? msg;
        } catch (_) {}
        return ApiResponse.error(msg, statusCode: response.statusCode);
      }
    } on SocketException {
      print(
        "FrsService (storeFrs): SocketException - Tidak ada koneksi internet.",
      );
      return ApiResponse.error('Tidak ada koneksi internet.');
    } catch (e) {
      print("FrsService (storeFrs): Generic error - $e");
      return ApiResponse.error('Terjadi kesalahan: ${e.toString()}');
    }
  }
}
