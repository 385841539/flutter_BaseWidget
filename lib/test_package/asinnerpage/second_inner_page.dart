import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_widget/base/base_inner_widget.dart';
import 'package:flutter_base_widget/test_package/asinnerpage/third_inner_page.dart';

class SecondInnerPage extends BaseInnerWidget {
  @override
  getState() {
    // TODO: implement getState
    return _MyInnerSecondState();
  }

  @override
  int setIndex() {
    // TODO: implement setIndex
    return 1;
  }
}

class _MyInnerSecondState extends BaseInnerWidgetState<SecondInnerPage> {
  @override
  Widget buildWidget(BuildContext context) {
    // TODO: implement buildWidget
    return Text("我是内部页面，index是1");
  }

  @override
  void onCreate() {
    // TODO: implement initOnceData
    log("onCreate");
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

  @override
  double getVerticalMargin() {
    // TODO: implement getVerticalMargin
    return getTopBarHeight() + getAppBarHeight() + 50;
  }
}
