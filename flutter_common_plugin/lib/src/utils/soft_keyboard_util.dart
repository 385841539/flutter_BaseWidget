import 'package:flutter/cupertino.dart';
import 'package:flutter_common_plugin/base_lib.dart';

class SoftKeyBoardUtil {
  // FocusScope.of(context).unfocus(); //取消焦点

  static void unFocus(BuildContext context) {
    try {
      FocusScope.of(context).unfocus();
    } catch (e) {
      FBError.printError(e);
    }
  }

  ///获取的焦点
  static void focus(BuildContext context, FocusNode focusNode) {
    // FocusScope.of(context).autofocus(focusNode);
    try {
      FocusScope.of(context).requestFocus(focusNode);
    } catch (e) {
      FBError.printError(e);
    }
  }
}
