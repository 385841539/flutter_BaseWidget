import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_base_widget/base/buildConfig.dart';
import 'package:flutter_base_widget/route/router_application.dart';

/// 路由跳转 中转处
class Nav {
  static Future nav(BuildContext context, String path,
      {bool replace = false,
      bool clearStack = false,
      TransitionType transition,
      Duration transitionDuration = const Duration(milliseconds: 250),
      RouteTransitionsBuilder transitionBuilder}) {
    if (path == null || path.isEmpty) {
      if (BuildConfig.isDebug) {
        throw "empty path";
      }
    }

    return Application.router.navigateTo(context, path,
        replace: replace,
        clearStack: clearStack,
        transition: transition,
        transitionDuration: transitionDuration,
        transitionBuilder: transitionBuilder);
  }

  ///判断是否是原生的路由 路径，是的话则需要 调原生跳转
  static bool checkIsNativePath(String path) {
    return (path.startsWith("http://") || path.startsWith("https://")) ||
        (path.startsWith("native://"));
  }
}
