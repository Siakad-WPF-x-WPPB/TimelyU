import 'package:get/get.dart';
import 'package:timelyu/modules/frs/frs_view.dart';
import './app_routes.dart';

import '../modules/home/home_screen.dart';
// import '../modules/schedule/schedule_screen.dart';
// import '../modules/task/task_screen.dart';
// import '../modules/frs/frs_screen.dart';

import '../modules/home/home_binding.dart';
// import '../modules/schedule/schedule_binding.dart';
// import '../modules/task/task_binding.dart';
// import '../modules/frs/frs_binding.dart';

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
    GetPage(
      name: AppRoutes.frs,
      page: () => FrsView(),
    )
  ];
}
