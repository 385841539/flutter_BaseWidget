import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_widget/base/_base_widget.dart';
import 'package:flutter_base_widget/base/base_inner_widget.dart';
import 'package:flutter_base_widget/entity_factory.dart';
import 'package:flutter_base_widget/network/myIntercept.dart';
import 'package:flutter_base_widget/network/response.dart';
import 'package:flutter_base_widget/network/response_callback.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';

///http请求
class HttpManager {
  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";
  static Dio _dio;
  static final int CONNECR_TIME_OUT = 5000;
  static final int RECIVE_TIME_OUT = 3000;
  static Map<String, CancelToken> _cancelTokens;

  HttpManager._internal() {
    initDio();
  }
  static HttpManager _httpManger = HttpManager._internal();
  factory HttpManager() {
    return _httpManger;
  }

  //get请求
  PublishSubject<T> get<T>(String url,
      {Map<String, dynamic> queryParameters,
      BaseWidgetState baseWidgetState,
      BaseInnerWidgetState baseInnerWidgetState,
      bool isCancelable = true,
      bool isShowLoading = true,
      bool isSHowErrorToast = true}) {
    return _requstHttp<T>(url, true, queryParameters, baseWidgetState,
        baseInnerWidgetState, isCancelable, isShowLoading, isSHowErrorToast);
  }

  //post请求
  PublishSubject<T> post<T>(String url,
      {Map<String, dynamic> queryParameters,
      BaseWidgetState baseWidgetState,
      BaseInnerWidgetState baseInnerWidgetState,
      bool isCancelable = true,
      bool isShowLoading = true,
      bool isSHowErrorToast = true}) {
    return _requstHttp<T>(url, false, queryParameters, baseWidgetState,
        baseInnerWidgetState, isCancelable, isShowLoading, isSHowErrorToast);
  }

  /// 参数说明  url 请求路径
  /// queryParamerers  是 请求参数
  /// baseWidget和baseInnerWidgetState用于 加载loading 和 设置 取消CanselToken
  /// isCancelable 是设置改请求是否 能被取消 ， 必须建立在 传入baseWidget或者baseInnerWidgetState的基础之上
  /// isShowLoading 设置是否能显示 加载loading , 同样要建立在传入 baseWidget或者 baseInnerWidgetState 基础之上
  /// isShowErrorToaet  这个是 设置请求失败后 是否要 吐司的
  PublishSubject<T> _requstHttp<T>(String url,
      [bool isGet,
      Map<String, dynamic> queryParameters,
      BaseWidgetState baseWidgetState,
      BaseInnerWidgetState baseInnerWidgetState,
      bool isCancelable,
      bool isShowLoading,
      bool isSHowErrorToast]) {
    Future future;
    PublishSubject<T> publishSubject = PublishSubject<T>();
    CancelToken cancelToken;
    _setLoadingOrcancelAble(baseWidgetState, baseInnerWidgetState, isCancelable,
        isShowLoading, cancelToken);

    if (isGet) {
      future = _dio.get(url,
          queryParameters: queryParameters, cancelToken: cancelToken);
    } else {
      future = _dio.post(url,
          queryParameters: queryParameters, cancelToken: cancelToken);
    }

    future.then((data) {
      //这里要做错误处理
      //需要先过滤 error ， 根据和后台的 约定 ， 搞清楚什么是失败
      // 什么是成功  ， 这里只是根据了干货集中营的 返回 模拟了一下

      bool isError = json.decode(data.toString())["error"];

      print("---responseData----${data}-----");
      if (isError) {
        callError(publishSubject, MyError(10, "请求失败~"), baseWidgetState,
            baseInnerWidgetState, isShowLoading, isSHowErrorToast);
      } else {
        //这里的解析 请参照 https://www.jianshu.com/p/e909f3f936d6 , dart的字符串 解析蛋碎一地
        publishSubject
            .add(EntityFactory.generateOBJ<T>(json.decode(data.toString())));
        publishSubject.close();

        cancelLoading(baseWidgetState, baseInnerWidgetState, isShowLoading);
      }
    }).catchError((err) {
      callError(publishSubject, MyError(1, err.toString()), baseWidgetState,
          baseInnerWidgetState, isShowLoading, isSHowErrorToast);
    });

    return publishSubject;
  }

