import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelyu/modules/notifacation/app_lifecyle.dart';
import 'package:timelyu/modules/notifacation/global_notification_manager.dart';
import 'package:timelyu/modules/notifacation/notification_service.dart';

import 'package:timelyu/routes/app_pages.dart';
import 'package:timelyu/shared/themes/global_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize notification service
    await NotificationService.initialize();

    // Create notification channel
    await NotificationService.createNotificationChannel();

    // Initialize global notification manager
    GlobalNotificationManager.instance.initialize();

    // Add lifecycle observer
    final lifecycleHandler = AppLifecycleHandler();
    WidgetsBinding.instance.addObserver(lifecycleHandler);

    print('App initialized successfully');
  } catch (e) {
    print('Error during app initialization: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TimelyU',
      initialRoute: '/',
      theme: AppTheme.lightTheme,
      getPages: AppPages.routes,
    );
  }
}