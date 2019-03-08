import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_base_widget/base/_base_widget.dart';
import 'package:flutter_base_widget/test_package/outpage/third_page.dart';

class SecondPage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> getState() {
    // TODO: implement getState
    return _SecondPageState();
  }
}

class _SecondPageState extends BaseWidgetState<SecondPage> {
  @override
  Widget buildWidget(BuildContext context) {
    // TODO: implement buildWidget
    return Column(
      children: <Widget>[
        RaisedButton(
          child: Text("我是SecondPage页面，去ThirdPage"),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => ThirdPage()));
          },
        ),
        RaisedButton(
          child: Text("点击回到FirstPage"),
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
