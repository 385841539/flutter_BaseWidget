import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_widget/route/router_application.dart';
import 'package:flutter_base_widget/route/routers.dart';
import 'package:flutter_base_widget/test_package/asinnerpage/TabBarBottomPageWidget.dart';
import 'package:flutter_base_widget/utils/sp_utils/sp_utils.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  MyApp() {
    final router = Router();

    Routes.configureRoutes(router);

    Application.router = router;
  }
  @override
  Widget build(BuildContext context) {
    SpUtils().init(); //初始化 sp
    return MaterialApp(
      onGenerateRoute: Application.router.generator,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: TabBarWidget(),
    );
  }
}
