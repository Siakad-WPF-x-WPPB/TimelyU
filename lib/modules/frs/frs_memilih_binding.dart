import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:timelyu/modules/frs/frs_controller.dart';

class FrsMemilihBinding  extends Bindings{
  @override
  void dependencies() {
    // Lazy load the FrsController when it's needed
    Get.lazyPut<FrsController>(() => FrsController());
  }
}