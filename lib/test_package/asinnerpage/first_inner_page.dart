import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_widget/base/base_inner_widget.dart';
import 'package:flutter_base_widget/test_package/asinnerpage/second_inner_page.dart';
import 'package:flutter_base_widget/test_package/outpage/first_page.dart';

class FirstInnerPage extends BaseInnerWidget {
  @override
  getState() {
    // TODO: implement getState
    return _MyFirstInnerState();
  }

  @override
  int setIndex() {
    // TODO: implement setIndex
    return 0;
  }
}

class _MyFirstInnerState extends BaseInnerWidgetState<FirstInnerPage> {
  @override
  void onCreate() {
    // TODO: implement initOnceData
    log("onCreate");
  }

  @override
  void onResumed() {
    // TODO: implement initData
    log("onResume");
  }

  @override
  void onPaused() {
    // TODO: implement onPause
    log("onPause");
  }

  @override
  double getVerticalMargin() {
    // TODO: implement getVerticalMargin
    return getTopBarHeight() + getAppBarHeight() + 50;
  }

  @override
  Widget buildWidget(BuildContext context) {
    // TODO: implement buildWidget
    return RaisedButton(
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => FirstPage()));
      },
      child: Text("我是内部页面，index是0\n点击会跳到下一级页面"),
    );
  }
}
