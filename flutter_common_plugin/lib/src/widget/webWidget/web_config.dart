import 'package:webview_flutter/webview_flutter.dart';

class WebConfig {
  static Set<JavascriptChannel> _jsSet = Set();

  static void addJavascriptChannel(JavascriptChannel javascriptChannel) {
    if (javascriptChannel != null) {
      bool isHazContainer = false;
      jsSet.forEach((element) {
        if (element.name == javascriptChannel.name) {
          print("---已经有了 ---");
          isHazContainer = true;
        }
      });
      if (!isHazContainer) {
        _jsSet.add(javascriptChannel);
      }
    }
  }

  static void removeJavascriptChannel(JavascriptChannel javascriptChannel) {
    if (javascriptChannel != null && _jsSet.contains(javascriptChannel)) {
      _jsSet.remove(javascriptChannel);
    }
  }

  static Set<JavascriptChannel> get jsSet => _jsSet;
}
