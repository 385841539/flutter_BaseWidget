import 'dart:io';
import 'package:http_parser/http_parser.dart';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../base_lib.dart';
import 'http_config.dart';

class HttpManger {
  Dio _dio;

  String _proxy;
  bool Function(X509Certificate cert, String host, int port)
  _badCertificateCallback;

  HttpClient _client;

  HttpManger._internal() {
    initHttpIo();
  }

  static HttpManger _httpManger = HttpManger._internal();

  factory HttpManger() {
    return _httpManger;
  }

  Dio getHttpIo() {
    return _dio;
  }

  void initHttpIo() {
    _dio = Dio();

    _configDio();
  }

  void _configDio() {
    _dio = Dio();

    /// 添加拦截器
    _dio.options.baseUrl = HttpConfig.baseUrl;
    _dio.options.connectTimeout = HttpConfig.connectTimeOut; //5s
    _dio.options.receiveTimeout = HttpConfig.receiveTimeOut;
    _dio.options.contentType = HttpConfig.contentType;

    if (AppConfig.isDebug) {
      addIntercept(LogInterceptor());
    }

    ///代理设置
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      _client = client;
      if (_proxy != null) {
        print("proxy-000-$_proxy");
        _client.findProxy = (uri) {
          return "PROXY $_proxy";
        };
      }

      if (_badCertificateCallback != null) {
        _client.badCertificateCallback = _badCertificateCallback;
      }

      return _client;
    };
  }

  ///代理配置
  void setProxy(String proxy) {
    _proxy = proxy;
    print("proxy-dio--$_proxy");
    print("${_client == null}");
    if (_client != null) {
      _client.findProxy = (uri) {
        print("proxy-dio2222--$_proxy");
        return "PROXY $_proxy";
      };
    }
  }

  void clearProxy() {
    _proxy = null;
    if (_client != null) {
      _client.findProxy = null;
    }
  }

  /// 证书错误的回调配置
  void setBadCertificateCallback(
      bool callback(X509Certificate cert, String host, int port)) {
    _badCertificateCallback = callback;
    if (_client != null) {
      _client.badCertificateCallback = _badCertificateCallback;
    }
  }

  ///添加拦截器
  void addIntercept(Interceptor interceptor) {
    _dio?.interceptors?.add(interceptor);
  }

  ///设置基础url
  void setBaseUrl(String url) {
    _dio?.options?.baseUrl = url;
  }

  Future<Response> getRequestFuture(
      BuildContext context,
      String url,
      FBResultFul requestType,
      dynamic params,
      Options options,
      ProgressCallback onSendProgress,
      ProgressCallback onReceiveProgress,
      CancelToken cancelToken,
      List<File> files,
      List<List<int>> multiData,
      String suffix) async {
    if (requestType == FBResultFul.POST) {
      ///文件上传时 去拼接
      if (files != null || multiData != null) {
        List<MultipartFile> bytes = [];

        if (suffix != null) {
          suffix = suffix.replaceAll(".", "");
        }
        if (files != null) {
          for (int i = 0; i < files.length; i++) {
            String fileName;
            String pathName = files[i].path;
            if (pathName.contains(".${suffix ?? ""}")) {
              fileName = pathName;
            } else {
              fileName = "${files[i].path}.${suffix ?? ""}";
            }
            MultipartFile multipartFile = MultipartFile.fromBytes(
              await files[i].readAsBytes(),
              // 文件名
              filename: fileName,
              // contentType: MediaType("image", "jpg"),
            );
            bytes.add(multipartFile);
          }
        }

        if (multiData != null) {
          for (int i = 0; i < multiData.length; i++) {
            MultipartFile multipartFile = MultipartFile.fromBytes(
              multiData[i],
              // 文件名
              filename: "multipartFile$i${multiData[i].length}.${suffix ?? ""}",
              // contentType: MediaType("image", "jpg"),
            );
            bytes.add(multipartFile);
          }
        }

        if (bytes != null) {
          if (options == null) {
            options = Options();
          }
          if (options.sendTimeout == null ||
              options.sendTimeout < 1000 * 60 * 5) {
            options.sendTimeout = 1000 * 60 * 5;
          }
        }
        if (params == null) {
          params = new FormData.fromMap({"files": bytes});
        } else {
          params["files"] = bytes;
        }
      }

      return getHttpIo().post(url,
          options: options,
          data: params,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);
    } else if (requestType == FBResultFul.GET) {
      return getHttpIo().get(url,
          options: options,
          queryParameters: params,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress);
    } else if (requestType == FBResultFul.DELETE) {
      return getHttpIo().delete(
        url,
        options: options,
        queryParameters: params,
        cancelToken: cancelToken,
      );
    } else if (requestType == FBResultFul.PATCH) {
      return getHttpIo().patch(url,
          options: options,
          data: params,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);
    } else if (requestType == FBResultFul.PUT) {
      return getHttpIo().put(url,
          options: options,
          queryParameters: params,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);
    } else {
      return getHttpIo().request(url,
          options: options,
          queryParameters: params,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress);
    }
  }

  /// 取消请求的Token
  CancelToken createCancelToken(BuildContext context, String url) {
    CancelToken cancelToken;
    if (context != null) {
      cancelToken = new CancelToken();
      String key = '${context.hashCode}' + '_' + url;
      _cancelTokens[key] = cancelToken;
    }
    return cancelToken;
  }

  ///主动取消请求，如页面销毁
  void cancelRequest(BuildContext context) {
    if (context == null) return;
    _cancelTokens.removeWhere((key, value) {
      if (key.startsWith("${context.hashCode}_") &&
          !_cancelTokens[key].isCancelled) {
        _cancelTokens[key].cancel();
        debugPrint("key" + key.toString());
      }
      return key.startsWith("${context.hashCode}_");
    });
  }

  /// 移除结束的CancelToken
  void removeCancel(CancelToken cancelToken) {
    if (cancelToken == null) return;
    if (!cancelToken.isCancelled) {
      cancelToken.cancel();
    }
    _cancelTokens.remove(cancelToken);
  }

  static Map<String, CancelToken> _cancelTokens =
  new Map<String, CancelToken>();
}
