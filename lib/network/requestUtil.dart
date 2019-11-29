import 'package:flutter_base_widget/network/bean/login_response_entity.dart';
import 'package:flutter_base_widget/network/intercept/base_intercept.dart';
import 'package:flutter_base_widget/network/response/ApiFullTransform.dart';
import 'package:rxdart/rxdart.dart';

import 'api.dart';

class RequestMap {
  static PublishSubject requestLogin(BaseIntercept baseIntercept) {
//    String url = "http://gank.io/api/xiandu/category/wow";//可以全部路径
    String url = "xiandu/category/wow"; //也可以抛去 dio 设置的基本 url
    LoginResponseEntity loginResponseEntity =
    LoginResponseEntity(); //模拟 带参数，直接对象转json就可以了
    loginResponseEntity.error = false;

//
    return HttpManager().get<LoginResponseEntity>(url, ApiFullTransform(),
        queryParameters: loginResponseEntity.toJson(),
        baseIntercept: baseIntercept,
        isCancelable: false);
  }

  static PublishSubject testErrorrequest(BaseIntercept baseIntercept) {
    String urlError = "error";
    return HttpManager().get<LoginResponseEntity>(urlError = "error",ApiFullTransform(),
        baseIntercept: baseIntercept);
  }





}
