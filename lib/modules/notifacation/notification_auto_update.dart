import 'dart:async';
import 'package:flutter/material.dart';

mixin NotificationAutoUpdateMixin<T extends StatefulWidget> on State<T> {
  Timer? _autoUpdateTimer;

  @override
  void initState() {
    super.initState();
    _startAutoUpdate();
  }

  void _startAutoUpdate() {
    // Auto-update every 30 minutes
    _autoUpdateTimer?.cancel();
    _autoUpdateTimer = Timer.periodic(Duration(minutes: 30), (timer) {
      _handleAutoUpdate();
    });
  }

  void _handleAutoUpdate() {
    // Override this method in your widgets if needed
    print('Auto-updating notifications...');
  }

  @override
  void dispose() {
    _autoUpdateTimer?.cancel();
    super.dispose();
  }
}
