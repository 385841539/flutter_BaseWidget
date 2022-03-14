import 'package:flutter/material.dart';
import 'multi_base_provide.dart';

/// ViewModel 业务逻辑模型基类
/// 用于实现模板的通用操作
abstract class BaseProvide extends MultiBaseProvide {
  ///分页加载 page
  int page = 1;

  String get className => this.runtimeType.toString();

  ///是否能下拉刷新
  bool isCanRefresh = false;

  ///错误文案
  String errorText;

  ///错误图片
  String errorImgPath;

  ///是否能上拉加载
  bool enableLoadMore = false;

  ///列表时无数据时是否展示 底部footer
  bool isShowNoMoreFooter = false;

  ///是否支持刷新
  bool useRefresh = false;

  ///空布局是否占全部 布局 是的话 没有其他事情，不是的话 则需要自己重写空布局
  bool isEmptyWidgetHoldAll = true;

  ///标记是否是第一次使用 requestData
  bool isFirstRequestData = true;

  bool get isEmpty => getIsEmpty();

  ///异步请求，ui加载完以后会走一次这个放啊
  Future requestData();

  ///onResume 方法
  void onResume() {}

  ///onCreate方法， 只走一次， 这里就可以通过 [arguments] 拿到参数
  ///禁止在这里面做耗时阻塞操作
  void onCreate(Object arguments) {}

  void onPause() {}

  Object getArguments() {
    return ModalRoute.of(context).settings.arguments;
  }

  bool getIsEmpty() {
    return false;
  }

  Future loadMore() {
    return null;
  }
}
