import 'dart:async';

import 'package:flutter_base_widget/base/base_inner_widget.dart';
import 'package:flutter_base_widget/network/api.dart';
import 'package:flutter_base_widget/network/bean/login_response_entity.dart';
import 'package:flutter_base_widget/network/response.dart';
import 'package:rxdart/rxdart.dart';

class RequestMap {
  static PublishSubject<LoginResponseEntity> requestLogin<BaseResponse>() {
    String url = "xiandu/category/wow";
    return HttpManager().get<LoginResponseEntity>(url);
  }

  static PublishSubject testErrorrequest(BaseInnerWidgetState innerWidget) {
    String urlError = "error";
    return HttpManager().get<LoginResponseEntity>(urlError = "error",
        baseInnerWidgetState: innerWidget);
  }
}
