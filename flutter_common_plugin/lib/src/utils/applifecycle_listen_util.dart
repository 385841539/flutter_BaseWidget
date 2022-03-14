import 'package:flutter/material.dart';
import 'package:flutter_common_plugin/base_lib.dart';

///前后台监听类
class ApplicationLifeCycleUtil {
  static _AppLifeCycleListen _appLifeCycleListen;

  static List<AppLifecycleCallBack> _appLifecycleCallBacks=[];

  static void initListen() {
    if (_appLifeCycleListen != null) {
      print("----appLifeCycleListen--已经初始化过----");
    }
    if (_appLifeCycleListen == null) {
      _appLifeCycleListen = _AppLifeCycleListen();
      _appLifeCycleListen.init();
    }
  }

  static void disposeListen() {
    _appLifeCycleListen?.dispose();
  }

  ///添加监听到前台的方法
  static addLifeCycleCallBack(AppLifecycleCallBack callBack) {
    if (callBack != null) {
      _appLifecycleCallBacks.add(callBack);
    }
  }

  static removeLifeCycleCallBack(AppLifecycleCallBack callBack) {
    if (callBack != null && _appLifecycleCallBacks.contains(callBack)) {
      _appLifecycleCallBacks.remove(callBack);
    }
  }
}

class AppLifecycleCallBack {
  Function frontGroundCallBack;
  Function backGroundCallBack;

  AppLifecycleCallBack(this.frontGroundCallBack, this.backGroundCallBack);
}

///application 该 应用 容器生命周期
class _AppLifeCycleListen extends WidgetsBindingObserver {
  void init() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("-AppLifeCycleListen-didChangeAppLifecycleState--$state");
    if (state == AppLifecycleState.resumed) {
      ///application  可见

      AppConfig.isApplicationVisible = true;
      if (ApplicationLifeCycleUtil._appLifecycleCallBacks != null) {
        ApplicationLifeCycleUtil._appLifecycleCallBacks.forEach((element) {
          element?.frontGroundCallBack?.call();
        });
      }
    } else if (state == AppLifecycleState.paused) {
      AppConfig.isApplicationVisible = false;

      ///application  不可见
      ApplicationLifeCycleUtil._appLifecycleCallBacks.forEach((element) {
        element?.backGroundCallBack?.call();
      });
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this); //销毁
  }
}
