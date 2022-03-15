import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common_plugin/base_lib.dart';

///有序dialog代理model
class FBBaseOrderDialogDelege {
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

  bool get isOuSideCancel => _isOuSideCancel;

  set isOuSideCancel(value) {
    _isOuSideCancel = value;
  }

  bool get isOnBackCancel => _isOnBackCancel;

  set isOnBackCancel(value) => _isOnBackCancel = value;

  int get zIndex => _zIndex;

  set zIndex(value) => _zIndex = value;

  OrderDialogContainer get dialogContainer => _dialogContainer;

  set dialogContainer(value) => _dialogContainer = value;

  Widget get widget => _widget;

  set widget(value) => _widget = value;

  BuildContext get buildContext => _buildContext;

  set buildContext(value) => _buildContext = value;
}
