import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';

class DemoScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new DemoScreenState();
  }
}


class DemoScreenState extends State<DemoScreen> {
  InAppWebViewController webView;
  String url = "";
  double progress = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('h5交互',style:TextStyle(fontSize: 17)),
        centerTitle: true,

      ),
      body: Column(children: <Widget>[
        Container(
          padding: EdgeInsets.all(20.0),
          child: Text(
              "CURRENT URL\n${(url.length > 50) ? url.substring(0, 50) + "..." : url}"),
        ),
        Container(
            padding: EdgeInsets.all(10.0),
            child: progress < 1.0 ? LinearProgressIndicator(value: progress) : null
        ),
        Expanded(
          child: InAppWebView(
            initialFile: "assets/demo.html",
            initialHeaders: {},
            initialOptions: {
              //"useShouldOverrideUrlLoading": true,
              //"useOnLoadResource": true
            },
            onWebViewCreated: (InAppWebViewController controller) {
              webView = controller;

              webView.addJavaScriptHandler('test', (args) {
                print("收到来自web的消息"+args.toString());
              });

              webView.addJavaScriptHandler('handlerFooWithArgs', (args) {
                print(args);
                return [args[0] + 5, !args[1], args[2][0], args[3]['foo']];
              });
            },
            onLoadStart: (InAppWebViewController controller, String url) {
              print("started $url");
              setState(() {
                this.url = url;
              });
            },
            onLoadStop: (InAppWebViewController controller, String url) async {
              print("stopped $url");
            },
            onProgressChanged:
                (InAppWebViewController controller, int progress) {
              setState(() {
                this.progress = progress / 100;
              });
            },
            shouldOverrideUrlLoading: (InAppWebViewController controller, String url) {
              print("override $url");
              controller.loadUrl(url);
            },
            onLoadResource: (InAppWebViewController controller, WebResourceResponse response, WebResourceRequest request) {
              print("Started at: " +
                  response.startTime.toString() +
                  "ms ---> duration: " +
                  response.duration.toString() +
                  "ms " +
                  response.url);
            },
            onConsoleMessage: (InAppWebViewController controller, ConsoleMessage consoleMessage) {
              print("""
              console output:
                sourceURL: ${consoleMessage.sourceURL}
                lineNumber: ${consoleMessage.lineNumber}
                message: ${consoleMessage.message}
                messageLevel: ${consoleMessage.messageLevel}
              """);
            },
          ),
        ),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('修改h5样式'),
              onPressed: () {
                if (webView != null) {
                  webView.injectScriptCode('''
                    document.body.style.backgroundColor = 'green';
                  ''');
                }
              },
            ),
            RaisedButton(
              child: Text('发送消息给h5'),
              onPressed: () {
                if (webView != null) {
                  webView.injectScriptCode("window.appSendJs('hello')");
                }
              },
            ),
            RaisedButton(
              child: Icon(Icons.refresh),
              onPressed: () {
                if (webView != null) {
                  webView.reload();
                }
              },
            ),
          ],
        ),
      ]),

    );
  }
}
