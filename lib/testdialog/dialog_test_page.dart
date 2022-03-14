import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_lib/api/test_api.dart';
import 'package:flutter_common_plugin/base_lib.dart';

import 'dialog_1.dart';
import 'dialog_2.dart';

class DialogTestPage extends StatefulWidget {
  @override
  _DialogTestPageState createState() => _DialogTestPageState();
}

class _DialogTestPageState extends BaseState<DialogTestPage,BaseProvide> {
  @override
  Widget getMainWidget(BuildContext context) {
    return null;
  }

  @override
  List<Widget> getMainChildrenWidget(BuildContext context) {
    return [
      FlatButton(
        onPressed: jumpDelayPage1,
        child: Text("点击延时10s跳转Page1"),
      ),
      FlatButton(
        onPressed: () {
          addDelayDialog(5);
        },
        child: Text("点击延时5s跳转弹窗2,弹窗层级为0"),
      ),
      FlatButton(
        onPressed: () {
          addDelayDialog(8);
        },
        child: Text("点击延时8s跳转弹窗2,弹窗层级为10"),
      ),
      RaisedButton(
        onPressed: () {
          DialogManger.showOrderDialog(
              FBOrderDialog1(
                  1, FBScreenUtil.getScreenWidth() - 100, Colors.blue),
              context);
        },
        child: Text("立马弹窗弹窗1，弹窗层级为1"),
      ),
    ];
  }

  void addDelayDialog(int zIndex) {
    Future.delayed(Duration(seconds: 15), () {
      DialogManger.showOrderDialog(
          FBOrderDialog2(1, FBScreenUtil.getScreenWidth(), Colors.blue, zIndex),
          context,
          isOnBackCancel: false,
          isOuSideCancel: false,
          zIndex: zIndex);
    });
  }

  void jumpDelayPage1() {
    Future.delayed(Duration(seconds: 10), () {
      FBNavUtils.open(context, TestApi.routePage1,
          params: {"name": "testPage1"});
    });
  }

  @override
  BaseProvide registerProvide() {
    // TODO: implement registerProvide
    throw UnimplementedError();
  }

}
