import 'package:get/get.dart';
import 'package:timelyu/data/services/ApiService.dart';
import 'package:timelyu/routes/app_routes.dart';

class AuthController extends GetxController {
  // Gunakan lazy loading untuk ApiService
  final ApiService _apiService = Get.find<ApiService>();
  
  // State variables
  final RxBool isLoading = false.obs;
  final Rxn<UserModel> user = Rxn<UserModel>();
  final RxnString errorMessage = RxnString();
  final RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  // Memeriksa status login saat aplikasi dimulai
  Future<void> checkLoginStatus() async {
    isLoading.value = true;
    
    try {
      // Cek token tersimpan
      isLoggedIn.value = await _apiService.isLoggedIn();
      
      if (isLoggedIn.value) {
        // Ambil data user dari cache jika tersedia
        user.value = await _apiService.getCachedUserData();
        
        // Refresh data user dari server
        await fetchProfile();
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Login method
  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      errorMessage.value = 'Email dan password harus diisi';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = null;
      
      final result = await _apiService.login(email, password);
      
      if (result.success && result.data != null) {
        user.value = result.data;
        isLoggedIn.value = true;
        Get.offAllNamed(AppRoutes.home);
      } else {
        errorMessage.value = result.message ?? 'Login gagal';
        Get.snackbar(
          'Login Gagal', 
          result.message ?? 'Terjadi kesalahan saat login',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: ${e.toString()}';
      Get.snackbar(
        'Error', 
        'Terjadi kesalahan saat login: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch user profile data
  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      
      final result = await _apiService.getProfile();
      
      if (result.success && result.data != null) {
        user.value = result.data;
      } else {
        errorMessage.value = result.message;
        
        // Jika error 401, redirect ke login
        if (result.message?.contains('Sesi berakhir') == true) {
          isLoggedIn.value = false;
          Get.offAllNamed(AppRoutes.login);
        }
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      isLoading.value = true;
      
      final result = await _apiService.logout();
      
      // Bersihkan state controller
      user.value = null;
      isLoggedIn.value = false;
      
      Get.offAllNamed(AppRoutes.login);
      
      if (!result.success) {
        Get.snackbar(
          'Info', 
          'Anda telah keluar dari aplikasi',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Info', 
        'Anda telah keluar dari aplikasi',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}