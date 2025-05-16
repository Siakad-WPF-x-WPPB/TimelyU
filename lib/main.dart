import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelyu/modules/task/task_binding.dart';

import 'package:timelyu/routes/app_pages.dart';
import 'package:timelyu/shared/themes/global_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'TimelyU',
      initialRoute: '/tasks',
      initialBinding: TaskBinding(),
      theme: AppTheme.lightTheme,
      getPages: AppPages.routes,
    );
  }
}