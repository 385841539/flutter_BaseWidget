import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_common_plugin/base_lib.dart';
import 'package:flutter_common_plugin/fb_module_center.dart';
import 'package:flutter_common_plugin/src/utils/url_utils.dart';

class FBNavUtils {
  static bool isCurrent(BuildContext context) {
    if (context == null) return false;
    return ModalRoute.of(context)?.isCurrent;
  }

  ///[isNavigationBarVisible] 导航栏是否可见
  static Future openH5(BuildContext context, String url,
      {bool isNavigationBarVisible,
      String title,
      bool useDefaultConfig = true}) {
    return open(context, url,
        params: {"isNavigationBarVisible": isNavigationBarVisible},
        title: title,
        useDefaultConfig: useDefaultConfig);
  }

  ///任何东西都可以用此方法打开, 如果打开H5的话 ， 可以在params 中 设计h5 页面 是否隐藏 导航栏，详细参数见[WebPage]
  static Future open(BuildContext context, String path,
      {Map<String, dynamic> params,
      PushType pushType = PushType.PUSH,
      RoutePredicate predicate,
      String title,
      bool useDefaultConfig}) {
    if (path == null || path.isEmpty) return null;

    ///根据route 进行判断

    if (path.startsWith("flutter_function://")) {
      return FBChannelUtils.requestChannel(path, params: params);
    } else if (path.startsWith("flutter_page://")) {
      return open(context, path.replaceAll("flutter_page://", ""),
          params: params,
          pushType: pushType,
          predicate: predicate,
          title: title,
          useDefaultConfig: useDefaultConfig);
    }

    ///如果是H5地址
    Route route;
    if (UrlUtils.isHttpUrl(path)) {
      route = FBModuleCenter.generatorWebPageByRoute(
          path, title ?? "", useDefaultConfig ?? true, params);
    } else {
      route = FBModuleCenter.generatorRouteByPath(path,
          params: params, title: title);
    }

    ///关于页面跳转，这里可以 根据传入参数 进行不同的 操作 ， https://blog.csdn.net/u013894711/article/details/100729879

    if (pushType == PushType.PUSH) {
      return Navigator.push(context, route);
    } else if (pushType == PushType.PUSHREPLACEMENT) {
      return Navigator.pushReplacement(context, route);
    } else if (pushType == PushType.PUSHANDREMOVEUNTIL) {
      return Navigator.pushAndRemoveUntil(context, route, predicate);
    } else {
      return Navigator.push(context, route);
    }
  }

  ///关闭当前flutter 页面
  static void close(BuildContext context, {Map<String, dynamic> result}) {
    // print("-页面-能倒退么--${Navigator.canPop(context)}---");

    if (Navigator.canPop(context)) {
      Navigator.pop(context, result);
    } else {
      ///退出即可
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      exit(0);
    }
  }

  static void closeApp() {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    exit(0);
  }

  ///返回手机的主屏幕
  static void goToDeskTop() {
    if (AppConfig.isAndroid) {
      DartToNative.goToDeskTop();
    } else {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      exit(0);
    }
  }
}

enum PushType { PUSH, PUSHREPLACEMENT, PUSHANDREMOVEUNTIL }
