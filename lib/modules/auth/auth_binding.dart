import 'package:get/get.dart';
import 'package:timelyu/modules/auth/auth_controller.dart';
import 'package:timelyu/data/services/ApiService.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService(), fenix: true);
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
  }
}