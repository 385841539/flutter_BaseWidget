import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common_plugin/base_lib.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FBToastUtils {
  static void show(
    String msg, {
    Toast toastLength,
    int timeInSecForIos = 1,
    double fontSize = 16.0,
    ToastGravity gravity = ToastGravity.CENTER,
    Color backgroundColor,
    Color textColor,
    // Function(bool) didTap,
  }) {
    if (StringUtils.isEmpty(msg)) {
      return;
    }

    if (msg.toLowerCase().contains("nosuch") ||
        msg.toLowerCase().contains("null") ||
        msg.toLowerCase().contains("has")) {
      print("-过滤吐司--$msg");
      return;
    }
    Fluttertoast.showToast(
        msg: msg,
        toastLength: toastLength,
        timeInSecForIos: timeInSecForIos,
        fontSize: fontSize,
        gravity: gravity,
        backgroundColor: backgroundColor,
        textColor: textColor);
  }
}
