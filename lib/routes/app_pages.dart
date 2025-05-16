import 'package:get/get.dart';
import 'package:timelyu/modules/task/task_binding.dart';
import 'package:timelyu/modules/task/task_screen.dart';
import './app_routes.dart';

import '../modules/home/home_screen.dart';


import '../modules/home/home_binding.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.root,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(name: AppRoutes.tasks, page: () => TaskScreen(), binding: TaskBinding()),
  ];
}
