
import 'package:dio/dio.dart';
import 'package:flutter_common_plugin/base_lib.dart';

/// 不处理类型装换
class FBOriginalTransformer extends ResponseTransform {
  @override
  transformData<T>(String data) {
    // return null;
    return data;
  }

}
