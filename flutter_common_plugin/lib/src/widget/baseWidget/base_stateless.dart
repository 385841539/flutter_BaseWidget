import 'package:flutter/cupertino.dart';
import 'package:flutter_common_plugin/base_lib.dart';
import 'package:flutter_common_plugin/fb_module_center.dart';
import 'package:flutter_common_plugin/src/utils/string_util/string_utils.dart';

import 'base_state_ui.dart';
import 'base_widget_lifecycle.dart';

// ignore: must_be_immutable
abstract class BaseStatelessWidget extends StatelessWidget
    with WidgetsBindingObserver, RouteAware, BaseWidgetLifeCycle, BasePageUI {
  final String pageTitle;

  BaseStatelessWidget({this.pageTitle = ""}) {
    setTitle(this.pageTitle);
  }

  @override
  Widget build(BuildContext context) {
    logePageCycle("build");

    if (!isBuild()) {
      setContext(context);
      _init();
    }
    return uiBuild(context);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    logePageCycle("didChangeAppLifecycleState");
    if (getContext() != null) {
      if (FBNavUtils.isCurrent(getContext())) {
        if (state == AppLifecycleState.resumed) {
          onResume();
        } else if (state == AppLifecycleState.paused) {
          onPause();
        } else if (state == AppLifecycleState.detached) {
          onDestroy();
        }
      }
    }
  }

  @override
  void didPop() {
    onDestroy();
  }

  @override
  void didPopNext() {
    onResume();
  }

  @override
  void didPush() {}

  @override
  void didPushNext() {
    onPause();
  }

  void _init() {
    _parserTitle();
    if (isListenLifeCycle()) {
      WidgetsBinding.instance.addObserver(this);
      routeObserver.subscribe(this, ModalRoute.of(getContext()));
    }
    onCreate();
  }

  void _parserTitle() {
    if (getContext() != null) {
      Object arguments = ModalRoute.of(getContext()).settings.arguments;
      if (arguments != null &&
          arguments is Map &&
          arguments.containsKey("pageTitle")) {
        if (StringUtils.isEmpty(getTitle()) &&
            getTitle() != arguments["pageTitle"]) {
          setTitle(arguments["pageTitle"]);
        }
      }
    }
  }

  BuildContext context;

  void setContext(BuildContext context) {
    this.context = context;
  }

  BuildContext getContext() {
    return context;
  }

  @mustCallSuper
  @override
  void onDestroy() {
    super.onDestroy();
    if (isListenLifeCycle()) {
      try {
        routeObserver.unsubscribe(this);
      } catch (e) {}
      WidgetsBinding.instance.removeObserver(this); //销毁
    }
    FBHttpUtil.cancelRequest(getContext());
  }
}
