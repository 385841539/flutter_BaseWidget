import 'dart:async';

import 'package:flutter/material.dart';

/// 模块基础类
abstract class FBBaseModule {
  /// 模块名称
  String moduleName();

  ///注册模块路由
  List<FBModulePage> registerRoutes();

  ///注册模块间 通信的路由通道
  List<FBModuleChannel> registerModuleChannel();
}

typedef Widget FBPageBuilder(Map<String, dynamic> params);

///页面实体类
class FBModulePage {
  final String pageTitle;
  final List<String> route;
  final FBPageBuilder builder;
  final bool needLogin;

  const FBModulePage(this.pageTitle, this.route, this.builder,
      {this.needLogin});
}

///Flutter 组件 以及 一切 公用 类似event bus 的实体类,可继承使用
abstract class FBModuleChannel {
  String getRoute();

  void invoke(Map<String, dynamic> params, Completer<dynamic> completer);

  String get route => getRoute();
}

///Flutter 组件 以及 一切 公用 类似event bus 的实体类 ，可构造方法使用
class FBModuleChannelModel extends FBModuleChannel {
  final String route;
  final Function(Map<String, dynamic> params, Completer<dynamic> completer)
      invokeMethod;

  FBModuleChannelModel(this.route, this.invokeMethod);

  @override
  String getRoute() {
    return route;
  }

  @override
  void invoke(Map<String, dynamic> params, Completer<dynamic> completer) {
    invokeMethod?.call(params, completer);
  }
}
