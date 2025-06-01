import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:timelyu/data/models/user_model.dart'; // Sesuaikan path
import 'package:timelyu/data/services/auth_service.dart';

import 'package:timelyu/routes/app_routes.dart'; // Sesuaikan path

class AuthController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final RxBool isLoading = false.obs;
  final Rxn<UserModel> user = Rxn<UserModel>();
  final RxnString errorMessage = RxnString(); // Untuk error yang relevan dengan UI
  final RxBool isLoggedIn = false.obs;

  // Pesan Snackbar
  static const String _inputIncompleteTitle = 'Input Tidak Lengkap';
  static const String _loginFailedTitle = 'Login Gagal';
  static const String _errorTitle = 'Error';
  static const String _infoTitle = 'Informasi';
  static const String _logoutSuccessMsg = 'Anda telah berhasil keluar.';
  static const String _logoutFailedMsg = 'Gagal logout. Silakan coba lagi.';
  
  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    isLoading.value = true;
    try {
      final loggedIn = await _apiService.isLoggedIn();
      isLoggedIn.value = loggedIn;
      if (loggedIn) {
        user.value = await _apiService.getCachedUserData();
        // Selalu coba sinkronkan dengan profil terbaru dari server, 
        // tapi jangan blok UI jika user data sudah ada di cache.
        // Jika user.value null setelah dari cache, fetchProfile akan jadi prioritas.
        if (user.value == null) {
          await fetchProfile(showLoading: false, isInitialCheck: true);
        } else {
          // User data ada di cache, fetch di background untuk update jika ada
          fetchProfile(showLoading: false, isInitialCheck: true).catchError((e) {
             print("Background profile fetch failed: $e"); // Log error, jangan ganggu user
          });
        }
      } else {
        user.value = null;
      }
    } catch (e) {
      errorMessage.value = "Gagal memeriksa status login: ${e.toString()}";
      isLoggedIn.value = false;
      user.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _showSnackbar(_inputIncompleteTitle, 'Email dan password harus diisi.');
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    final result = await _apiService.login(email, password);

    if (result.success && result.data != null) {
      user.value = result.data;
      isLoggedIn.value = true;
      Get.offAllNamed(AppRoutes.home);
    } else {
      errorMessage.value = result.message ?? 'Login gagal. Periksa kembali kredensial Anda.';
      _showSnackbar(_loginFailedTitle, errorMessage.value!);
    }
    isLoading.value = false;
  }

  Future<void> fetchProfile({bool showLoading = false, bool isInitialCheck = false}) async {
    if (showLoading) isLoading.value = true;
    errorMessage.value = null; // Clear previous specific errors for profile

    final result = await _apiService.getProfile();

    if (result.success && result.data != null) {
      user.value = result.data;
    } else {
      // Jika fetchProfile gagal saat initial check, jangan langsung logout jika ada cached user.
      // Hanya logout jika errornya adalah unauthorized.
      if (result.statusCode == 401 || 
          result.message?.toLowerCase().contains('unauthenticated') == true ||
          result.message?.toLowerCase().contains('sesi berakhir') == true) {
        // Jika ini bukan initial check, atau jika initial check dan tidak ada user di cache
        if (!isInitialCheck || (isInitialCheck && user.value == null)) {
           await logout(
            navigateToLogin: true, 
            showMessage: true, 
            message: result.message ?? 'Sesi Anda telah berakhir, silakan login kembali.'
          );
        } else {
          // Saat initial check dan ada user di cache, tapi profile fetch 401.
          // Mungkin tokennya invalid tapi user masih bisa pakai data cache.
          // Atau, bisa juga langsung logout. Tergantung requirement.
          // Untuk saat ini, kita biarkan user dengan data cache.
           print("Profile fetch unauthenticated, but using cached data during initial check.");
           errorMessage.value = result.message; // Tetap tampilkan error jika ada
        }
      } else {
        // Untuk error lain (network, server error selain 401)
        // Jangan hapus user.value jika sudah ada, agar aplikasi tidak blank.
        // Cukup tampilkan pesan error.
        errorMessage.value = result.message ?? 'Gagal memuat profil.';
        if (!isInitialCheck && showLoading) { // Hanya tampilkan snackbar jika bukan initial check atau ada loading eksplisit
            _showSnackbar(_errorTitle, errorMessage.value!);
        }
      }
    }
    if (showLoading) isLoading.value = false;
  }

// fungsi untuk logout
  Future<void> logout({
    bool navigateToLogin = true, 
    bool showMessage = true, 
    String? message,
  }) async {
    isLoading.value = true;
    final result = await _apiService.logout(); // ApiService.logout() sudah clear local data
    
    // Apapun hasil dari server, data lokal sudah dihapus oleh _apiService.logout()
    user.value = null;
    isLoggedIn.value = false;
    
    String finalMessage;
    if (result.success) {
      finalMessage = message ?? _logoutSuccessMsg;
    } else {
      // Jika API logout gagal di server, tapi lokal sudah bersih
      finalMessage = result.message ?? _logoutFailedMsg;
      print("Server logout failed but local data cleared: ${result.message}");
    }
    
    isLoading.value = false;

    if (navigateToLogin) {
      Get.offAllNamed(AppRoutes.login);
    }
    if (showMessage) {
      _showSnackbar(
        result.success ? _infoTitle : _errorTitle,
        finalMessage,
      );
    }
  }

  void _showSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: title == _errorTitle || title == _loginFailedTitle ? Colors.red.shade600 : Colors.black87,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
    );
  }
}