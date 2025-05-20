import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Apiservice {
  static const String _baseUrl = "https://api.example.com";

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'password': password},
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['token'] != null) {
      await _saveToken(data['token']);
      return {'success': true, 'data': data};
    } else {
      return {'success': false, 'message': data['message'] ?? 'Login gagal'};
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    final token = await _getToken();
    if (token == null)
      return {'success': false, 'message': 'Token tidak ditemukan'};

    final response = await http.get(
      Uri.parse('$_baseUrl/profile'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return {'success': true, 'data': jsonDecode(response.body)};
    } else {
      return {
        'success': false,
        'message': 'Gagal mengambil profil: ${response.body}',
      };
    }
  }

  Future<Map<String, dynamic>> getMahasiswaData() async {
    final token = await _getToken();
    if (token == null)
      return {'success': false, 'message': 'Token tidak ditemukan'};

    final response = await http.get(
      Uri.parse('$_baseUrl/data'), // Endpoint contoh
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return {'success': true, 'data': jsonDecode(response.body)};
    } else {
      return {
        'success': false,
        'message': 'Gagal mengambil data mahasiswa: ${response.body}',
      };
    }
  }

  Future<bool> logout() async {
    final token = await _getToken();
    if (token == null) return true; // Sudah logout

    final response = await http.post(
      Uri.parse('$_baseUrl/logout'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    await _removeToken();
    return response.statusCode == 200;
  }

  Future<bool> isLoggedIn() async {
    return await _getToken() != null;
  }
}
