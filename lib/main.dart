import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_base_lib/flutter_application_recycle_listen.dart';
import 'package:flutter_base_lib/route/main_route_obser.dart';
import 'package:flutter_base_lib/testdialog/dialog_test_page.dart';

import 'package:flutter_common_plugin/base_lib.dart';
import 'package:flutter_common_plugin/fb_module_center.dart';

import 'api/test_api.dart';
import 'application.dart';
import 'test_enc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FBApplication.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  int i = 0;

  MyApp() {
    FlutterApplicationRecycleListen.custom();
    addDartLis();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MyHomePage.mContext = context;
    return MaterialApp(
      theme: ThemeData.light(),
      // showSemanticsDebugger: true,
      debugShowCheckedModeBanner: true,
      // debugShowMaterialGrid: true,
      routes: _buildMap(),
      navigatorObservers: [MainRoute(), routeObserver],
      onGenerateRoute: FBModuleCenter.generatorByRouteSetting,
      title: 'Flutter Demo',
      // home: Container(),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }

  Map<String, WidgetBuilder> _buildMap() {
    Map<String, WidgetBuilder> map = {};

    map["nihao"] = (BuildContext context) {
      // var nihao = ModalRoute.of(context).settings;
      return DialogTestPage();
    };

    return map;
  }

  void addDartLis() {
    NativeToDartService.addListener("nativeToDart://test/more_activity_listen",
        (arguments) async {
      print("---arguments---${arguments}---${i++}");
      return i;
    });
  }
}

class MyHomePage extends StatefulWidget {
  static BuildContext mContext;

  MyHomePage({this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends BaseListState<MyHomePage, BaseProvide> {
  @override
  void initState() {
    super.initState();
    print("---20%16-${20 % 16}-");
    print("---16%16-${16 % 16}-");
    print("---32%16-${32 % 16}-");
    TestEnc().enc();
    setNavBarLeftVisible(false);
    // HttpUtil.get();
    Future.delayed(Duration(seconds: 3), () {
      // setStatusBarHeight(150);    ///改变  状态栏高度

      // setStatusBarColor(Colors.blue);
      /// 隐藏显示状态栏
      // setStatusBarVisible(true);
      // setNavigationBarHeight(400);

      // setNavigationBarColor(Colors.amber);
      // setNavLeftPadding(50);
      // setNavigationBarColor(Colors.blue);
      // setBackgroundColor(Colors.green);

      // setStatusBarVisible(false);
      // setNavigationBarVisible(false);

      // setNavigationBarHeight(80);
      // setNavBarContentColor(Colors.blue);
      // setNavBarLeftVisible(false);

      // setNavBarLeftVisible(false);
      // setErrorWidgetVisible(true,
      //     errImgPath: "packages/flutter_common_plugin/images/ic_empty.png",
      //     errTextString: "不是的");
      // setStatusBarVisible(false);
      // setNavigationBarVisible(false);
      // setErrorImgPath("packages/flutter_common_plugin/images/ic_empty.png");
      // setTitleSize(19);
      //
      Future.delayed(Duration(seconds: 3), () {
        // setErrorWidgetVisible(false);
      });
      // setTitle("自己设置的");
    });
  }

  @override
  void onCreate() {
    setTitle("首 页");
    setTitleSize(20);
    // BaseStateConfig.globalNavigationBarContentColor=Colors.black87;
    // BaseStateConfig.globalNavigationBarBackgroundColor=Colors.blueAccent;
    // BaseStateConfig.globalStatusBarColor=Colors.green;
  }

  @override
  void onResume() {
    // TODO: implement onResume
    super.onResume();
    print("---首页--onResume---");
  }

  @override
  List<Widget> getMainChildrenWidget(BuildContext context) {
    FBScreenUtil().init(context);

    print("-getMainChildrenWidget-子-toString()}----");

    return [
      RaisedButton(
        onPressed: () {
          FBNavUtils.open(context, TestApi.routePage1,
              params: {"name": "testPage1"});
        },
        child: Text("去page1"),
      ),
      RaisedButton(
        onPressed: () {
          FBNavUtils.open(context, TestApi.routeSpUtils,
              params: {"name": "testPage1"});
        },
        child: Text("去SpUtils安全储存调试页"),
      ),
      RaisedButton(
        onPressed: () {
          ///链式调用
          FBHttpUtil.get<Map>(context, "v2/resignIn",
              requestLoading: LoadingDialog(
                context,
                text: "登录中。。。",
              ),
              transformer: FBParseTransform((result) => result),
              cacheCallBack: (cacheData) {
            print("-----cacheData---$cacheData--");
          }).then(((data) {
            print("${data.runtimeType}");
            print("data---$data--$data-");
            return FBHttpUtil.get<Map>(context, "v2/signIn/setting");
          })).then((value) {
            print("------value---$value");
          }).catchError((err) {
            print("----err--$err---");
          });
          // HttpUtil.cancelRequest(contextTag: context);
        },
        child: Text("请求网络"),
      ),
      RaisedButton(
        onPressed: () {
          FBNavUtils.open(context, TestApi.routeListTest);
        },
        child: Text("去列表测试页"),
      ),
      RaisedButton(
        onPressed: () {
          FBNavUtils.open(context, TestApi.routeDialogTest);
        },
        child: Text("去弹窗测试页"),
      ),
      RaisedButton(
        onPressed: () {
          FBNavUtils.open(context, TestApi.routBasePageTest);
        },
        child: Text("去基础页面功能测试页"),
      ),
      RaisedButton(
        onPressed: () {
          FBNavUtils.open(context, TestApi.statelessPage1,
              params: {"url": "http:///baidu.com"});
        },
        child: Text("跳转无状态页面测试页"),
      ),
      RaisedButton(
        onPressed: () {
          Future.delayed(Duration(seconds: 5), () {
            FBNavUtils.close(context);
          });
          //轮询的方法
          // Timer.periodic(Duration(seconds: 5), (timer) {
          // });
        },
        child: Text("点击，然后五秒钟后关闭当前页面"),
      ),
      RaisedButton(
        onPressed: () {
          Future.delayed(Duration(seconds: 5), () {
            FBNavUtils.open(context, TestApi.statelessPage1);
          });
        },
        child: Text("点击，然后五秒钟后跳转到Page1页面"),
      ),
      RaisedButton(
        onPressed: () {
          FBNavUtils.open(context, TestApi.testWebPage);
        },
        child: Text("去H5相关调试页"),
      ),
      RaisedButton(
        onPressed: () {
          DartToNative.requestNative("native://open_test1_activity");
        },
        child: Text("去原生调试页"),
      ),
      RaisedButton(
        onPressed: () {
          FBNavUtils.closeApp();
        },
        child: Text("关闭该application"),
      ),
      RaisedButton(
        onPressed: () {
          FBNavUtils.open(context, "testInterviewPage");
        },
        child: Text("面试题调试页"),
      ),
    ];
  }

  @override
  BaseProvide registerProvide() {
    // TODO: implement registerProvide
    throw UnimplementedError();
  }
}
