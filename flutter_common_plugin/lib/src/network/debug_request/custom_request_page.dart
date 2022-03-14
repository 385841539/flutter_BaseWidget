import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common_plugin/base_lib.dart';
import 'package:flutter_common_plugin/src/network/debug_request/custom_request_model.dart';
import 'package:flutter_common_plugin/src/network/debug_request/http_request_params_widget.dart';


/// 自定义请求页
class CustomRequestPage extends StatefulWidget {

  static const String customRequestPage="CustomRequestPage";
  @override
  State<StatefulWidget> createState() => _CustomRequestPageState();
}

class _CustomRequestPageState
    extends BaseListState<CustomRequestPage, CustomRequestModel> {
  @override
  List<Widget> getMainChildrenWidget(BuildContext context) {
    // TODO: implement getMainChildrenWidget
    return [HttpRequestParamsWidget(provide)];
  }

  @override
  BaseProvide registerProvide() {
    // TODO: implement registerProvide
    return CustomRequestModel(context);
  }
}
