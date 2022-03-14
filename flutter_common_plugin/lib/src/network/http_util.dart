import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_common_plugin/base_lib.dart';
import 'package:flutter_common_plugin/src/network/bean/request_bean.dart';
import 'package:flutter_common_plugin/src/network/transform/base_transform.dart';

import 'bean/retry_bean.dart';
import 'http_config.dart';
import 'loading/request_loading.dart';
import 'transform/fb_map_transformer.dart';

typedef GlobalErrCallBack = void Function(FBError error);

class FBHttpUtil {
  ///网络请求发生错误时 ， 暴露全局统一处理方法，比如 和后端约定 某种code 就吐司提示、日志搜集等 处理可在这里
  static GlobalErrCallBack globalErrCallBack;

  static Future<T> post<T>(BuildContext context, String url,
      {dynamic params,
      ResponseTransform transformer,
      RequestLoading requestLoading,
      Options options,
      ProgressCallback onSendProgress,
      ProgressCallback onReceiveProgress,
      Retry retry,
      Function(T cacheData) cacheCallBack,
      String cacheTag,
      List<File> files,

      ///传输文件 时 需要传入后缀名
      String suffix,
      List<List<int>> multiData}) async {
    return await _request<T>(context, url,
        requestMethod: FBResultFul.POST,
        requestLoading: requestLoading,
        params: params,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        transformer: transformer,
        retry: retry,
        cacheCallBack: cacheCallBack,
        cacheTag: cacheTag,
        files: files,
        multiData: multiData,
        suffix: suffix);
  }

  static Future<T> get<T>(BuildContext context, String url,
      {Map<String, dynamic> params,
      RequestLoading requestLoading,
      ResponseTransform transformer,
      Options options,
      ProgressCallback onReceiveProgress,
      Retry retry,
      Function(T cacheData) cacheCallBack,
      String cacheTag}) async {
    return await _request<T>(context, url,
        requestMethod: FBResultFul.GET,
        params: params,
        transformer: transformer,
        requestLoading: requestLoading,
        options: options,
        onReceiveProgress: onReceiveProgress,
        retry: retry,
        cacheCallBack: cacheCallBack,
        cacheTag: cacheTag);
  }

  static Future<T> request<T>(
      BuildContext context, String url, FBResultFul requestMethod,
      {Map<String, dynamic> params,
      RequestLoading requestLoading,
      ResponseTransform transformer,
      Options options,
      ProgressCallback onReceiveProgress,
      Retry retry,
      Function(T cacheData) cacheCallBack,
      String cacheTag}) async {
    return await _request<T>(context, url,
        requestMethod: requestMethod,
        params: params,
        transformer: transformer,
        requestLoading: requestLoading,
        options: options,
        onReceiveProgress: onReceiveProgress,
        retry: retry,
        cacheCallBack: cacheCallBack,
        cacheTag: cacheTag);
  }

  static int _lastLoadingTime = 0;

  static Future _request<T>(BuildContext context, String url,
      {FBResultFul requestMethod,
      dynamic params,
      Options options,
      ProgressCallback onSendProgress,
      ProgressCallback onReceiveProgress,
      RequestLoading requestLoading,
      ResponseTransform transformer,
      Retry retry,
      Function(T cacheData) cacheCallBack,
      String cacheTag,
      List<File> files,
      List<List<int>> multiData,
      String suffix}) async {
    if (transformer == null) {
      transformer = FBMapTransformer();
    }

    FBRequestBean<T> fbRequestBean = FBRequestBean<T>.getRequestBean(
        context,
        url,
        requestMethod,
        params,
        options,
        onSendProgress,
        onReceiveProgress,
        cacheCallBack,
        cacheTag,
        files,
        multiData,
        suffix);

    Completer<T> completer = new Completer<T>();

    if (requestLoading != null && requestLoading.isCheckDoubleLoading) {
      // print(
      //     "DateUtil.getNowDateMs() - _lastLoadingTime---${DateUtil.getNowDateMs() - _lastLoadingTime}");
      int _thisLoadingTime = DateUtil.getNowDateMs();
      if ((_thisLoadingTime - _lastLoadingTime) > 100) {
        _lastLoadingTime = _thisLoadingTime;

        ///100ms 只能发起一次loading
        requestLoading.isRunShow = true;
        requestLoading?.beforeRequest();
      } else {
        requestLoading.isRunShow = false;
      }
    }

    try {
      ///读缓存
      if (fbRequestBean.cacheTag != null) {
        String cacheResult =
            FBSpUtils().getString("net${fbRequestBean.cacheTag}");
        if (cacheResult != null) {
          fbRequestBean
              .cacheCallBack(transformer.transformData<T>(cacheResult));
        }
      }
    } catch (e) {}

    _launchRequestWithRetry<T>(context, transformer, completer, requestLoading,
        retry, fbRequestBean, 0);

    return completer.future;
  }

