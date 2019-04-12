import 'package:flutter_base_widget/base/common_function.dart';
import 'package:flutter_base_widget/network/intercept/base_intercept.dart';

class NoActionIntercept extends BaseIntercept {
  NoActionIntercept(BaseFuntion baseFuntion, {bool isDefaultFailure = true}) {
    this.baseFuntion = baseFuntion;
    this.isDefaultFailure = isDefaultFailure;
  }
  @override
  void afterRequest() {}

  @override
  void beforeRequest() {}
}
