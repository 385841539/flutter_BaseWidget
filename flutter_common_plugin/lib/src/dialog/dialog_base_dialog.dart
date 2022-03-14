import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common_plugin/base_lib.dart';

///有序dialog基类
class FBBaseOrderDialog {
  //点击外部区域是否可以取消
  bool _isOuSideCancel = true;

  //点击返回是否可以取消
  bool _isOnBackCancel = true;

  AlignmentGeometry gravity;
  Color barrierColor;
  //层级位置
  int _zIndex = 1;

  Widget _widget;

  BuildContext _buildContext;

  OrderDialogContainer _dialogContainer;

  // ignore: unnecessary_getters_setters
  bool get isOuSideCancel => _isOuSideCancel;

  // ignore: unnecessary_getters_setters
  set isOuSideCancel(bool value) {
    _isOuSideCancel = value;
  }

  // ignore: unnecessary_getters_setters
  bool get isOnBackCancel => _isOnBackCancel;

  // ignore: unnecessary_getters_setters
  set isOnBackCancel(bool value) {
    _isOnBackCancel = value;
  }

  // ignore: unnecessary_getters_setters
  int get zIndex => _zIndex;

  // ignore: unnecessary_getters_setters
  set zIndex(int value) {
    _zIndex = value;
  }

  // ignore: unnecessary_getters_setters
  OrderDialogContainer get dialogContainer => _dialogContainer;

  // ignore: unnecessary_getters_setters
  set dialogContainer(OrderDialogContainer value) {
    _dialogContainer = value;
  }

  // ignore: unnecessary_getters_setters
  Widget get widget => _widget;

  // ignore: unnecessary_getters_setters
  set widget(Widget value) {
    _widget = value;
  }

  // ignore: unnecessary_getters_setters
  BuildContext get buildContext => _buildContext;

  // ignore: unnecessary_getters_setters
  set buildContext(BuildContext value) {
    _buildContext = value;
  }
}
