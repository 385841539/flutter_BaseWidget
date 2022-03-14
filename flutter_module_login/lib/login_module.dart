import 'package:flutter_common_plugin/base_lib.dart';
import 'package:flutter_module_login/page/bloc_page.dart';
import 'package:flutter_module_login/page/device_info_widget_page.dart';
import 'package:flutter_module_login/page/interview/interview_page.dart';
import 'package:flutter_module_login/page/interview/three_tree_page.dart';
import 'package:flutter_module_login/page/testRadiusBtnPage.dart';
import 'chat/chat_page.dart';
import 'page/login_page.dart';

class LoginModule extends FBBaseModule {
  @override
  String moduleName() {
    return "LoginModule";
  }

  @override
  List<FBModuleChannel> registerModuleChannel() {
    return [
      FBModuleChannelModel("flutter_function://requestLogin", (params, future) {
        print("--params--$params");
        Future.delayed(Duration(seconds: 3), () {
          future.complete("收到登录请求");
        });
      }),
    ];
  }

  @override
  List<FBModulePage> registerRoutes() {
    return [
      FBModulePage("登录页", ["loginModulePage"], (params) => LoginPage()),
      FBModulePage("聊天入口页", ["testEntryPage"], (params) => ChatPage()),
      FBModulePage("三棵树关系", ["threeTreeTest"], (params) => ThreeTreeTestPage()),
      FBModulePage("blocTest", ["blocTest"], (params) => BlocCounterTestPage()),
      FBModulePage("面试题检测页", ["testInterviewPage"], (params) => InterViewPage()),
      FBModulePage(
          "选择框调试页", ["testRadiusBtnPage"], (params) => TestRadiusBtnPage()),
      FBModulePage("设备信息页", ["tesDeviceInfoRoute"],
              (params) => DeviceInfoWidgetPage()),
    ];
  }
}
