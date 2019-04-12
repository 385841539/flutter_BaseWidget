import 'package:flutter_base_widget/base/common_function.dart';
import 'package:flutter_base_widget/network/intercept/base_intercept.dart';

class ShowLoadingIntercept extends BaseIntercept {
  ShowLoadingIntercept(BaseFuntion baseFuntion,
      {bool isDefaultFailure = true}) {
    this.baseFuntion = baseFuntion;
    this.isDefaultFailure = isDefaultFailure;
  }
  @override
  void afterRequest() {
    if (baseFuntion != null) {
      baseFuntion.setLoadingWidgetVisible(false);
    }
  }

  @override
  void beforeRequest() {
    if (baseFuntion != null) {
      baseFuntion.setLoadingWidgetVisible(true);
    }
  }
}
