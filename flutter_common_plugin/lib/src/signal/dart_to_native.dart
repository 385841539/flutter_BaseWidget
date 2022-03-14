import 'package:flutter_common_plugin/flutter_common_plugin.dart';

/// dart调原生通信 工具
class DartToNative {
  static Future requestNative(String protocol,
      {Map<String, dynamic> params}) async {
    return FlutterCommonPlugin.invokeMethod(protocol, params);
  }
  ///返回手机的主屏幕
  static void goToDeskTop() {
    requestNative("native://goToDeskTop");
  }
}
