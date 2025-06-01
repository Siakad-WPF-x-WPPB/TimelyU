import 'package:get/get.dart';
import 'package:timelyu/data/services/task_service.dart';
import 'package:timelyu/modules/task/task_controller.dart';

class TaskBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskService>(() => TaskService());
    Get.lazyPut<TaskController>(() => TaskController(Get.find<TaskService>()));
  }
}