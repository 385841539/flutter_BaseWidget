import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_widget/base/base_inner_widget.dart';
import 'package:flutter_base_widget/dialog/message_dialog.dart';
import 'package:flutter_base_widget/test_package/asinnerpage/third_inner_page.dart';
import 'package:flutter_base_widget/utils/constant.dart';
import 'package:flutter_base_widget/utils/sp_utils.dart';

class SecondInnerPage extends BaseInnerWidget {
  @override
  getState() {
    // TODO: implement getState
    return _MyInnerSecondState();
  }

  @override
  int setIndex() {
    // TODO: implement setIndex
    return 1;
  }
}

class _MyInnerSecondState extends BaseInnerWidgetState<SecondInnerPage> {
  String _name = "";

  @override
  Widget buildWidget(BuildContext context) {
    // TODO: implement buildWidget
    return Column(
      children: <Widget>[
        Text("我是内部页面，index是1"),
        TextField(
          onChanged: (content) {
            _name = content;
          },
          autofocus: false,
        ),
        RaisedButton(
          child: Text("存数据"),
          onPressed: () {
            SpUtils().put(SpConstanst.PHONE_NUMBER, _name);
          },
        ),
        RaisedButton(
          child: Text("读数据"),
          onPressed: () {
            showToastDialog(SpUtils().getString(SpConstanst.PHONE_NUMBER));
          },
        ),
        RaisedButton(
          child: Text("点击弹出吐司"),
          onPressed: () {
            showToast("来自闯过五千年的伤~");
          },
        ),
        RaisedButton(
          child: Text("点击弹出对话框"),
          onPressed: () {
            showToastDialog("这是一个很寂寞的夜 ，下着 有些伤心的雨 ~ ");
          },
        ),
      ],
    );
  }

  @override
  void onCreate() {
    // TODO: implement initOnceData
    log("onCreate");
  }

  @override
  void onResume() {
    // TODO: implement initData
    log("onResume");
  }

  @override
  void onPause() {
    // TODO: implement onPause
    log("onPause");
  }

  @override
  double getVerticalMargin() {
    // TODO: implement getVerticalMargin
    return getTopBarHeight() + getAppBarHeight() + 50;
  }
}
