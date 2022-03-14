import 'dart:async';

import 'package:flutter/services.dart';

class FlutterCommonPlugin {
  static const MethodChannel _channel =
      const MethodChannel('flutter_common_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future invokeMethod(String method, [dynamic arguments]) {
    return _channel.invokeMethod(method, arguments);
  }

  static void setMethodCallHandler(Future<dynamic> handler(MethodCall call)) {
    _channel.setMethodCallHandler(handler);
  }
}
