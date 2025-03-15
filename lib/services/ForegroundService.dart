import 'package:flutter/services.dart';

class ForegroundService {
  static const platform = MethodChannel("foreground_service");

  static Future<void> startService(String title, String body) async {
    try {
      await platform.invokeMethod("startService", {
        "title": title,
        "body": body,
      });
    } catch (e) {
      print("Error starting service: $e");
    }
  }

  static Future<void> stopService() async {
    try {
      await platform.invokeMethod("stopService");
    } catch (e) {
      print("Error stopping service: $e");
    }
  }
}

