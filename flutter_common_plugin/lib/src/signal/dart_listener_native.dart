import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_common_plugin/base_lib.dart';
import 'package:flutter_common_plugin/flutter_common_plugin.dart';


typedef NativeListener = Future Function(dynamic arguments);

/// 注册dart 方法 监听  ，原生 可以调到这里注册的 路由 方法
class NativeToDartService {
  static bool _isRegisterHandler = false;

  static Map<String, NativeListener> _dartListeners =
      Map<String, NativeListener>();

  ///注销该路由的监听
  static void removeListener(String protocol) {
    if (_dartListeners.containsKey(protocol)) {
      _dartListeners.remove(protocol);
    }
  }

  ///添加监听， 原生调protocol 会走到次监听 方式
  static void addListener(String protocol, NativeListener nativeListener) {
    if (StringUtils.isEmpty(protocol)) {
      if (AppConfig.isDebug) {
        print("空方法");
      }
      return;
    }
    _dartListeners[protocol] = nativeListener;

    if (!_isRegisterHandler) {
      FlutterCommonPlugin.setMethodCallHandler(_call);
      _isRegisterHandler = true;
    }
  }

  static Future _call(MethodCall call) {
    try {
      String method = call.method;

      if (method == null || !_dartListeners.containsKey(method)) {
        return Future.error({"code": -1, "message": "不存在此方法:${method ?? ""}"});
      }
      dynamic argument = call.arguments;

      NativeListener nativeListener = _dartListeners[method];

      return nativeListener(argument);
    } catch (e) {
      return Future.error(e);
    }
  }
}
