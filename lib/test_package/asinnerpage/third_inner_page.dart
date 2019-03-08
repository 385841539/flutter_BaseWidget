import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_widget/base/base_inner_widget.dart';

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
    return Text("我是内部页面，index是2");
  }
}
