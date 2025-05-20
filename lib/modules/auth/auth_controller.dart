import 'package:get/get.dart';
import 'package:timelyu/data/services/ApiService.dart';

class AuthController extends GetxController {
  final Apiservice _apiService = Apiservice();

  var isLoading = false.obs;
  var userData = Rxn<Map<String, dynamic>>();
  var errorMessage = RxnString();

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    final result = await _apiService.login(email, password);
    isLoading.value = false;

    if (result['success']) {
      userData.value = result['data'];
      errorMessage.value = null;
      Get.offAllNamed('/home'); // atau arahkan ke halaman home
    } else {
      errorMessage.value = result['message'];
      Get.snackbar('Login Gagal', result['message'],
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    final result = await _apiService.getProfile();
    isLoading.value = false;

    if (result['success']) {
      userData.value = result['data'];
      errorMessage.value = null;
    } else {
      errorMessage.value = result['message'];
    }
  }

  Future<void> logout() async {
    await _apiService.logout();
    userData.value = null;
    Get.offAllNamed('/login');
  }

  Future<bool> isLoggedIn() async {
    return await _apiService.isLoggedIn();
  }
}
