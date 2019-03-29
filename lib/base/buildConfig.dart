import 'dart:io';

class BuildConfig {
  //系统标记类
  static bool isDebug = !bool.fromEnvironment("dart.vm.product");
  static bool isAndroid = Platform.isAndroid;
  static bool isIos = Platform.isIOS;
}
