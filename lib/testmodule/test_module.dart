import 'package:flutter_base_lib/api/test_api.dart';
import 'package:flutter_base_lib/statelesstest/StatelessPage1.dart';
import 'package:flutter_base_lib/statelesstest/h5_test_page.dart';
import 'package:flutter_base_lib/testdialog/base_page_test.dart';
import 'package:flutter_base_lib/testdialog/dialog_test_page.dart';
import 'package:flutter_base_lib/testpage/list_page.dart';
import 'package:flutter_base_lib/testpage/page1.dart';
import 'package:flutter_base_lib/testpage/sp_test.dart';
import 'package:flutter_base_lib/testpage/text_image_page.dart';
import 'package:flutter_common_plugin/base_lib.dart';

import '../main.dart';

class TestModule extends FBBaseModule {
  @override
  String moduleName() {
    return "flutter_function://TestModule";
  }

  @override
  List<FBModuleChannel> registerModuleChannel() {
    return [];
  }

  @override
  List<FBModulePage> registerRoutes() {
    return [
      FBModulePage("首页", [TestApi.mainPage], (arguments) => MyHomePage()),
      FBModulePage("测试StatelessPage1", [TestApi.statelessPage1],
          (arguments) => StatelessPage1()),
      FBModulePage("文本和图片组合组件", [TestApi.textImageWidget],
          (arguments) => TextImagePage()),
      FBModulePage("H5调试页", [TestApi.testWebPage], (arguments) => H5TestPage()),
      FBModulePage("第一耶", [TestApi.routePage1], (arguments) => Page1()),
      // FBModulePage("第一耶", [TestApi.p2PDemo], (arguments) => P2PDemo(url: "",)),
      FBModulePage(
          "Sp调试页", [TestApi.routeSpUtils], (arguments) => SpUtilTestPage()),
      FBModulePage(
          "列表调试页", [TestApi.routeListTest], (arguments) => ListTestPage()),
      FBModulePage(
          "对话框调试", [TestApi.routeDialogTest], (arguments) => DialogTestPage()),
      FBModulePage(
          "基础组件调试", [TestApi.routBasePageTest], (arguments) => BasePageTest()),
    ];
  }
}
