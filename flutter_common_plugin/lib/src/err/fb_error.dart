import 'package:flutter_common_plugin/src/log/fb_log.dart';

class FBError {
  int code;
  String message;
  String errorUrl;

  bool isBusinessErr;

  FBError(this.code, this.message, {this.isBusinessErr = false,this.errorUrl});

  @override
  String toString() {
    return message ?? "";
  }

  /// 打印自定义异常
  static void printError([e, StackTrace stackTrace]) {
    String errorMessage;
    if (stackTrace != null) {
      errorMessage =
          '已捕获错误任务栈信息 \n${e.toString()} \n\n${stackTrace?.toString() ?? ''}';
    } else {
      errorMessage = '已捕获错误任务栈信息 \n${e.toString()}';
    }
    logger.w(errorMessage);
  }

  /// 打印自定义异常
  static void uncaughtError(e, StackTrace stackTrace) {
    String errorMessage;
    if (stackTrace != null) {
      errorMessage = '未捕获错误任务栈信息 \n${stackTrace?.toString() ?? ''}';
    } else {
      errorMessage = '未捕获错误任务栈信息 \n${e.toString()}';
    }
    loggerNoStack.e(errorMessage);
  }
}
