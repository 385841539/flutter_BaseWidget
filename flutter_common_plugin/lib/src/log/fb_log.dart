import 'package:logger/logger.dart';

/// 打印任务栈信息
var logger = Logger(
  printer: PrettyPrinter(printEmojis: false),
);

/// 不打印任务栈信息
var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0, printEmojis: false),
);
