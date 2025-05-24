// File: lib/modules/auth/auth_controller.dart (atau sesuaikan path Anda)
import 'package:get/get.dart';
import 'package:timelyu/data/models/user_model.dart';
import 'package:timelyu/data/services/ApiService.dart';
import 'package:timelyu/routes/app_routes.dart'; // Sesuaikan path ke AppRoutes

class AuthController extends GetxController {
  // ApiService will be injected by GetX (from AuthBinding or a global binding)
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

  Future<void> checkLoginStatus() async {
    isLoading.value = true;
    try {
      isLoggedIn.value = await _apiService.isLoggedIn();
      if (isLoggedIn.value) {
        user.value = await _apiService.getCachedUserData();
        // Optionally, refresh profile data from server
        if (user.value == null) { // If not in cache, fetch
          await fetchProfile();
        } else { // If in cache, refresh in background (optional)
          fetchProfile(); // No await to avoid blocking UI
        }
      } else {
        user.value = null; // Ensure user is null if not logged in
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
      // This catch might be redundant if ApiService handles all exceptions
      // and returns ApiResponse.error
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

  Future<void> fetchProfile({bool showLoading = false}) async {
    if (showLoading) {
        isLoading.value = true;
    }
    errorMessage.value = null; // Clear previous error

    try {
      final result = await _apiService.getProfile();
      if (result.success && result.data != null) {
        user.value = result.data;
      } else {
        // If fetchProfile fails (e.g., token expired), logout user
        if (result.statusCode == 401 || result.message?.contains('Sesi berakhir') == true || result.message?.contains('Unauthenticated') == true) {
          await logout(navigateToLogin: true, showMessage: true, message: result.message ?? 'Sesi Anda telah berakhir.');
        } else {
          errorMessage.value = result.message ?? 'Gagal memuat profil.';
          // Optionally show a snackbar for other profile fetch errors
          // Get.snackbar('Error Profil', errorMessage.value!, snackPosition: SnackPosition.BOTTOM);
        }
      }
    } catch (e) {
      // This catch might be redundant
      errorMessage.value = 'Terjadi kesalahan saat memuat profil: ${e.toString()}';
    } finally {
       if (showLoading) {
        isLoading.value = false;
      }
    }
  }

  Future<void> logout({bool navigateToLogin = true, bool showMessage = true, String? message}) async {
    isLoading.value = true;
    try {
      await _apiService.logout(); // Call API logout
    } catch (e) {
      // ApiService.logout already handles clearing local data and returning success for client.
      // This catch is mostly for unexpected errors during the controller's call.
      print("Error during AuthController logout sequence: $e");
    } finally {
      // Always clear data locally and update state
      user.value = null;
      isLoggedIn.value = false;
      // _apiService.clearAuthData() is called within _apiService.logout(),
      // but calling it again here is safe if you want to be absolutely sure.
      // await _apiService.clearAuthData();

      isLoading.value = false;
      if (navigateToLogin) {
        Get.offAllNamed(AppRoutes.login); // Navigate to login
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