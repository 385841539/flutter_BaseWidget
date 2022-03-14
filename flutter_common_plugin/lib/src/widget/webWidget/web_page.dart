import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common_plugin/base_lib.dart';
import 'package:flutter_common_plugin/fb_module_center.dart';
import 'package:flutter_common_plugin/src/utils/string_util/string_utils.dart';
import 'package:flutter_common_plugin/src/widget/webWidget/web_config.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'web_page_default_channel_protocol.dart';

class WebPage extends StatefulWidget {
  final String url;
  final String title;
  final bool useDefaultConfig;

  ///params 中可以有 导航栏配置参数
  ///[isNavigationBarVisible]  true的话 可见 ， false 的话 ， 我导航栏
  final Map<String, dynamic> params;

  WebPage(this.url, this.title, this.useDefaultConfig, {this.params});

  @override
  _WebPageState createState() => _WebPageState(url, params: params);
}

/// 参考[https://www.jianshu.com/p/4aabe453eb26]
class _WebPageState extends BaseState<WebPage, BaseProvide> {
  String url;

  final Map<String, dynamic> params;

  WebViewController _controller;

  LoadingDialog loading;

  bool isLoading = false;

  _WebPageState(this.url, {this.params}) {
    if (params != null) {
      if (params.containsKey("isNavigationBarVisible")) {
        setNavigationBarVisible(
            BoolTransformUtil.transform((params["isNavigationBarVisible"])));
      }
    }
  }

  @override
  void onCreate() {
    setLoadingWidgetVisible(true);
    setTitle(widget.title ?? "");
    addJsSet();
    if ((!widget.useDefaultConfig) ?? false) {
      setNavBarCenterPosition(-1);
      setNavigationBarHeight(kToolbarHeight);
      setTitleSize(20);
    }
  }

  @override
  Widget getMainWidget(BuildContext context) {
    return getWebWidget();
  }

  @override
  List<Widget> getMainChildrenWidget(BuildContext context) {
    return [
      Expanded(
        child: getWebWidget(),
      )
    ];
  }

  void _initControl(WebViewController controller) {
    _controller = controller;
  }

  @override
  Future<bool> onBackClick() async {
    if (isLoading) {
      setLoadingWidgetVisible(false);
    }
    if (this._controller != null) {
      bool canGoBack = await _controller.canGoBack().catchError((e) {
        return super.onBackClick();
      });
      if (canGoBack) {
        _controller.goBack();
        return false;
      } else {
        return super.onBackClick();
      }
    } else {
      return super.onBackClick();
    }
  }

  Future<bool> _onBackKeyDown() async {
    return onBackClick();
  }

  Widget getWebWidget() {
    return WillPopScope(
      child: WebView(
        ///webview参考博文 https://www.jianshu.com/p/4aabe453eb26
        initialUrl: url,
        //JS执行模式 是否允许JS执行
        javascriptMode: JavascriptMode.unrestricted,
        onPageFinished: (url) {
          print("---finish---$url");
          _parseTitle();
          setLoadingWidgetVisible(false);
        },
        onPageStarted: (url) {
          setLoadingWidgetVisible(true);
        },
        onWebResourceError: _parserErr,
        navigationDelegate: (NavigationRequest request) {
          print("-open--url--${request.url}");
          //对于需要拦截的操作 做判断

          if (UrlUtils.isHttpUrl(request.url)) {
            //不需要拦截的操作
            return NavigationDecision.navigate;
          } else {
            if (FBModuleCenter.isFlutterRoute(request.url)) {
              FBNavUtils.open(context, request.url);
            }
            return NavigationDecision.prevent;
          }
        },

        javascriptChannels: _generateChannel(),
        onWebViewCreated: (controller) {
          _initControl(controller);
        },
      ),
      onWillPop: _onBackKeyDown,
    );
  }

  void _parseTitle() {
    _controller.evaluateJavascript("document.title").then((result) {
      if (StringUtils.isNotEmpty(result) && result != "\"\"") {
        try {
          if (result.startsWith("\"")) {
            result = result.substring(1);
            print("---${result.endsWith("\"")}");
          }
          if (result.endsWith("\"")) {
            result = result.substring(0, result.length - 1);
          }
        } catch (e) {
          print("---$e");
        }
        if (StringUtils.isEmpty(widget.title) && result.length < 8) {
          setTitle(result);
        }
      }
    });
  }

  void setLoadingWidgetVisible(bool bool) {
    loadingDialog() {
      if (loading == null) {
        loading = LoadingDialog(
          context,
          text: "加载中...",
        );
      }
      if (bool ?? false) {
        isLoading = true;
        loading?.beforeRequest();
      } else {
        isLoading = false;
        loading?.afterRequest();
      }
    }

    if (isBuild()) {
      loadingDialog();
    } else {
      Timer.run(loadingDialog);
    }
  }

  void addJsSet() {
    // WebConfig.addJavascriptChannel();
  }

  void _parserErr(WebResourceError error) {
    setLoadingWidgetVisible(false);
  }

  @override
  BaseProvide registerProvide() {
    return null;
  }

  JavascriptChannel _getLocalChannel() {
    return JavascriptChannel(
        name: "fbFlutter",
        onMessageReceived: (JavascriptMessage message) {
          print("参数： ${message.message}");

          try {
            _parseChannel(ChannelModel.fromJson(json.decode(message.message)));

            // if (message.message == "closePage") {
            //   FBNavUtils.close(context);
            // }
          } catch (e) {}

          // String callBackName = message.message; //实际应用中要通过map通过key获取
          // String data = "收到消息调用了";
          // String script = "$callBackName($data)";
          // _controller.evaluateJavascript(script);
        });
  }

  _generateChannel() {
    Set<JavascriptChannel> _jsSet = Set();
    _jsSet.addAll(WebConfig.jsSet);
    _jsSet.add(_getLocalChannel());

    return _jsSet;
  }

  void _parseChannel(ChannelModel channelModel) {
    if (channelModel.route == closeH5Protocol) {
      FBNavUtils.close(context, result: channelModel.params);
    } else {
      FBNavUtils.open(context, channelModel.route, params: channelModel.params);
    }
  }
}
