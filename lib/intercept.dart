import 'package:dio/dio.dart';
import 'package:flutter_common_plugin/base_lib.dart';
import 'package:flutter_module_login/chat/global/global_shared_info.dart';

class ChatIntercept extends Interceptor {
  @override
  Future onRequest(RequestOptions options) {
    if (StringUtils.isNotEmpty(GlobalSharedInfo.token)) {
      options.headers = {
        "Authorization": "bearer " + GlobalSharedInfo.token,
      };
    }

    return super.onRequest(options);
  }
}
