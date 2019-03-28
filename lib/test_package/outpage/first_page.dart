import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_base_widget/base/_base_widget.dart';
import 'package:flutter_base_widget/network/bean/login_response_entity.dart';
import 'package:flutter_base_widget/network/requestUtil.dart';
import 'package:flutter_base_widget/test_package/outpage/second_page.dart';

class FirstPage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> getState() {
    // TODO: implement getState
    return _FirstPageState();
  }
}

class _FirstPageState extends BaseWidgetState<FirstPage> {
  @override
  Widget buildWidget(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("我是_MyFirstState，点击跳转去页面SecondPage"),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SecondPage()));
              },
            ),
            RaisedButton(
              child: Text("改变状态栏颜色"),
              onPressed: () {
                setTopBarBackColor(Colors.black);
              },
            ),
            RaisedButton(
              child: Text("隐藏状态栏"),
              onPressed: () {
                setTopBarVisible(false);
              },
            ),
            RaisedButton(
              child: Text("显示状态栏"),
              onPressed: () {
                setTopBarVisible(true);
              },
            ),
            RaisedButton(
              child: Text("改变导航栏背景颜色"),
              onPressed: () {
                setAppBarBackColor(Colors.white);
              },
            ),
            RaisedButton(
              child: Text("改变导航栏内容颜色"),
              onPressed: () {
                setAppBarContentColor(Colors.black);
              },
            ),
            RaisedButton(
              child: Text("显示导航栏"),
              onPressed: () {
                setAppBarVisible(true);
              },
            ),
            RaisedButton(
              child: Text("隐藏导航栏"),
              onPressed: () {
                setAppBarVisible(false);
              },
            ),
            RaisedButton(
              child: Text("改变大标题"),
              onPressed: () {
                setAppBarTitle("改变自己");
              },
            ),
            RaisedButton(
              child: Text("改变小标题"),
              onPressed: () {
                setAppBarRightTitle(""); //设置双引号就是 消失
              },
            ),
            RaisedButton(
              child: Text("显示错误页面"),
              onPressed: () {
                setErrorWidgetVisible(true);
              },
            ),
            RaisedButton(
              child: Text("显示空页面"),
              onPressed: () {
                setEmptyWidgetVisible(true);
              },
            ),
            RaisedButton(
              child: Text("设置空页面内容"),
              onPressed: () {
                setEmptyWidgetContent("暂无想要的内容~");
              },
            ),
            RaisedButton(
              child: Text("显示loading内容"),
              onPressed: () {
                setLoadingWidgetVisible(true);
              },
            ),
            RaisedButton(
              child: Text("模拟请求登录"),
              onPressed: () {
                requestLogin(0);
              },
            ),
          ],
        ),
      ),
    );
  }

  void requestLogin(int i) {
    RequestMap.requestLogin(null, this).listen((da) {
      List<LoginResponseResult> lists = da.results;
      for (int i = 0; i < lists.length; i++) {
        log(lists[i].icon);
      }
    }, onError: (err) {
      log("errrr----${err.toString()}----${i}");
    });
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
    log("onCreate");
  }

  @override
  void onPause() {
    // TODO: implement onPause
    log("onPause");
  }

  @override
  void onResume() {
    // TODO: implement onResume
    log("onResume");
  }
}
