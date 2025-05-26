import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timelyu/data/models/user_model.dart';

// Kelas untuk menangani respon API secara generik
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final int?
  statusCode;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.statusCode,
  });

  factory ApiResponse.success(T data, {int? statusCode = HttpStatus.ok}) =>
      ApiResponse(success: true, data: data, statusCode: statusCode);

  factory ApiResponse.error(String message, {int? statusCode}) =>
      ApiResponse(success: false, message: message, statusCode: statusCode);
}

class ApiService {
  // PASTIKAN BASE URL INI SUDAH BENAR DAN DAPAT DIAKSES
  static const String _baseUrl = "http://192.168.68.200:8000/api/mahasiswa";
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // Token management methods
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
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
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  // Headers helper
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

  // API calls untuk login
  Future<ApiResponse<UserModel>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: _getHeaders(),
        body: jsonEncode({'email': email, 'password': password}),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == HttpStatus.ok) {
        // 200
        final token = data['token']?.toString();
        if (token == null || token.isEmpty) {
          return ApiResponse.error(
            'Token tidak ditemukan dari server',
            statusCode: response.statusCode,
          );
        }
        await _saveToken(token);

        if (data['user'] != null && data['user'] is Map<String, dynamic>) {
          try {
            final userModel = UserModel.fromJson(data['user']);
            await _saveUserData(data['user']);
            return ApiResponse.success(
              userModel,
              statusCode: response.statusCode,
            );
          } catch (e) {
            return ApiResponse.error(
              'Format data pengguna tidak valid: ${e.toString()}',
              statusCode: response.statusCode,
            );
          }
        } else {
          return ApiResponse.error(
            'Data pengguna tidak ditemukan dari server',
            statusCode: response.statusCode,
          );
        }
      } else {
        final message =
            data['message']?.toString() ??
            'Login gagal. Status: ${response.statusCode}';
        return ApiResponse.error(message, statusCode: response.statusCode);
      }
    } on SocketException {
      return ApiResponse.error(
        'Tidak ada koneksi internet atau server tidak terjangkau.',
      );
    } on FormatException {
      return ApiResponse.error('Gagal memproses respons dari server.');
    } catch (e) {
      return ApiResponse.error('Terjadi kesalahan saat login: ${e.toString()}');
    }
  }

  // API calls untuk mengambil profil
  Future<ApiResponse<UserModel>> getProfile() async {
    try {
      final token = await getToken();
      if (token == null) {
        return ApiResponse.error(
          'Token tidak ditemukan. Silakan login kembali.',
          statusCode: HttpStatus.unauthorized,
        );
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/profile'), // Endpoint untuk mengambil profil
        headers: _getHeaders(requiresAuth: true, token: token),
      );
      if (response.statusCode == HttpStatus.ok) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        Map<String, dynamic>? userData;

        if (responseData['user'] is Map<String, dynamic>) {
          userData = responseData['user'];
        } else if (responseData is Map<String, dynamic> &&
            responseData.isNotEmpty) {
          userData = responseData;
        }

        if (userData == null || userData.isEmpty) {
          return ApiResponse.error(
            'Data pengguna kosong atau format tidak sesuai dari server.',
            statusCode: response.statusCode,
          );
        }
        try {
          final userModel = UserModel.fromJson(userData);
          await _saveUserData(userData);
          return ApiResponse.success(
            userModel,
            statusCode: response.statusCode,
          );
        } catch (e) {
          return ApiResponse.error(
            'Gagal memproses data profil: ${e.toString()}',
            statusCode: response.statusCode,
          );
        }
      } else if (response.statusCode == HttpStatus.unauthorized) {
        // 401
        await clearAuthData();
        return ApiResponse.error(
          'Sesi berakhir, silakan login kembali',
          statusCode: response.statusCode,
        );
      } else {
        String errorMessage = 'Gagal mengambil profil.';
        try {
          final Map<String, dynamic> errorData = jsonDecode(response.body);
          errorMessage =
              errorData['message'] as String? ??
              'Gagal mengambil profil. Status: ${response.statusCode}';
        } catch (_) {
          errorMessage =
              'Gagal mengambil profil (respons tidak valid). Status: ${response.statusCode}';
        }
        return ApiResponse.error(errorMessage, statusCode: response.statusCode);
      }
    } on SocketException {
      return ApiResponse.error(
        'Tidak ada koneksi internet atau server tidak terjangkau.',
      );
    } on FormatException {
      return ApiResponse.error('Gagal memproses respons dari server.');
    } catch (e) {
      return ApiResponse.error(
        'Terjadi kesalahan saat mengambil profil: ${e.toString()}',
      );
    }
  }

  // API calls untuk mengambil data mahasiswa
  Future<ApiResponse<Map<String, dynamic>>> getMahasiswaData() async {
    try {
      final token = await getToken();
      if (token == null) {
        return ApiResponse.error(
          'Token tidak ditemukan',
          statusCode: HttpStatus.unauthorized,
        );
      }

      final response = await http.get(
        Uri.parse(
          '$_baseUrl/data',
        ),
        headers: _getHeaders(requiresAuth: true, token: token),
      );

      if (response.statusCode == HttpStatus.ok) {
        // 200
        try {
          final data = jsonDecode(response.body);
          if (data is Map<String, dynamic>) {
            return ApiResponse.success(data, statusCode: response.statusCode);
          } else {
            return ApiResponse.error(
              'Format data tidak valid dari server',
              statusCode: response.statusCode,
            );
          }
        } catch (e) {
          return ApiResponse.error(
            'Gagal memproses data: ${e.toString()}',
            statusCode: response.statusCode,
          );
        }
      } else if (response.statusCode == HttpStatus.unauthorized) {
        // 401
        await clearAuthData();
        return ApiResponse.error(
          'Sesi berakhir, silakan login kembali',
          statusCode: response.statusCode,
        );
      } else {
        String errorMessage = 'Gagal mengambil data mahasiswa.';
        try {
          final Map<String, dynamic> errorData = jsonDecode(response.body);
          errorMessage =
              errorData['message'] as String? ??
              'Gagal mengambil data mahasiswa. Status: ${response.statusCode}';
        } catch (_) {
          errorMessage =
              'Gagal mengambil data mahasiswa (respons tidak valid). Status: ${response.statusCode}';
        }
        return ApiResponse.error(errorMessage, statusCode: response.statusCode);
      }
    } on SocketException {
      return ApiResponse.error(
        'Tidak ada koneksi internet atau server tidak terjangkau.',
      );
    } on FormatException {
      return ApiResponse.error('Gagal memproses respons dari server.');
    } catch (e) {
      return ApiResponse.error(
        'Terjadi kesalahan saat mengambil data mahasiswa: ${e.toString()}',
      );
    }
  }

  // API calls untuk logout
  Future<ApiResponse<bool>> logout() async {
    final token = await getToken();
    await clearAuthData();

    if (token == null) {
      return ApiResponse.success(
        true,
        statusCode: HttpStatus.ok,
      );
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/logout'),
        headers: _getHeaders(requiresAuth: true, token: token),
      );

      if (response.statusCode == HttpStatus.ok) {
        // 200
        return ApiResponse.success(true, statusCode: response.statusCode);
      } else {
        print(
          "API logout failed with status ${response.statusCode}: ${response.body}",
        );
        return ApiResponse.success(
          true,
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      print("API logout failed: No internet or server unreachable.");
      return ApiResponse.success(
        true,
      );
    } on FormatException {
      print("API logout failed: Bad response format.");
      return ApiResponse.success(true);
    } catch (e) {
      print("Error during API logout call: $e");
      return ApiResponse.error(
        'Terjadi kesalahan saat logout di server, namun data lokal sudah dihapus: ${e.toString()}',
      );
    }
  }

  Future<bool> isLoggedIn() async {
    return await getToken() != null;
  }
}
