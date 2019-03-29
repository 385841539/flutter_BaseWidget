import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_base_widget/base/_base_widget.dart';

class ThirdPage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> getState() {
    // TODO: implement getState
    return _ThirdPageState();
  }
}

class _ThirdPageState extends BaseWidgetState<ThirdPage> {
  @override
  Widget buildWidget(BuildContext context) {
    // TODO: implement buildWidget
    return Column(
      children: <Widget>[
        RaisedButton(
          child: Text("我是ThirdPage页面，点击回到SecondPage"),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
    log("onCreate");
  }

  @override
  void onPause() {
    // TODO: implement onPause
    log("onPause");
  }

  @override
  void onResume() {
    // TODO: implement onResume
    log("onResume");
  }
}
