import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FBLauncher {
  ///通过系统 打开相关url
  ///FBLauncher.launcherUrl('botaoota://hybridBridgeV2?hybrid_host_path=https://baidu.com');
  //FBLauncher.launcherUrl('http://www.baidu.com');
  static Future<bool> launcherUrl(
    String url, {
    bool forceSafariVC,
    bool forceWebView,
    bool enableJavaScript,
    bool enableDomStorage,
    bool universalLinksOnly,
    Map<String, String> headers,
    Brightness statusBarBrightness,
    String webOnlyWindowName,
  }) {
    return launch(url,
        forceSafariVC: forceSafariVC,
        forceWebView: forceWebView,
        enableJavaScript: enableJavaScript,
        enableDomStorage: enableDomStorage,
        universalLinksOnly: universalLinksOnly,
        headers: headers,
        statusBarBrightness: statusBarBrightness,
        webOnlyWindowName: webOnlyWindowName);
  }
}
