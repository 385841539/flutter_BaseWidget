import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_widget/base/NavigatorManger.dart';
import 'package:flutter_base_widget/base/common_function.dart';
import 'package:flutter_base_widget/network/api.dart';

abstract class BaseWidget extends StatefulWidget {
  BaseWidgetState baseWidgetState;
  @override
  BaseWidgetState createState() {
    baseWidgetState = getState();
    return baseWidgetState;
  }

  BaseWidgetState getState();
  String getStateName() {
    return baseWidgetState.getClassName();
  }
}

abstract class BaseWidgetState<T extends BaseWidget> extends State<T>
    with WidgetsBindingObserver, BaseFuntion {
  //平台信息
//  bool isAndroid = Platform.isAndroid;

  bool _onResumed = false; //页面展示标记
  bool _onPause = false; //页面暂停标记

  @override
  void initState() {
    NavigatorManger().addWidget(this);
    initBaseCommon(this, context);
    WidgetsBinding.instance.addObserver(this);
    onCreate();
    super.initState();
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
//    log("----buildbuild---deactivate");
    //说明是被覆盖了
    if (NavigatorManger().isSecondTop(this)) {
      if (!_onPause) {
        onPaused();
        _onPause = true;
      } else {
        onResumed();
        _onPause = false;
      }
    } else if (NavigatorManger().isTopPage(this)) {
      if (!_onPause) {
        onPaused();
      }
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
//    log("------buildbuild---build");
    if (!_onResumed) {
      //说明是 初次加载
      if (NavigatorManger().isTopPage(this)) {
        _onResumed = true;
        onResumed();
      }
    }
    return Scaffold(
      body: getBaseView(context),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    onDestory();
    WidgetsBinding.instance.removeObserver(this);
    _onResumed = false;
    _onPause = false;

    //把改页面 从 页面列表中 去除
    NavigatorManger().removeWidget(this);
    //取消网络请求
    HttpManager.cancelHttp(getClassName());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    //此处可以拓展 是不是从前台回到后台
    if (state == AppLifecycleState.resumed) {
      //on resume
      if (NavigatorManger().isTopPage(this)) {
        onForeground();
        onResumed();
      }
    } else if (state == AppLifecycleState.paused) {
      //onpause
      if (NavigatorManger().isTopPage(this)) {
        onBackground();
        onPaused();
      }
    }
    super.didChangeAppLifecycleState(state);
  }
}
