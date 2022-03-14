import 'dart:io';

class AppConfig {
  // static bool isRootType = !bool.fromEnvironment("dart.vm.product");

  // static bool isDebug = !bool.fromEnvironment("dart.vm.product");
  static bool isDebug = false; ////是否可切环境
  static bool isAppIdDev = false;

  ///安卓是否是dev包名
  static bool isIos = Platform.isIOS;
  static bool isAndroid = Platform.isAndroid;

  static bool isApplicationVisible = true;
}