  static void _launchRequestWithRetry<T>(
      BuildContext context,
      ResponseTransform transformer,
      Completer<T> completer,
      RequestLoading requestLoading,
      Retry retry,
      FBRequestBean fbRequestBean,
      int retryTime) {
    Future<Response> requestFuture = _getRequestFuture(fbRequestBean);

    if (fbRequestBean.cancelToken != null && requestLoading != null) {
      requestLoading.setFinishListener(() {
        HttpManger().removeCancel(fbRequestBean.cancelToken);
      });
    }

    requestFuture.then((response) {
      String transData;
      try {
        if (response.data is Map) {
          transData = json.encode(response.data);
        } else if (response.data is String) {
          transData = response.data.toString();
        } else {
          throw FBError(ResponseErrCode.ERR_DATA_FORMAT, "数据异常");
        }
      } catch (e) {
        throw FBError(ResponseErrCode.ERR_DATA_FORMAT, "数据异常");
      }

      try {
        if (fbRequestBean.cacheTag != null) {
          FBSpUtils().put("net${fbRequestBean.cacheTag}", transData);
        }
      } catch (e) {}
      completer.complete(transformer.transformData<T>(transData));
      try {
        if (requestLoading != null && requestLoading.isRunShow) {
          requestLoading.afterRequest();
        }
      } catch (e) {
        FBError.printError(e);
      }

      HttpManger().removeCancel(fbRequestBean.cancelToken);
    }).catchError((e) {
      if (retry != null &&
          retry.isRetry &&
          retry.retryDelay > 0 &&
          retryTime < retry.retryTime) {
        if ((e is DioError) && (e.type == DioErrorType.CANCEL)) {
          _catchError(e, completer, context, fbRequestBean.cancelToken,
              requestLoading, fbRequestBean.url);
        } else {
          retryTime++;
          Future.delayed(Duration(microseconds: retry.retryDelay), () {
            _launchRequestWithRetry(context, transformer, completer,
                requestLoading, retry, fbRequestBean, retryTime);
          });
        }
      } else {
        _catchError(e, completer, context, fbRequestBean.cancelToken,
            requestLoading, fbRequestBean.url);
      }
    });
  }

  static void _catchError(err, Completer completer, BuildContext context,
      CancelToken cancelToken, RequestLoading requestLoading, String errorUrl) {
    requestLoading?.afterRequest();
    HttpManger().removeCancel(cancelToken);
    FBError fbError;
    if (err is DioError) {
      if (err.type == DioErrorType.CANCEL) {
        completer.completeError(fbError =
            FBError(ResponseErrCode.ERR_CANCEL, "已取消", errorUrl: errorUrl));
      } else if (err.type == DioErrorType.CONNECT_TIMEOUT ||
          err.type == DioErrorType.RECEIVE_TIMEOUT) {
        completer.completeError(fbError = FBError(
            ResponseErrCode.ERR_RECEIVER_TIME_OUT, "连接超时",
            errorUrl: errorUrl));
      } else if (err.response != null) {
        completer.completeError(fbError = FBError(
            err.response.statusCode, "网络异常，请稍后重试~",
            errorUrl: errorUrl));
      } else if (err is FormatException) {
        completer.completeError(fbError = FBError(
            ResponseErrCode.ERR_DATA_FORMAT, "数据异常，请稍后重试~~",
            errorUrl: errorUrl));
      } else {
        completer.completeError(fbError = FBError(
            ResponseErrCode.ERR_UN_KNOW, "网络异常，请稍后重试~~~",
            errorUrl: errorUrl));
      }
    } else if (err is FBError) {
      completer.completeError(fbError = err);
    } else if (err is FormatException) {
      completer.completeError(fbError = FBError(
          ResponseErrCode.ERR_DATA_FORMAT, "数据异常，请稍后重试~~~~",
          errorUrl: errorUrl));
    } else if (err is SocketException) {
      completer.completeError(fbError = FBError(
          ResponseErrCode.ERR_UN_KNOW, "网络异常，请稍后重试~~~~~",
          errorUrl: errorUrl));
    } else {
      completer.completeError(fbError = FBError(
          ResponseErrCode.ERR_UN_KNOW, "${err.toString()}",
          errorUrl: errorUrl));
    }
    if (globalErrCallBack != null && fbError != null) {
      globalErrCallBack(fbError);
    }
  }

  static Future<Response> _getRequestFuture(FBRequestBean fbRequestBean) {
    CancelToken cancelToken = HttpManger()
        .createCancelToken(fbRequestBean.context, fbRequestBean.url);
    fbRequestBean.cancelToken = cancelToken;
    return HttpManger().getRequestFuture(
        fbRequestBean.context,
        fbRequestBean.url,
        fbRequestBean.requestMethod,
        fbRequestBean.params,
        fbRequestBean.options,
        fbRequestBean.onSendProgress,
        fbRequestBean.onReceiveProgress,
        fbRequestBean.cancelToken,
        fbRequestBean.files,
        fbRequestBean.multiData,
        fbRequestBean.suffix);
  }

  static cancelRequest(BuildContext context) {
    if (context == null) return;

    HttpManger().cancelRequest(context);
  }

  static Future<Response<T>> upload<T>(
    String url,
    dynamic formData, {
    Map params,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) {
    return HttpManger().getHttpIo().post<T>(url,
        data: formData,
        queryParameters: params,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
  }
}
