import 'package:get/get.dart';
import 'package:timelyu/data/services/task_service.dart';
import 'package:timelyu/modules/task/task_binding.dart';
import 'package:timelyu/modules/task/task_screen.dart';

class AppRoutes {
  static const String home = '/home';
  static const String task = '/task';
  static const String schedule = '/schedule';
  
  static final List<GetPage> pages = [
    GetPage(
      name: task,
      page: () => TaskScreen(),
      binding: TaskBinding(),
    ),
    // Add other routes here
  ];
}

void initialBindings() {
  // Initialize services
  Get.put(TaskService(), permanent: true);
}

class AppPages {
  static String initial = AppRoutes.task;
  
  static final routes = AppRoutes.pages;
}