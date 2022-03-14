import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FBScreenUtil {
  static bool _haveExactWidth = false;
  static double _screenWidth = 0;
  static double defaultWidth;

  FBScreenUtil() : super();

  ///返回设备宽度 px
  static getScreenWidthPx() {
    return ScreenUtil().screenWidthPx ?? defaultWidth ?? 820;
  }

  static double getScreenWidth() {
    if (_haveExactWidth && _screenWidth != null && _screenWidth != 0) {
      return (_screenWidth == null || _screenWidth == 0)
          ? defaultWidth ?? 410
          : _screenWidth;
    }
    _screenWidth = ScreenUtil().screenWidth;
    if (_screenWidth != null && _screenWidth != 0) {
      _haveExactWidth = true;
    }
    return (_screenWidth == null || _screenWidth == 0)
        ? defaultWidth ?? 410
        : _screenWidth;
  }

  ///返回设备高度 px
  static getScreenHeightPx() {
    return ScreenUtil().screenHeightPx ?? 2960;
  }

  static getScreenHeight() {
    return ScreenUtil().screenHeight ?? 1980;
  }

  ///返回状态栏高度
  static getStatusBarHeight() {
    return ScreenUtil().statusBarHeight ?? 25;
  }

  ///返回导航栏栏高度
  static getNavBarHeight() {
    return kToolbarHeight ?? 56;
  }

  void init(
    BuildContext context, {
    Size designSize = ScreenUtil.defaultSize,
    bool allowFontScaling = false,
  }) {
    ScreenUtil.init(context,
        designSize: designSize, allowFontScaling: allowFontScaling);
  }
}
