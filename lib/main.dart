import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelyu/shared/themes/global_theme.dart';
import 'routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize services
    initialBindings();
    
    return GetMaterialApp(
      title: 'Aplikasi Tugas',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}