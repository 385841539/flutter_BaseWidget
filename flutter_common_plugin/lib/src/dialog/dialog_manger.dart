import 'package:flutter/material.dart';
import 'package:flutter_common_plugin/base_lib.dart';
import 'package:flutter_common_plugin/src/dialog/dialog_base_dialog.dart';

class DialogManger {
  // static OrderDialogContainer _dialogContainer;

  static List<OrderDialogContainer> _list = [];

  static showOrderDialog(
    Widget widget,
    BuildContext context, {
    bool isOuSideCancel = true,
    bool isOnBackCancel = true,
    AlignmentGeometry gravity = AlignmentDirectional.center,
    Color barrierColor = Colors.black54,

    ///背景颜色
    int zIndex = 1,
  }) {
    ///组装对话框实例

    FBBaseOrderDialogDelege fbBaseOrderDialog = FBBaseOrderDialogDelege();
    fbBaseOrderDialog.widget = widget;
    fbBaseOrderDialog.isOnBackCancel = isOnBackCancel;
    fbBaseOrderDialog.isOuSideCancel = isOuSideCancel;
    fbBaseOrderDialog.zIndex = zIndex;
    fbBaseOrderDialog.gravity = gravity;
    fbBaseOrderDialog.barrierColor = barrierColor;

    OrderDialogContainer _dialogContainer;
    try {
      _dialogContainer = _getContainer(context);
      _dialogContainer.addOrderDialog(fbBaseOrderDialog);
    } catch (e) {
      _dialogContainer = _addNewDialogContainer(context);

      _dialogContainer.addOrderDialog(fbBaseOrderDialog);
    }
    fbBaseOrderDialog?.dialogContainer = _dialogContainer;
  }

  //移除弹窗容器
  static void removeDialogContainer(OrderDialogContainer dialogContainer) {
    if (dialogContainer != null) {
      _list.remove(dialogContainer);
    }
  }

  static void dismissDialog(Widget widget) {
    if (widget == null || _list == null || _list.isEmpty) return;
    for (int i = 0; i < _list.length; i++) {
      OrderDialogContainer orderDialogContainer = _list[i];
      if (orderDialogContainer.contains(widget)) {
        break;
      }
    }
  }

  static OrderDialogContainer _getContainer(BuildContext context) {
    if (_list.isEmpty) {
      return _addNewDialogContainer(context);
    } else {
      OrderDialogContainer lastContainer = _list.last;

      if (FBNavUtils.isCurrent(lastContainer.dialogState.context)) {
        //如果处于栈顶则直接赋值
        return lastContainer;
      } else {
        //否则 新建容器
        return _addNewDialogContainer(context);
      }
    }
  }

  static OrderDialogContainer _addNewDialogContainer(BuildContext context) {
    OrderDialogContainer _dialogContainer = OrderDialogContainer();
    _list.add(_dialogContainer);
    showDialog(
        barrierColor: Colors.transparent,
        context: context,
        // useRootNavigator: false,
        useSafeArea: false,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return _dialogContainer;
        });
    return _dialogContainer;
  }
}
