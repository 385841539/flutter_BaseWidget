import 'package:flutter/material.dart';
import 'package:flutter_common_plugin/base_lib.dart';

class JKMessageDialog extends FBBaseDialog {
  final VoidCallback confirmLisenter;
  final VoidCallback cancelLisenter;
  final String title;
  final String message;
  final String cancelText;
  final String confirmText;
  final bool isIosStyle;
  final double radius;

  final int zIndex;

  JKMessageDialog(
    BuildContext context, {
    this.title = "温馨提示",
    this.message,
    this.cancelText = "取消",
    this.confirmText = "确定",
    this.zIndex = 0,
    this.radius = 14,
    bool isCanBack = true,
    bool outsideCancel = false,
    this.isIosStyle = true,
    this.confirmLisenter,
    this.cancelLisenter,
  }) : super(
          context,
          outsideCancel: outsideCancel,
          backCancel: isCanBack,
          radius: isIosStyle ? 14 : radius,
          backgroundColor: isIosStyle ? Color(0XFFDBDBDB) : null,
          isIosStyle: isIosStyle,
          zIndex: 0,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.all(Radius.circular(24)),
      //     color: Colors.red),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Column(
              children: <Widget>[
                StringUtils.isNotEmpty(title)
                    ? Container(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, bottom: 8.5, top: 4),
                        child: Text(title ?? "",
                            style: TextStyle(
                                color: isIosStyle
                                    ? Color(0XFF000000)
                                    : Color(0XFF000000),
                                fontSize: 17,
                                fontWeight: isIosStyle
                                    ? FontWeight.bold
                                    : FontWeight.w500)),
                      )
                    : Container(),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: Text(message ?? "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: isIosStyle
                              ? Color(0XFF000000)
                              : Color(0XFF666666),
                          fontSize: 14,
                          fontWeight: isIosStyle
                              ? FontWeight.w500
                              : FontWeight.normal)),
                ),
              ],
            ),
          ),
          FBDialogButtons(
            cancelText: cancelText == null
                ? null
                : Text(cancelText ?? "取消",
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0XFF007AFF),
                        fontWeight:
                            isIosStyle ? FontWeight.bold : FontWeight.normal)),
            cancelLisenter: () {
              if (cancelLisenter == null) {
                dismiss();
              } else {
                cancelLisenter();
              }
            },
            confirmText: confirmText == null
                ? null
                : Text(
                    confirmText ?? "确定",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight:
                            isIosStyle ? FontWeight.bold : FontWeight.normal),
                  ),
            confirmLisenter: confirmLisenter == null
                ? () {
                    dismiss();
                  }
                : confirmLisenter,
          )
        ],
      ),
    );
  }
}
