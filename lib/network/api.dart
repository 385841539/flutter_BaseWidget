import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_base_widget/base/buildConfig.dart';
import 'package:flutter_base_widget/network/response/ApiStringTransform.dart';
import 'package:flutter_base_widget/network/response/Transform.dart';
import 'package:flutter_base_widget/utils/sp_utils/sp_constant.dart';
import 'package:flutter_base_widget/utils/sp_utils/sp_utils.dart';
import 'package:rxdart/rxdart.dart';

import 'intercept/base_intercept.dart';

///http请求
class HttpManager {
  static final int CONNECR_TIME_OUT = 1000 * 10;
  static final int RECIVE_TIME_OUT = 1000 * 10;
  static final CONTENT_TYPE_JSON = "application/json;charset=UTF-8";
  static final CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";
  static Dio _dio;

  static Map<String, CancelToken> _cancelTokens =
      new Map<String, CancelToken>();

  HttpManager._internal() {
    initDio();
  }

  static HttpManager _httpManger = HttpManager._internal();

  factory HttpManager() {
    return _httpManger;
  }

  //get请求
  PublishSubject<T> get<T>(
    String url,
    ResponseTransform<T> transform, {
    Map<String, dynamic> queryParameters,
    BaseIntercept baseIntercept,
    bool isCancelable = true,
  }) {
    return _requstHttp<T>(
        url, transform, true, queryParameters, baseIntercept, isCancelable);
  }

  //post请求
  PublishSubject<T> post<T>(String url, ResponseTransform<T> transform,
      {Map<String, dynamic> queryParameters,
      BaseIntercept baseIntercept,
      bool isCancelable = true,
      bool isSHowErrorToast = true}) {
    return _requstHttp<T>(
        url, transform, false, queryParameters, baseIntercept, isCancelable);
  }

  /// 参数说明  url 请求路径
  /// queryParamerers  是 请求参数
  /// transform 请求结果处理的转换器
  /// isGet get 还是 post 请求
  /// baseIntercept用于 加载loading 和 设置 取消CanselToken
  /// isCancelable 是设置改请求是否 能被取消 ， 必须建立在 传入baseWidget或者baseInnerWidgetState的基础之上
  PublishSubject<T> _requstHttp<T>(String url, ResponseTransform transform,
      [bool isGet,
      queryParameters,
      BaseIntercept baseIntercept,
      bool isCancelable]) {
    Future future;

    PublishSubject<T> publishSubject = PublishSubject<T>();
    if (transform == null) {
      transform = ApiStringTransform(); //内置一个 返回String 的Transform
    }

    transform.setBaseIntercept(baseIntercept);
    transform.setPublishPubject(publishSubject);
    CancelToken cancelToken;

    _setInterceptOrcancelAble(baseIntercept, isCancelable, cancelToken);

    if (isGet) {
      future = _dio.get(url,
          queryParameters: queryParameters, cancelToken: cancelToken);
    } else {
      future = _dio.post(url, data: queryParameters, cancelToken: cancelToken);
    }

    future.then((data) {
      transform.apply(data.toString());
    }).catchError((err) {
      _doError(err, transform);
    });

    return publishSubject;
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


    /// 添加拦截器
//    _dio.interceptors.add(new MyIntercept());

    // 配置dio实例
//    _dio.options.baseUrl = "http://10.150.20.86/xloan-app-api/";
    _dio.options.baseUrl = "http://gank.io/api/";
    _dio.options.connectTimeout = CONNECR_TIME_OUT; //5s
    _dio.options.receiveTimeout = RECIVE_TIME_OUT;
    _dio.options.contentType = ContentType.parse(CONTENT_TYPE_FORM);

//代理设置
    if (BuildConfig.isDebug) {
//      _dio.interceptors
//          .add(WhLogInterceptor(requestBody: true, responseBody: true));
      //此处可以增加配置项，留一个设置代理的用户给测试人员配置，然后动态读取

      String proxy=SpUtils.getString(SpConstanst.httpProxyHost);

//      print("--prox----${proxy}----${SpUtils.getBool(SpConstanst.httpProxyEnable)}=====-");
      if(proxy!=null&&proxy!=""&&SpUtils.getBool(SpConstanst.httpProxyEnable)) {
        (_dio.httpClientAdapter as DefaultHttpClientAdapter)
            .onHttpClientCreate =
            (client) {
          // config the http client
          client.findProxy = (uri) {
            //proxy all request to localhost:8888
            return "PROXY " + SpUtils.getString(SpConstanst.httpProxyHost);
          };


          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          // you can also create a new HttpClient to dio
          // return new HttpClient();
        };
      }
    } else {
      //证书配置 ， 忽略证书
      String PEM = "XXXXX"; // certificate content
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) {
          return true; //返回 true 表明 忽略 证书校验
        };
      };
    }
  }



  ///测试是否真的 可以清除 的方法,用途仅为验证
  static void ListCancelTokens() {
    _cancelTokens.forEach((key, value) {
      print("${key}-----cancel---");
    });
  }

  //配置是否 显示 loading 和 是否能被取消
  void _setInterceptOrcancelAble(
      BaseIntercept baseIntercept, bool isCancelable, CancelToken cancelToken) {
    if (baseIntercept != null) {
      baseIntercept.beforeRequest();
      //为了 能够取消 请求
      if (isCancelable) {
        cancelToken = _cancelTokens[baseIntercept.getClassName()] == null
            ? CancelToken()
            : _cancelTokens[baseIntercept.getClassName()];
        _cancelTokens[baseIntercept.getClassName()] = cancelToken;
      }
    }
  }

  ///过滤网络出错的情况
  void _doError(err, ResponseTransform transform) {
    try {
      if (err is DioError) {
        if (err.type == DioErrorType.CANCEL) {
          print("---请求取消---");
        } else if (err.type == DioErrorType.CONNECT_TIMEOUT ||
            err.type == DioErrorType.RECEIVE_TIMEOUT) {
          transform.callError(MyError(400, "连接超时"));
        } else if (err.response != null) {
          transform
              .callError(MyError(err.response.statusCode, "${err.message}"));
        } else {
          transform.callError(MyError(400, "${err.message}"));
        }
      } else if (err is SocketException) {
        transform.callError(MyError(400, "网路异常"));
      } else {
        transform.callError(MyError(1, err.toString()));
      }
    } catch (err2) {
      transform.callError(MyError(400, "网络异常，请稍后重试"));
    }
  }

}

class MyError {
  int code;
  String message;

  MyError(this.code, this.message);
}
