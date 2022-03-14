import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_common_plugin/base_lib.dart';


class CustomRequestModel extends BaseProvide {
  BuildContext context;

  String requestUrl = "";

  String requestParams = "";

  int requestMethod = 1;
  dynamic responseString = "";

  TextEditingController _responseControl;
  var params;

  CustomRequestModel(this.context);

  void request() {
    if (checkParams()) {
      launchRequest().then((value) {
        print("--response--$value");
        responseString = value;
        // notifyListeners();
      }).catchError((err) {
        responseString = "${err.toString()}";
      }).whenComplete(() {
        try {
          _responseControl?.text = fbConvert(responseString, 2);
        } catch (e) {
          _responseControl?.text = "$responseString";
        }

        notifyListeners();
      });
    }
  }

  bool checkParams() {
    params = null;
    if (StringUtils.isEmpty(requestUrl) || !requestUrl.startsWith("http")) {
      FBToastUtils.show("请输入正确的url");
      return false;
    }
    print("请求url:$requestUrl");
    if (!StringUtils.isEmpty(requestParams)) {
      print("请求入参:$requestParams");
      try {
        params = json.decode(requestParams);
      } catch (e) {
        FBToastUtils.show("请输入正确的入参");
        return false;
      }
      print("请求方式:${requestMethod == 1 ? "GET" : "POST"}");
      // WHToastUtil.showToast("请输入正确的url", gravity: ToastGravity.CENTER);
    }

    return true;
  }

  Future launchRequest() {
    if (requestMethod == 1) {
      return FBHttpUtil.get(context, requestUrl,
          params: params, transformer: FBOriginalTransformer());
    } else {
      return FBHttpUtil.post(context, requestUrl,
          params: params, transformer: FBOriginalTransformer());
    }
  }

  TextEditingController get responseControl => _responseControl;

  set responseControl(TextEditingController value) {
    _responseControl = value;
    print("control-$_responseControl-");
  }

  @override
  Future requestData() {
    // TODO: implement requestData
    return null;
  }
}
