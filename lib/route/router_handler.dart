import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_base_widget/test_package/asinnerpage/TabBarBottomPageWidget.dart';

var homeHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> parameters) {
  //TODO 拿到参数
  String id = parameters["id"]?.first;
  return TabBarWidget();
});
