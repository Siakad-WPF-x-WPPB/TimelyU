// modules/frs/frs_binding.dart
import 'package:get/get.dart';
import 'package:timelyu/data/services/frs_service.dart';
import 'package:timelyu/modules/frs/frs_controller.dart';

class FrsBinding extends Bindings {
  @override
  void dependencies() {
    // Register FrsService terlebih dahulu
    Get.lazyPut<FrsService>(() => FrsService(), fenix: true);
    
    // Kemudian register FrsController
    Get.lazyPut<FrsController>(() => FrsController(), fenix: true);
  }
}