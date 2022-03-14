///自定义等待加载提示框
import 'package:flutter/material.dart';
import 'package:flutter_common_plugin/base_lib.dart';
import 'package:flutter_common_plugin/src/network/loading/progress_text.dart';

// ignore: must_be_immutable
class LoadingDialog extends Dialog with RequestLoading {
  final String text;
  final BuildContext context;
  bool _isShowing = false;
  final ValueNotifier<String> progressChange;

  LoadingDialog(
    this.context, {
    Key key,
    this.text = "请稍等...",
    this.progressChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // this.context = context;
    return new Material(
      type: MaterialType.transparency,
      child: WillPopScope(
        child: new Center(
          child: new SizedBox(
            width: 120.0,
            height: 120.0,
            child: new Container(
              decoration: ShapeDecoration(
                color: Color(0xffffffff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new CircularProgressIndicator(),
                  new Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                    ),
                    child: FBProgressText(
                        text: text, progressChange: progressChange),
                  ),
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async {
          finishListener?.call();
          _isShowing = false;
          return true;
        },
      ),
    );
  }

  @override
  void afterRequest() {
    if (_isShowing ?? false) {
      Navigator.pop(context);
      _isShowing = false;
    }
  }

  @override
  void beforeRequest() {
    if (!_isShowing) {
      _isShowing = true;
      try {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return this;
            }).catchError((e) {});
      } catch (e) {}
    }
  }
}
