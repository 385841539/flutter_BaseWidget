import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_common_plugin/base_lib.dart';

class FBRequestBean<T> {
  BuildContext context;
  String url;
  FBResultFul requestMethod;
  dynamic params;
  Options options;
  ProgressCallback onSendProgress;
  ProgressCallback onReceiveProgress;
  CancelToken cancelToken;
  Function(T cacheData) cacheCallBack;
  String cacheTag;
  ///文件上传
  List<File> files;
  ///字节上传
  List<List<int>> multiData;
  String suffix;
  FBRequestBean.getRequestBean(
      this.context,
      this.url,
      this.requestMethod,
      this.params,
      this.options,
      this.onSendProgress,
      this.onReceiveProgress,
      this.cacheCallBack,
      this.cacheTag,this.files,this.multiData,this.suffix) {
    if (cacheCallBack != null && cacheTag == null && url != null) {
      cacheTag = url
          .replaceAll(HttpConfig.baseUrl ?? "", "")
          .replaceAll("http://", "")
          .replaceAll("https://", "");
    }

    if (cacheCallBack == null) {
      cacheTag = null;
    }
  }
}
