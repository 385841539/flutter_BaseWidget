import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_common_plugin/base_lib.dart';
import 'package:flutter_common_plugin/fb_module_center.dart';
import 'package:flutter_common_plugin/src/app/app_config.dart';
import 'package:flutter_common_plugin/src/provider/multi_base_provide.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../../base_lib.dart';
import '../../../base_lib.dart';
import 'base_state_ui.dart';
import 'base_widget_lifecycle.dart';

abstract class BaseState<T extends StatefulWidget, E extends BaseProvide>
    extends State<T>
    with BasePageUI, WidgetsBindingObserver, RouteAware, BaseWidgetLifeCycle {
  E provide;

  List<SingleChildWidget> _providers;
  List<SingleChildWidget> _lastProviders;

  SingleChildWidget _singleChildWidget;

  @override
  void initState() {
    super.initState();
    registerSetStateCalBack(() {
      if (mounted) {
        setState(() {});
      }
    });
    onCreate();
  }

  @override
  Widget build(BuildContext context) {
    if (!isBuild()) {
      _init();
    }

    ///model 注入逻辑
    if (_lastProviders == null) {
      if (provide == null) {
        try {
          provide = registerProvide();
          provide.baseState = this;
          provide.onCreate(getArguments());
        } catch (e, stackTrace) {
          if (e is UnimplementedError) {
          } else {
            FBError.printError(e, stackTrace);
          }
        }
      }
      if (provide != null) {
        if (_singleChildWidget == null) {
          _singleChildWidget = _getSingleChildWidget();
        }
      }
      if (_providers == null) {
        _providers = _getProviders();
      }

      _lastProviders = _getLastProviders();
    }

    return _lastProviders == null
        ? uiBuild(context)
        : MultiProvider(
            providers: _lastProviders, child: buildWithConsumer(context));
  }

  bool _isBuildWithConsumerFirst = true;

  Widget buildWithConsumer(BuildContext context) {
    try {
      return Consumer<E>(builder: (context, localModel, _) {
        // print("-Consumer--build---${runtimeType.toString()}--");
        if (_isBuildWithConsumerFirst) {
          _isBuildWithConsumerFirst = false;
          if (provide == null) {
            provide = localModel;
          }
          Future.microtask(() {
            try {
              provide?.requestData();
              provide?.isFirstRequestData = false;
            } catch (e) {}
          });
        }
        return super.uiBuild(context, model: provide);
      });
    } catch (e) {
      return uiBuild(context);
    }
  }

  @override
  void dispose() {
    _onDestroy();
    super.dispose();
  }

  void _onPause() {
    if (isInFront) {
      isInFront = false;
      provide?.onPause();

      onPause();
    }
  }

  void _onDestroy() {
    if (isListenLifeCycle()) {
      try {
        routeObserver.unsubscribe(this);
      } catch (e) {}
      try {
        Future.microtask(() {
          WidgetsBinding.instance.removeObserver(this); //销毁
        });
      } catch (e) {}
    }
    appBarControl?.dispose();
    provide?.dispose();
    FBHttpUtil.cancelRequest(context);
    onDestroy();
  }

  void _parserTitle() {
    try {
      Map arguments = getArguments();
      if (arguments != null && arguments.containsKey("pageTitle")) {
        if (getTitle() == null) {
          setTitle(arguments["pageTitle"]);
        }
      }
    } catch (e) {}
  }

  Object getArguments() {
    return ModalRoute.of(context).settings.arguments;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    try {
      if (mounted && FBNavUtils.isCurrent(context)) {
        if (state == AppLifecycleState.resumed) {
          _onResume();
        } else if (state == AppLifecycleState.paused ||
            state == AppLifecycleState.inactive) {
          _onPause();
        } else if (state == AppLifecycleState.detached) {
          _onDestroy();
          provide?.dispose();
        }
      }
    } catch (e, ts) {
      FBError.printError(e, ts);
    }
  }

  @override
  void didPop() {}

  @override
  void didPopNext() {
    _onResume();
  }

  void _onResume() {
    if (!isInFront) {
      isInFront = true;
      onResume();
      provide?.onResume();
    }
  }

  @override
  void didPush() {}

  @override
  void didPushNext() {
    _onPause();
  }

  void _init() {
    if (isListenLifeCycle()) {
      WidgetsBinding.instance.addObserver(this);
      try {
        routeObserver.subscribe(this, ModalRoute.of(context));
      } catch (e) {}
    }

    _parserTitle();
  }

  SingleChildWidget _getSingleChildWidget() {
    return ChangeNotifierProvider<E>(
      create: (_) {
        return _getModel();
      },
    );
  }

  ///多事件情况下的 provide注入 ，可以复写注入
  List<MultiBaseProvide> registerProviders() {
    return null;
  }

  List<SingleChildWidget> _getProviders() {
    List<MultiBaseProvide> providers = registerProviders();
    if (providers != null && providers.isNotEmpty) {
      return providers
          .map((e) => ChangeNotifierProvider<MultiBaseProvide>(
                create: (_) {
                  return e;
                },
              ))
          .toList();
    }

    return null;
  }

  void setNavBarScale(double offset) {
    appBarControl?.setOffsetScale?.value = offset;
  }

  /// 页面的主要provide， 自动和页面绑定的， 如果有多个model ， 其余model 可以通过[_getProviders] 绑定
  BaseProvide registerProvide();

  BaseProvide _getModel() {
    return provide;
  }

  ///如果返回不为空，则 使用 [MultiProvider]包裹所有布局
  List<SingleChildWidget> _getLastProviders() {
    if (_singleChildWidget == null && _providers == null) {
      return null;
    }

    List<SingleChildWidget> children = [];

    if (_singleChildWidget != null) {
      children.add(_singleChildWidget);
    }

    if (_providers != null) {
      children.addAll(_providers);
    }

    return children;
  }
}
