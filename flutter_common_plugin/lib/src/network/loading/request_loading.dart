import 'package:flutter/cupertino.dart';

abstract class RequestLoading {
  VoidCallback finishListener;
  ///是否触发了 未显示 标记位
  bool isRunShow = true;
  ///是否检验 请求时 100ms内只能发起一个loading
  bool isCheckDoubleLoading = true;

  void setFinishListener(VoidCallback finishListener) {
    this.finishListener = finishListener;
  }

  void beforeRequest();

  void afterRequest();
}
