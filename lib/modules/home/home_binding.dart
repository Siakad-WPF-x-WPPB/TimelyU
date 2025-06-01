import 'package:get/get.dart';
import 'package:timelyu/data/services/task_service.dart';

import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut(() => TaskService(), fenix: true);
  }
}
