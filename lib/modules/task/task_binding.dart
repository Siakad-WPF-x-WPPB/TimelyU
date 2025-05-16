import 'package:get/get.dart';
import 'package:timelyu/data/services/task_service.dart';
import 'task_controller.dart';

class TaskBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskController>(() => TaskController());
    Get.lazyPut<TaskService>(() => TaskService());
  }
}