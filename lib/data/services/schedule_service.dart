// import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:timelyu/data/models/schedule.dart';

// class ScheduleService {
//   static const baseUrl = 'http://192.168.183.246:8000/api/mahasiswa';
//   final FlutterSecureStorage storage;
  
//   ScheduleService({FlutterSecureStorage? secureStorage}) 
//       : storage = secureStorage ?? const FlutterSecureStorage();

//   /// Mengambil token autentikasi dari secure storage
//   Future<String?> getToken() async {
//     try {
//       final token = await storage.read(key: 'auth_token');
//       print('🔑 Token retrieved: ${token != null ? 'Found' : 'Not found'}');
//       return token;
//     } catch (e) {
//       print('❌ Error getting token: $e');
//       return null;
//     }
//   }

//   /// Header umum untuk request API
//   Future<Map<String, String>> _getHeaders() async {
//     final token = await getToken();
    
//     if (token == null || token.isEmpty) {
//       print('⚠️ Warning: No auth token found');
//       throw Exception('Token autentikasi tidak ditemukan. Silakan login ulang.');
//     }
    
//     return {
//       'Authorization': 'Bearer $token',
//       'Accept': 'application/json',
//       'Content-Type': 'application/json',
//     };
//   }

//   /// Test koneksi dan token
//   Future<bool> testConnection() async {
//     try {
//       final headers = await _getHeaders();
//       final response = await http.get(
//         Uri.parse('$baseUrl/profile'), // Endpoint untuk test auth
//         headers: headers,
//       ).timeout(const Duration(seconds: 10));
      
//       print('🌐 Test connection status: ${response.statusCode}');
//       return response.statusCode == 200;
//     } catch (e) {
//       print('❌ Connection test failed: $e');
//       return false;
//     }
//   }

//   /// Mengambil semua jadwal kuliah
//   Future<List<Schedule>> fetchAllSchedule() async {
//     try {
//       final headers = await _getHeaders();
//       print('📡 Fetching all schedules...');
      
//       final response = await http.get(
//         Uri.parse('$baseUrl/jadwal'),
//         headers: headers,
//       ).timeout(const Duration(seconds: 15));

//       print('📋 All schedule response status: ${response.statusCode}');
//       print('📋 All schedule response body: ${response.body}');

//       if (response.statusCode == 401) {
//         throw Exception('Token tidak valid. Silakan login ulang.');
//       }

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         return _parseScheduleResponse(data);
//       } else {
//         throw Exception('Server error: ${response.statusCode} - ${response.body}');
//       }
//     } catch (e) {
//       print('❌ Error fetching all schedule: $e');
//       rethrow;
//     }
//   }

//   /// Mengambil jadwal kuliah hari ini
//   Future<List<Schedule>> fetchTodaySchedule() async {
//     try {
//       final headers = await _getHeaders();
//       print('📡 Fetching today schedule...');
      
//       final response = await http.get(
//         Uri.parse('$baseUrl/jadwal/hari-ini'),
//         headers: headers,
//       ).timeout(const Duration(seconds: 15));

//       print('📅 Today schedule response status: ${response.statusCode}');
//       print('📅 Today schedule response body: ${response.body}');

//       if (response.statusCode == 401) {
//         throw Exception('Token tidak valid. Silakan login ulang.');
//       }

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         return _parseScheduleResponse(data);
//       } else {
//         throw Exception('Server error: ${response.statusCode} - ${response.body}');
//       }
//     } catch (e) {
//       print('❌ Error fetching today schedule: $e');
//       rethrow;
//     }
//   }

//   /// Mengambil jadwal kuliah mendatang
//   Future<List<Schedule>> fetchUpcomingSchedule() async {
//     try {
//       final headers = await _getHeaders();
//       print('📡 Fetching upcoming schedule...');
      
//       final response = await http.get(
//         Uri.parse('$baseUrl/jadwal/mendatang'),
//         headers: headers,
//       ).timeout(const Duration(seconds: 15));

//       print('⏰ Upcoming schedule response status: ${response.statusCode}');
//       print('⏰ Upcoming schedule response body: ${response.body}');

//       if (response.statusCode == 401) {
//         throw Exception('Token tidak valid. Silakan login ulang.');
//       }

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         return _parseScheduleResponse(data);
//       } else {
//         throw Exception('Server error: ${response.statusCode} - ${response.body}');
//       }
//     } catch (e) {
//       print('❌ Error fetching upcoming schedule: $e');
//       rethrow;
//     }
//   }

//   /// Helper untuk parsing response schedule
//   List<Schedule> _parseScheduleResponse(dynamic data) {
//     try {
//       List<dynamic> scheduleList;
      
//       if (data is List) {
//         scheduleList = data;
//       } else if (data is Map && data.containsKey('data')) {
//         scheduleList = data['data'] as List;
//       } else if (data is Map && data.containsKey('jadwal')) {
//         scheduleList = data['jadwal'] as List;
//       } else {
//         print('❌ Unexpected response format: $data');
//         throw Exception('Format response tidak sesuai');
//       }
      
//       print('📊 Parsing ${scheduleList.length} schedule items');
      
//       return scheduleList.map((item) {
//         try {
//           return Schedule.fromJson(item as Map<String, dynamic>);
//         } catch (e) {
//           print('❌ Error parsing schedule item: $item, Error: $e');
//           rethrow;
//         }
//       }).toList();
      
//     } catch (e) {
//       print('❌ Error in _parseScheduleResponse: $e');
//       rethrow;
//     }
//   }

//   /// Clear token (untuk logout)
//   Future<void> clearToken() async {
//     await storage.delete(key: 'auth_token');
//     print('🗑️ Auth token cleared');
//   }
// }