import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Kelas untuk menangani respon API secara generik
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;

  ApiResponse({required this.success, this.message, this.data});

  factory ApiResponse.success(T data) => 
      ApiResponse(success: true, data: data);
  
  factory ApiResponse.error(String message) => 
      ApiResponse(success: false, message: message);
}

// Model untuk data user
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? role;
  // Tambahkan properti lain sesuai kebutuhan

  UserModel({
    required this.id, 
    required this.name, 
    required this.email, 
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '', // Menambahkan null safety
      name: json['name']?.toString() ?? '', // Menambahkan null safety
      email: json['email']?.toString() ?? '', // Menambahkan null safety
      role: json['role']?.toString(), // Sudah nullable
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
    };
  }
}

class ApiService {
  static const String _baseUrl = "http://192.168.100.54:8000/api/mahasiswa";
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

    if (requiresAuth && token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // API calls
  Future<ApiResponse<UserModel>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: _getHeaders(),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        // Periksa apakah token ada dan bukan null
        final token = data['token']?.toString();
        if (token == null || token.isEmpty) {
          return ApiResponse.error('Token tidak ditemukan dari server');
        }
        
        // Simpan token
        await _saveToken(token);
        
        // Periksa apakah data user ada
        if (data['user'] != null && data['user'] is Map<String, dynamic>) {
          try {
            final userModel = UserModel.fromJson(data['user']);
            await _saveUserData(data['user']);
            return ApiResponse.success(userModel);
          } catch (e) {
            return ApiResponse.error('Format data pengguna tidak valid: ${e.toString()}');
          }
        } else {
          return ApiResponse.error('Data pengguna tidak ditemukan');
        }
      } else {
        final message = data['message']?.toString() ?? 'Login gagal';
        return ApiResponse.error(message);
      }
    } catch (e) {
      return ApiResponse.error('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<ApiResponse<UserModel>> getProfile() async {
    try {
      final token = await getToken();
      if (token == null) {
        return ApiResponse.error('Token tidak ditemukan');
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/profile'),
        headers: _getHeaders(requiresAuth: true, token: token),
      );

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> data = jsonDecode(response.body);
          final userData = data['user'] is Map<String, dynamic> 
              ? data['user'] 
              : (data is Map<String, dynamic> ? data : {});
          
          if (userData.isEmpty) {
            return ApiResponse.error('Data pengguna kosong');
          }
          
          final userModel = UserModel.fromJson(userData);
          await _saveUserData(userData);
          return ApiResponse.success(userModel);
        } catch (e) {
          return ApiResponse.error('Gagal memproses data profil: ${e.toString()}');
        }
      } else if (response.statusCode == 401) {
        await clearAuthData();
        return ApiResponse.error('Sesi berakhir, silakan login kembali');
      } else {
        return ApiResponse.error('Gagal mengambil profil: ${response.body}');
      }
    } catch (e) {
      return ApiResponse.error('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> getMahasiswaData() async {
    try {
      final token = await getToken();
      if (token == null) {
        return ApiResponse.error('Token tidak ditemukan');
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/data'),
        headers: _getHeaders(requiresAuth: true, token: token),
      );

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          if (data is Map<String, dynamic>) {
            return ApiResponse.success(data);
          } else {
            return ApiResponse.error('Format data tidak valid');
          }
        } catch (e) {
          return ApiResponse.error('Gagal memproses data: ${e.toString()}');
        }
      } else if (response.statusCode == 401) {
        await clearAuthData();
        return ApiResponse.error('Sesi berakhir, silakan login kembali');
      } else {
        return ApiResponse.error('Gagal mengambil data mahasiswa: ${response.body}');
      }
    } catch (e) {
      return ApiResponse.error('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<ApiResponse<bool>> logout() async {
    try {
      final token = await getToken();
      if (token == null) return ApiResponse.success(true); // Sudah logout

      final response = await http.post(
        Uri.parse('$_baseUrl/logout'),
        headers: _getHeaders(requiresAuth: true, token: token),
      );

      await clearAuthData();
      
      if (response.statusCode == 200) {
        return ApiResponse.success(true);
      } else {
        // Tetap menganggap logout sukses meskipun API gagal
        // karena kita sudah menghapus token lokal
        return ApiResponse.success(true);
      }
    } catch (e) {
      // Hapus token lokal meskipun terjadi error
      await clearAuthData();
      return ApiResponse.error('Terjadi kesalahan saat logout: ${e.toString()}');
    }
  }

  Future<bool> isLoggedIn() async {
    return await getToken() != null;
  }
}