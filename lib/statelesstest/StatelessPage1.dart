import 'package:flutter/material.dart';
import 'package:flutter_base_lib/api/test_api.dart';
import 'package:flutter_common_plugin/base_lib.dart';

// ignore: must_be_immutable
class StatelessPage1 extends BaseStatelessWidget {
  @override
  Widget getMainWidget(BuildContext context) {
    return null;
  }

  @override
  List<Widget> getMainChildrenWidget(BuildContext context) {
    return [
      FlatButton(
          onPressed: () {
            FBNavUtils.open(context, TestApi.routePage1);
          },
          child: Text("跳转TestPage1"))
    ];
  }

  @override
  void onCreate() {
    super.onCreate();
    setTitle("我是无状态页面");
  }

}
