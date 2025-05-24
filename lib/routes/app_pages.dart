import 'package:get/get.dart';
import 'package:timelyu/modules/auth/auth_binding.dart';
import 'package:timelyu/modules/auth/auth_login_view.dart';
import 'package:timelyu/modules/frs/frs_binding.dart';
import 'package:timelyu/modules/frs/frs_memilih_binding.dart';
import 'package:timelyu/modules/frs/frs_memilih_view.dart';
import 'package:timelyu/modules/frs/frs_view.dart';
import 'package:timelyu/modules/home/profile_view.dart';
import 'package:timelyu/modules/nilai/nilai_binding.dart';
import 'package:timelyu/modules/nilai/nilai_view.dart';
import 'package:timelyu/modules/schedule/full_schedule_view.dart';
import 'package:timelyu/modules/schedule/schedule_binding.dart';
import 'package:timelyu/modules/schedule/schedule_view.dart';
import 'package:timelyu/modules/task/task_binding.dart';
import 'package:timelyu/modules/task/task_view.dart';
import './app_routes.dart';
import '../modules/home/home_view.dart';
import '../modules/home/home_binding.dart' as home;


class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    
    // Keep individual routes untuk akses langsung jika diperlukan
    GetPage(
      name: AppRoutes.home,
      page: () => HomeView(),
      binding: home.HomeBinding(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileView()
    ),
    GetPage(
      name: AppRoutes.root,
      page: () => LoginScreen(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.schedule,
      page: () => ScheduleView(),
      binding: ScheduleBinding(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.frs,
      page: () => FrsView(),
      binding: FrsBinding(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.nilai,
      page: () => NilaiView(),
      binding: NilaiBinding(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.tasks,
      page: () => TaskView(),
      binding: TaskBinding(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.frsMemilih,
      page: () => FrsMemilihView(),
      binding: FrsMemilihBinding(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.fullSchedule,
      page: () => FullScheduleView(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
  ];
}