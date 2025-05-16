import 'package:get/get.dart';
import './app_routes.dart';

import '../modules/home/home_view.dart';
import '../modules/schedule/schedule_view.dart';
import '../modules/task/task_view.dart';
import '../modules/frs/frs_view.dart';

import '../modules/home/home_binding.dart' as home;
import '../modules/schedule/schedule_binding.dart' as schedule;
import '../modules/task/task_binding.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => HomeView(),
      binding: home.HomeBinding(),
      transition: Transition.native,
    ),
    GetPage(
      name: AppRoutes.root,
      page: () => HomeView(),
      binding: home.HomeBinding(),
      transition: Transition.native,
    ),
    GetPage(
      name: AppRoutes.schedule,
      page: () => ScheduleView(),
      binding: schedule.ScheduleBinding(),
      transition: Transition.native,
    ),
    GetPage(
      name: AppRoutes.frs,
      page: () => FrsView(),
      transition: Transition.native,
    ),
    GetPage(
      name: AppRoutes.tasks,
      page: () => TaskView(),
      binding: TaskBinding(),
      transition: Transition.native,
    ),
  ];
}
