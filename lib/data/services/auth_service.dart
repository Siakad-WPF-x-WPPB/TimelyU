// file: lib/services/api_service.dart (sesuaikan path jika perlu)

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timelyu/data/models/user_model.dart';
import 'package:timelyu/data/client/api_client.dart';

class ApiService extends BaseApiService {

  static const String _userKey = 'user_data';

  // Endpoint constants
  static const String _loginEndpoint = '/login';
  static const String _profileEndpoint = '/profile';
  static const String _dataEndpoint = '/data';
  static const String _logoutEndpoint = '/logout';


  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(BaseApiService.tokenKey, token);
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(userData));
  }

  Future<UserModel?> getCachedUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);
    if (userString != null) {
      try {
        return UserModel.fromJson(jsonDecode(userString));
      } catch (e) {
        print('Error parsing cached user data: $e');
        return null;
      }
    }
    return null;
  }

  Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(BaseApiService.tokenKey); // Gunakan konstanta dari BaseApiService
    await prefs.remove(_userKey);
  }

  Future<bool> isLoggedIn() async {
    return await getToken() != null;
  }

  // _handleApiRequest tetap di sini karena cukup kompleks
  Future<ApiResponse<T>> _handleApiRequest<T>({
    required Future<http.Response> Function() requestFunction,
    required T Function(Map<String, dynamic> data) onSuccess,
    Map<String, dynamic> Function(Map<String, dynamic> responseBody)? customDataExtractor,
  }) async {
    try {
      final response = await requestFunction();
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
        final dynamic dataToProcess = customDataExtractor != null
            ? customDataExtractor(responseBody)
            : responseBody['data'] ?? responseBody['user'] ?? responseBody;

        if (dataToProcess == null) {
            return ApiResponse.error(
                'Data tidak ditemukan dalam respons server.',
                statusCode: response.statusCode);
        }
        if (dataToProcess is! Map<String, dynamic> && response.request?.method == 'POST' && response.request!.url.path.contains(BaseApiService.baseUrl + _logoutEndpoint)) {
            if (T == bool && (dataToProcess == true || (responseBody['message'] != null && response.statusCode == HttpStatus.ok))) { // Logout bisa mengembalikan message sukses
                return ApiResponse.success(true as T, statusCode: response.statusCode);
            }
        }
        if (dataToProcess is! Map<String, dynamic>) {
          return ApiResponse.error(
              'Format data dari server tidak sesuai (bukan Map).',
              statusCode: response.statusCode);
        }

        try {
          return ApiResponse.success(onSuccess(dataToProcess), statusCode: response.statusCode);
        } catch (e) {
          return ApiResponse.error(
              'Gagal memproses data dari server: ${e.toString()}',
              statusCode: response.statusCode);
        }
      } else if (response.statusCode == HttpStatus.unauthorized) {
        await clearAuthData();
        return ApiResponse.error(
            responseBody['message']?.toString() ?? 'Sesi berakhir, silakan login kembali.',
            statusCode: response.statusCode);
      } else {
        return ApiResponse.error(
            responseBody['message']?.toString() ?? 'Terjadi kesalahan. Status: ${response.statusCode}',
            statusCode: response.statusCode);
      }
    } on SocketException {
      return ApiResponse.error('Tidak ada koneksi internet atau server tidak terjangkau.');
    } on FormatException {
      return ApiResponse.error('Gagal memproses respons dari server (format tidak valid).');
    } catch (e) {
      return ApiResponse.error('Terjadi kesalahan: ${e.toString()}');
    }
  }

  // --- Function untuk login ---
  Future<ApiResponse<UserModel>> login(String email, String password) async {
    return _handleApiRequest<UserModel>(
      requestFunction: () => http.post(
        // Gunakan BaseApiService.baseUrl
        Uri.parse('${BaseApiService.baseUrl}$_loginEndpoint'),
        headers: getHeaders(), // Diwarisi
        body: jsonEncode({'email': email, 'password': password}),
      ),
      onSuccess: (data) {
        final token = (data['token'] ?? (jsonDecode(data['original'] ?? '{}')['token']))?.toString();
        if (token == null || token.isEmpty) {
          throw Exception('Token tidak ditemukan dari server');
        }
        _saveToken(token);

        final userData = data['user'] as Map<String, dynamic>? ?? (jsonDecode(data['original'] ?? '{}')['user']) as Map<String, dynamic>?;
        if (userData == null) {
          throw Exception('Data pengguna tidak ditemukan dari server');
        }
        _saveUserData(userData);
        return UserModel.fromJson(userData);
      },
      customDataExtractor: (responseBody) => responseBody,
    );
  }

// --- Function untuk mendapatkan profil pengguna ---
  Future<ApiResponse<UserModel>> getProfile() async {
    final token = await getToken(); // Diwarisi
    if (token == null) {
      return ApiResponse.error('Token tidak ditemukan. Silakan login kembali.',
          statusCode: HttpStatus.unauthorized);
    }

    return _handleApiRequest<UserModel>(
      requestFunction: () => http.get(
        Uri.parse('${BaseApiService.baseUrl}$_profileEndpoint'), // Gunakan BaseApiService.baseUrl
        headers: getHeaders(requiresAuth: true, token: token), // Diwarisi
      ),
      onSuccess: (data) {
        Map<String, dynamic> userDataToParse;
        if (data.containsKey('user') && data['user'] is Map<String, dynamic>) {
          userDataToParse = data['user'];
        } else {
          userDataToParse = data;
        }
        _saveUserData(userDataToParse);
        return UserModel.fromJson(userDataToParse);
      },
      customDataExtractor: (responseBody) => responseBody,
    );
  }

  // --- Function untuk mendapatkan data mahasiswa ---
  Future<ApiResponse<Map<String, dynamic>>> getMahasiswaData() async {
    final token = await getToken(); // Diwarisi
    if (token == null) {
      return ApiResponse.error('Token tidak ditemukan.',
          statusCode: HttpStatus.unauthorized);
    }
    return _handleApiRequest<Map<String, dynamic>>(
      requestFunction: () => http.get(
        Uri.parse('${BaseApiService.baseUrl}$_dataEndpoint'), // Gunakan BaseApiService.baseUrl
        headers: getHeaders(requiresAuth: true, token: token), // Diwarisi
      ),
      onSuccess: (data) => data,
    );
  }

  // --- Function untuk logout ---
  Future<ApiResponse<bool>> logout() async {
    final token = await getToken(); // Diwarisi
    await clearAuthData();

    if (token == null) {
      return ApiResponse.success(true, statusCode: HttpStatus.ok);
    }
    try {
      final response = await http.post(
        Uri.parse('${BaseApiService.baseUrl}$_logoutEndpoint'), // Gunakan BaseApiService.baseUrl
        headers: getHeaders(requiresAuth: true, token: token), // Diwarisi
      );

      if (response.statusCode == HttpStatus.ok) {
        return ApiResponse.success(true, statusCode: response.statusCode);
      } else {
        print("API logout failed with status ${response.statusCode}: ${response.body}");
        return ApiResponse.success(true, statusCode: response.statusCode);
      }
    } on SocketException {
      print("API logout failed: No internet or server unreachable. Local data cleared.");
      return ApiResponse.success(true);
    } on FormatException {
        print("API logout failed: Bad response format. Local data cleared.");
        return ApiResponse.success(true);
    } catch (e) {
      print("Error during API logout call: $e. Local data cleared.");
      return ApiResponse.error(
        'Terjadi kesalahan saat logout di server, namun data lokal sudah dihapus.',
      );
    }
  }
}