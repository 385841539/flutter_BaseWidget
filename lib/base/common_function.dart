import 'package:flutter/material.dart';
import 'package:flutter_base_widget/dialog/loading_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// base 类 常用的一些工具类 ， 放在这里就可以了
class BaseFuntion {
  BuildContext contextBaseFunction;

  ///弹吐司
  void showToast(String content,
      {Toast length = Toast.LENGTH_SHORT,
      ToastGravity gravity = ToastGravity.BOTTOM,
      Color backColor = Colors.black54,
      Color textColor = Colors.white}) {
    if (content != null) {
      Fluttertoast.showToast(
          msg: content,
          toastLength: length,
          gravity: gravity,
          timeInSecForIos: 1,
          backgroundColor: backColor,
          textColor: textColor,
          fontSize: 13.0);
    }
  }

  ///弹对话框
  void showToastDialog(
    String message, {
    String title = "提示",
    String negativeText = "确定",
  }) {
    if (contextBaseFunction != null) {
      showDialog<Null>(
          context: contextBaseFunction, //BuildContext对象
          barrierDismissible: false,
          builder: (BuildContext context) {
            return new MessageDialog(
              title: title,
              negativeText: negativeText,
              message: message,
              onCloseEvent: () {
                Navigator.pop(context);
              },
            );
            //调用对话框);
          });
    }
  }
}
