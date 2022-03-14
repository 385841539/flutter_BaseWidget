import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common_plugin/base_lib.dart';

class BasePageTest extends StatefulWidget {
  @override
  _BasePageTestState createState() => _BasePageTestState();
}

class _BasePageTestState extends BaseListState<BasePageTest,BaseProvide> {
  @override
  List<Widget> getMainChildrenWidget(BuildContext context) {
    return [
      RaisedButton(
        onPressed: () {
          setTitle("你好");
        },
        child: Text("设置标题为:你好"),
      ),
      RaisedButton(
        onPressed: () {
          setNavBarLeftVisible(false);
        },
        child: Text("隐藏左边"),
      ),
      RaisedButton(
        onPressed: () {
          setNavBarLeftVisible(true);
        },
        child: Text("显示左边"),
      ),
      RaisedButton(
        onPressed: () {
          setNavLeftPadding(30);
        },
        child: Text("左边间距变为30"),
      ),
      RaisedButton(
        onPressed: () {
          setTitleVisible(false);
        },
        child: Text("隐藏标题"),
      ),
      RaisedButton(
        onPressed: () {
          setTitleVisible(true);
        },
        child: Text("显示标题"),
      ),
      RaisedButton(
        onPressed: () {
          setTitleSize(8);
        },
        child: Text("标题字体改为8"),
      ),
      RaisedButton(
        onPressed: () {
          setNavigationBarVisible(true);
        },
        child: Text("显示导航栏"),
      ),
      RaisedButton(
        onPressed: () {
          setNavigationBarVisible(false);
        },
        child: Text("隐藏导航栏"),
      ),
      RaisedButton(
        onPressed: () {
          setNavigationBarColor(Colors.yellow);
        },
        child: Text("导航栏颜色变为橘黄色"),
      ),
      RaisedButton(
        onPressed: () {
          setStatusBarVisible(true);
        },
        child: Text("显示状态栏"),
      ),
      RaisedButton(
        onPressed: () {
          setStatusBarVisible(false);
        },
        child: Text("隐藏状态栏"),
      ),
      RaisedButton(
        onPressed: () {
          setStatusBarColor(Colors.blueAccent);
        },
        child: Text("状态栏颜色变为蓝色"),
      ),
      FBAppBar(
        title: "测试",
        isHaveStatusBar: true,
        statusBarHeight: 25,
        navBarContentColor: Colors.white,
        navBarHeight: 50,
      ),
      SizedBox(
        height: 30,
      )
    ];
  }

  @override
  Widget getNavBarLeftWidget() {
    return super.getNavBarLeftWidget();
    // return Container(
    //   color: Colors.blue,
    //   child: Text("你好"),
    // );
  }

  @override
  Widget getNavBarRightWidget() {
    // TODO: implement getNavBarRightWidget
    return Container(
      child: Text("我是右边"),
    );
  }

  @override
  Widget getItem(BuildContext context, int index) {
    throw UnimplementedError();
  }

  @override
  int getItemCount() {
    throw UnimplementedError();
  }

  @override
  BaseProvide registerProvide() {
    // TODO: implement registerProvide
    throw UnimplementedError();
  }

}
