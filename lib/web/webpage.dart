import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_base_widget/base/_base_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends BaseWidget {
  String url;

  WebViewPage(this.url);

  @override
  _WebViewPageState getState() => _WebViewPageState();
}

class _WebViewPageState extends BaseWidgetState<WebViewPage> {
  @override
  Widget buildWidget(BuildContext context) {
    // TODO: implement buildWidget
    return   new WebView(
      initialUrl: widget.url, // 加载的url
      onWebViewCreated: (WebViewController web) {
        // webview 创建调用，
        web.loadUrl(widget.url);
        web.canGoBack().then((res){
          print(res); // 是否能返回上一级
        });
        web.currentUrl().then((url){
          print(url);// 返回当前url
        });
        web.canGoForward().then((res){
          print(res); //是否能前进
        });
      },
      onPageFinished: (String value) {
        // webview 页面加载调用
      },
    );
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
  }

  @override
  void onPause() {
    // TODO: implement onPause
  }

  @override
  void onResume() {
    // TODO: implement onResume
  }

}
