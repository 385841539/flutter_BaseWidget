import 'dart:ui';

import 'package:flutter/material.dart';

class BaseUiConfig {
  static Color globalThemColor = Colors.deepOrange;

  /// 这里要讲解这个 全局配置的 由来

  ///状态栏 配置相关
  ///全局状态栏颜色
  static Color globalStatusBarColor = globalThemColor;

  ///全局状态栏是否可见
  static bool globalIsStatusBarVisible = true;

  ///导航栏 配置相关
  ///全局导航栏背景颜色
  static Color globalNavigationBarBackgroundColor = globalThemColor;

  ///全局导航栏是否可见
  static bool globalNavigationBarVisible = true;

  ///全局导航栏高度
  static double globalNavigationBarHeight = kToolbarHeight;

  ///全局标题 大小
  static double globalTitleSize = 20;

  ///全局导航栏内容颜色
  static Color globalNavigationBarContentColor = Colors.white;

  ///全局导航栏标题是否可见
  static bool globalNavBarCenterVisible = true;

  ///全局错误配置
  ///全局错误图片路径配置
  static String globalErrorImgPath =
      "packages/flutter_common_plugin/images/load_error_view.png";

  static Color globalPageBackgroundColor = Colors.white;

  static IconData globalBackIcon = Icons.arrow_back_ios_rounded;

  static double globalCenterTitlePosition = -1; //小余0 居中 ， 否则 以此为准

//  /状态栏高度
// double getStatusBarHeight() {
//   return _statusBarHeight ?? MediaQuery.of(context).padding.top;
// }
}
