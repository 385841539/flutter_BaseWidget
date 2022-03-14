import 'package:flutter/material.dart';

class FlutterApplicationRecycleListen with WidgetsBindingObserver {
  FlutterApplicationRecycleListen.custom() {
    ///创建了 ， 注入
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // logePageCycle("--didChangeAppLifecycleState--$state");

    if (state == AppLifecycleState.resumed) {
      print("---AppLifecycleState.resumed--${AppLifecycleState.resumed}");
    } else if (state == AppLifecycleState.paused) {
      print("----AppLifecycleState.paused--${AppLifecycleState.paused}");
    } else if (state == AppLifecycleState.detached) {
      print("---AppLifecycleState.detached--${AppLifecycleState.detached}");
    }
  }

  ///注销了 销毁监听
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); //销毁
  }
}
