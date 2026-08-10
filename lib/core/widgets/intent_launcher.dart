import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class IntentLauncher {
  static const _channel = MethodChannel('com.example.intent_launcher');

  static Future<void> launchUrl(String url) async {
    try {
      await _channel.invokeMethod('launchUrl', {'url': url});
    } on PlatformException catch (e) {
      debugPrint("Failed to launch URL: '${e.message}'.");
    }
  }

  static Future<void> launchPhone(String phone) async {
    try {
      await _channel.invokeMethod('launchPhone', {'phone': phone});
    } on PlatformException catch (e) {
      debugPrint("Failed to launch phone: '${e.message}'.");
    }
  }
}