  ///请求错误以后 做的一些事情
  void callError(
      PublishSubject publishSubject,
      MyError error,
      BaseWidgetState baseWidgetState,
      BaseInnerWidgetState baseInnerWidgetState,
      bool isShowLoading,
      bool isSHowErrorToast) {
    publishSubject.addError(error);
    publishSubject.close();

    if (isSHowErrorToast) {
      showErrorToast(error.message);
    }

    cancelLoading(baseWidgetState, baseInnerWidgetState, isShowLoading);
  }

  ///取消请求
  static void cancelHttp(String tag) {
    if (_cancelTokens.containsKey(tag)) {
      if (!_cancelTokens[tag].isCancelled) {
        _cancelTokens[tag].cancel();
      }
      _cancelTokens.remove(tag);
    }
  }

  ///配置dio
  void initDio() {
    _dio = Dio();
    // 配置dio实例
//    _dio.options.baseUrl = "http://10.150.20.86/xloan-app-api/";
    _dio.options.baseUrl = "http://gank.io/api/";
    _dio.options.connectTimeout = CONNECR_TIME_OUT; //5s
    _dio.options.receiveTimeout = RECIVE_TIME_OUT;
    _dio.options.contentType = ContentType.parse(CONTENT_TYPE_FORM);
    _cancelTokens = new Map<String, CancelToken>();

//代理设置
//    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
//      // config the http client
//      client.findProxy = (uri) {
//        //proxy all request to localhost:8888
//        return "PROXY localhost:8888";
//      };
//      // you can also create a new HttpClient to dio
//      // return new HttpClient();
//    };

    //证书配置
//    String PEM="XXXXX"; // certificate content
//    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate  = (client) {
//      client.badCertificateCallback=(X509Certificate cert, String host, int port){
//        if(cert.pem==PEM){ // Verify the certificate
//          return true;
//        }
//        return false;
//      };
//    };

    /// 添加拦截器
    _dio.interceptors.add(new MyIntercept());
  }

  ///测试是否真的 可以清除 的方法
  static void ListCancelTokens() {
    _cancelTokens.forEach((key, value) {
      print("${key}-----cancel---");
    });
  }

  //配置是否 显示 loading 和 是否能被取消
  void _setLoadingOrcancelAble(
      BaseWidgetState baseWidgetState,
      BaseInnerWidgetState baseInnerWidgetState,
      bool isCancelable,
      bool isShowLoading,
      CancelToken cancelToken) {
    if (baseWidgetState != null) {
      if (isShowLoading) {
        baseWidgetState.setLoadingWidgetVisible(true);
      }
      //为了 能够取消 请求
      if (isCancelable) {
        cancelToken = _cancelTokens[baseWidgetState.getClassName()] == null
            ? CancelToken()
            : _cancelTokens[baseWidgetState.getClassName()];
        _cancelTokens[baseWidgetState.getClassName()] = cancelToken;
      }
    }

    //这里主要是做 是否 加载loading和是否 页面销毁的时候
    if (baseInnerWidgetState != null) {
      if (isShowLoading) {
        baseInnerWidgetState.setLoadingWidgetVisible(true);
      }
      //为了能够取消请求
      if (isCancelable) {
        cancelToken = _cancelTokens[baseInnerWidgetState.getClassName()] == null
            ? CancelToken()
            : _cancelTokens[baseInnerWidgetState.getClassName()];
        _cancelTokens[baseInnerWidgetState.getClassName()] = cancelToken;
      }
    }
  }

  void showErrorToast(String message) {
    //TODO 统一错误提示
    showToast(message);
  }

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

  void cancelLoading(BaseWidgetState baseWidgetState,
      BaseInnerWidgetState baseInnerWidgetState, bool isShowLoading) {
    if (baseWidgetState != null) {
      if (isShowLoading) {
        baseWidgetState.setLoadingWidgetVisible(false);
      }
    }
    if (baseInnerWidgetState != null) {
      if (isShowLoading) {
        baseInnerWidgetState.setLoadingWidgetVisible(false);
      }
    }
  }
}

class MyError {
  int code;
  String message;
  MyError(this.code, this.message);
}
