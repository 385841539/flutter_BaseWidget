import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_widget/base/base_inner_widget.dart';
import 'package:flutter_base_widget/network/bean/login_response_entity.dart';
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
            requestLogin(1);
          },
        ),
        RaisedButton(
          child: Text("模拟错误请求"),
          onPressed: () {
            requestErrorRequest();
          },
        ),
      ],
    );
  }

  void requestLogin(int i) {
    RequestMap.requestLogin().listen((da) {
      List<LoginResponseResult> lists = da.results;
      for (int i = 0; i < lists.length; i++) {
        print(lists[i].icon);
      }
    }, onError: (err) {
      print("errrr----${err.toString()}----${i}");
    });
  }

  void requestErrorRequest() {
    RequestMap.testErrorrequest(this).listen((data) {}, onError: (err) {
      print(err.message);
      setErrorWidgetVisible(true);
    });
  }
}
