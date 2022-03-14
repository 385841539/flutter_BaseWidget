
import 'package:flutter/material.dart';

import '../../base_lib.dart';
import '../widget/baseWidget/base_state.dart';
import 'base_event.dart';

///多事件的 事件抽象基类，同时起到占位作用
class MultiBaseProvide extends ChangeNotifier {
  ///默认的签名方式
  BaseState baseState;

  BuildContext get context => baseState?.context;

  ///是否销毁
  bool _disposed = false;

  ///是否已经销毁
  bool get hasDisposed => _disposed;

  Future<T> dispatch<T>(BaseEvent baseEvent, {bool needRefresh = true}) async {
    baseEvent.provide = this;
    T ret;
    try {
      ret = await baseEvent.eventExecute();
    } catch (error, stackTrace) {
      FBError.printError(error, stackTrace);
    }
    if (needRefresh = true) {
      notifyListeners();
    }

    return ret;
  }

  @override
  void dispose() {
    if (!hasDisposed) {
      _disposed = true;
      super.dispose();
    }
  }

  @override
  void notifyListeners() {
    if (!hasDisposed) {
      super.notifyListeners();
    }
  }
}
