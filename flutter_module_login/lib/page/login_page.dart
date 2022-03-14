import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_common_plugin/base_lib.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends BaseState<LoginPage,BaseProvide> {
  @override
  void onCreate() {
    FBChannelUtils.registerChannel(
        FBModuleChannelModel("flutter_function://requestLoginRegister", (params, future) {
      print("-channel://requestLoginRegister-params--$params");
      Future.delayed(Duration(seconds: 3), () {
        future.complete("收到登录临时注册请求");
      });
    }));
  }

  @override
  Widget getMainWidget(BuildContext context) {
    return Text("我是登录页");
  }

  @override
  List<Widget> getMainChildrenWidget(BuildContext context) {
    // TODO: implement getMainChildrenWidget
    throw UnimplementedError();
  }

  @override
  BaseProvide registerProvide() {
    // TODO: implement registerProvide
    throw UnimplementedError();
  }
}
