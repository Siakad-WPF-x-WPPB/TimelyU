import 'package:get/get.dart';
import 'package:timelyu/data/models/user_model.dart';
import 'package:timelyu/data/services/ApiService.dart';
import 'package:timelyu/routes/app_routes.dart';

class AuthController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final RxBool isLoading = false.obs;
  final Rxn<UserModel> user = Rxn<UserModel>();
  final RxnString errorMessage = RxnString();
  final RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  // Fungsi ini akan dipanggil saat aplikasi dimulai untuk memeriksa status login
  Future<void> checkLoginStatus() async {
    isLoading.value = true;
    try {
      isLoggedIn.value = await _apiService.isLoggedIn();
      if (isLoggedIn.value) {
        user.value = await _apiService.getCachedUserData();
        if (user.value == null) {
          await fetchProfile(showLoading: false);
        } else {
          fetchProfile(showLoading: false);
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

  // Fungsi untuk login, menerima email dan password sebagai parameter
  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      errorMessage.value = 'Email dan password harus diisi';
      Get.snackbar(
        'Input Tidak Lengkap',
        errorMessage.value!,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    try {
      final result = await _apiService.login(email, password);

      if (result.success && result.data != null) {
        user.value = result.data;
        isLoggedIn.value = true;
        Get.offAllNamed(AppRoutes.home); // Navigate to home
      } else {
        errorMessage.value = result.message ?? 'Login gagal. Periksa kembali kredensial Anda.';
        Get.snackbar(
          'Login Gagal',
          errorMessage.value!,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan saat login: ${e.toString()}';
      Get.snackbar(
        'Error',
        errorMessage.value!,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

// Fungsi untuk menangkap profil pengguna
  Future<void> fetchProfile({bool showLoading = false}) async {
    if (showLoading) {
      isLoading.value = true;
    }
    errorMessage.value = null;

    try {
      final result = await _apiService.getProfile();
      if (result.success && result.data != null) {
        user.value = result.data;
      } else {
        if (result.statusCode == 401 ||
            result.message?.contains('Sesi berakhir') == true ||
            result.message?.toLowerCase().contains('unauthenticated') == true) {
          await logout(navigateToLogin: true, showMessage: true, message: result.message ?? 'Sesi Anda telah berakhir.');
        } else {
          errorMessage.value = result.message ?? 'Gagal memuat profil.';
        }
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan saat memuat profil: ${e.toString()}';
    } finally {
      if (showLoading) {
        isLoading.value = false;
      }
    }
  }

  // Fungsi untuk logout
  Future<void> logout({bool navigateToLogin = true, bool showMessage = true, String? message}) async {
    isLoading.value = true;
    try {
      final result = await _apiService.logout();
      if (result.success) {
        user.value = null;
        isLoggedIn.value = false;
        message = message ?? 'Anda telah berhasil keluar.';
      } else {
        message = result.message ?? 'Gagal logout. Silakan coba lagi.';
      }
    } catch (e) {
      print("Error during AuthController logout sequence: $e");
    } finally {
      user.value = null;
      isLoggedIn.value = false;
      isLoading.value = false;

      if (navigateToLogin) {
        Get.offAllNamed(AppRoutes.login);
      }
      if (showMessage) {
        Get.snackbar(
          message != null ? 'Informasi' : 'Logout Berhasil',
          message ?? 'Anda telah keluar dari aplikasi.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
}