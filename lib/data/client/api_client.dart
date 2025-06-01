import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart'; // Untuk HttpStatus

class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final int? statusCode;
  final Map<String, dynamic>? validationErrors;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.statusCode,
    this.validationErrors,
  });

  factory ApiResponse.success(T data, {String? message, int? statusCode = HttpStatus.ok}) =>
      ApiResponse(
        success: true,
        data: data,
        message: message,
        statusCode: statusCode,
        validationErrors: null,
      );

  factory ApiResponse.error(
    String message, {
    int? statusCode,
    T? data,
    Map<String, dynamic>? validationErrors,
  }) =>
      ApiResponse(
        success: false,
        message: message,
        statusCode: statusCode,
        data: data,
        validationErrors: validationErrors,
      );
}

class BaseApiService {
  // Gunakan IP address yang benar atau domain
  static const String baseUrl = "http://192.168.100.54:8000/api/mahasiswa";
  static const String tokenKey = 'auth_token';


  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  Map<String, String> getHeaders({bool requiresAuth = false, String? token}) {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (requiresAuth && token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }
}