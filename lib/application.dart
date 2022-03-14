import 'package:flutter/cupertino.dart';
import 'package:flutter_base_lib/intercept.dart';
import 'package:flutter_base_lib/testmodule/test_module.dart';
import 'package:flutter_common_plugin/base_lib.dart';
import 'package:flutter_common_plugin/fb_module_center.dart';
import 'package:flutter_module_login/flutter_module_login.dart';

class FBApplication {
  ///需要上下文的初始化
  static void initWithContext(BuildContext context) {}

  ///无需上下文的初始化
  static  init() async{
    requestErr(FBError error) {
      print("网络全局监听错误---${error.toString()}");
    }

    FBSpUtils().init();
    FBHttpUtil.globalErrCallBack = requestErr;
    HttpConfig.baseUrl = "http://192.168.1.7:8080/";
    // HttpManger().setProxy("192.168.2.4:8881");
    HttpManger().addIntercept(ChatIntercept());
    HttpManger().setBadCertificateCallback((cert, host, port) => true);
    await FBDeviceUtils().initPlatInfo();
    _initModules();
  }

  ///注册 模块
  static void _initModules() {
    FBModuleCenter.registerModule(TestModule());
    FBModuleCenter.registerModule(LoginModule());
    //
    // WhContext.addRoute(WhModuelPage('测试首页', ["/"], (params) {
    //   return MyHomePage(
    //     title: "首页",
    //   );
    // }));
  }
}
