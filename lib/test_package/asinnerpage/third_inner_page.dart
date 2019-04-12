import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_widget/base/base_inner_widget.dart';
import 'package:flutter_base_widget/network/bean/login_response_entity.dart';
import 'package:flutter_base_widget/network/intercept/noaction_intercept.dart';
import 'package:flutter_base_widget/network/intercept/showloading_intercept.dart';
import 'package:flutter_base_widget/network/requestUtil.dart';
import 'package:rxdart/rxdart.dart';

class ThirdInnerPage extends BaseInnerWidget {
  @override
  getState() {
    // TODO: implement getState
    return _MyThirdInnerPageState();
  }

  @override
  int setIndex() {
    // TODO: implement setIndex
    return 2;
  }
}

class _MyThirdInnerPageState extends BaseInnerWidgetState<ThirdInnerPage> {
  String _requestData = "";

  @override
  void onCreate() {
    // TODO: implement initOnceData
    log("onCreate");
    setAppBarVisible(true);
    setAppBarBackColor(Colors.green);
  }

  @override
  void onResume() {
    // TODO: implement initData
    log("onResume");
  }

  @override
  void onPause() {
    // TODO: implement onPause
    log("onPause");
  }

//  @override
//  // TODO: implement wantKeepAlive
//  bool get wantKeepAlive => true;

  ///重写此方法就把返回键去掉了
  @override
  Widget getAppBarLeft() {
    return Text("");
  }

  @override
  double getVerticalMargin() {
    // TODO: implement getVerticalMargin
    return getTopBarHeight() + getAppBarHeight() + 50;
  }

  @override
  Widget buildWidget(BuildContext context) {
    // TODO: implement buildWidget

    return Column(
      children: <Widget>[
        Text(""),
        RaisedButton(
          child: Text("模拟请求登录"),
          onPressed: () {
            requestLogin();
          },
        ),
        Text(_requestData),
        RaisedButton(
          child: Text("模拟错误请求"),
          onPressed: () {
            requestErrorRequest();
          },
        ),
      ],
    );
  }

  void requestLogin() {
    RequestMap.requestLogin(ShowLoadingIntercept(this)).listen((da) {
      List<LoginResponseResult> lists = da.results;
      String stringBuffer = "请求结果:\n"; //不推荐用+拼接字符串，这里只是展示
      for (int i = 0; i < lists.length; i++) {
        stringBuffer = stringBuffer + "\n" + lists[i].id;
      }
      setState(() {
        _requestData = stringBuffer;
        setErrorWidgetVisible(false);
      });
    }, onError: (err) {});
  }

  void requestErrorRequest() {
    RequestMap.testErrorrequest(ShowLoadingIntercept(this)).listen((data) {},
        onError: (err) {
      print(err.message);
      setErrorWidgetVisible(true);
    });
  }

  @override
  void onClickErrorWidget() {
    requestLogin();
    super.onClickErrorWidget();
  }
}
