import 'package:flutter/material.dart';
import 'package:timelyu/modules/notifacation/global_notification_manager.dart';

class AppLifecycleHandler extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // App kembali ke foreground, refresh notifications
        GlobalNotificationManager.instance.initialize();
        break;
      case AppLifecycleState.paused:
        // App di background
        break;
      case AppLifecycleState.detached:
        // App ditutup
        GlobalNotificationManager.instance.dispose();
        break;
      default:
        break;
    }
  }
}
