import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timelyu/data/models/schedule_today.dart';
import 'package:timelyu/modules/notifacation/global_notification_manager.dart'; // Untuk HttpStatus

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

    Future<ApiResponse<ScheduleListData>> getTodaySchedule() async {
    try {
      final token = await getToken();
      final headers = getHeaders(requiresAuth: true, token: token);

      final response = await http.get(
        Uri.parse('$baseUrl/jadwal/today'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = ScheduleListData.fromJson(jsonDecode(response.body));

        // Automatically update notifications for new schedule data
        await GlobalNotificationManager.instance
            .updateSchedulesAndNotifications(data.data);

        return ApiResponse.success(data);
      } else {
        return ApiResponse.error(
          'Failed to load schedule',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
}