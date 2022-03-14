import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common_plugin/base_lib.dart';
import 'package:flutter_common_plugin/src/dialog/dialog_base_dialog.dart';

class OrderDialogContainer extends StatefulWidget {
  final _OrderDialogContainerState dialogState = _OrderDialogContainerState();

  @override
  _OrderDialogContainerState createState() {
    return dialogState;
  }

  void addOrderDialog(FBBaseOrderDialog fbBaseOrderDialog) {
    // dialogs[0] = fbBaseOrderDialog;
    dialogState.addOrderDialog(fbBaseOrderDialog);
    // createState().context;
  }

  void removeDialog(FBBaseOrderDialog fbBaseOrderDialog) {
    dialogState._removeOrderDialog(fbBaseOrderDialog);
  }

  bool contains(Widget context) {
    return dialogState.contains(context);
  }
}

class _OrderDialogContainerState
    extends BaseState<OrderDialogContainer, BaseProvide> {
  final List<FBBaseOrderDialog> _dialogs = List();

  void addOrderDialog(FBBaseOrderDialog fbBaseOrderDialog) {
    // dialogs[0] = fbBaseOrderDialog;
    // createState().context;

    try {
      if (widget == null) {
        Future.delayed(Duration(milliseconds: 200), () {
          _addDialog(fbBaseOrderDialog);
        });
      } else {
        _addDialog(fbBaseOrderDialog);
      }
    } catch (e) {
      Future.delayed(Duration(milliseconds: 200), () {
        _addDialog(fbBaseOrderDialog);
      });
    }
  }

  bool _isBuild = false;

  @override
  void initState() {
    super.initState();
    setNavigationBarVisible(false);
    setStatusBarVisible(false);
    setBackgroundColor(Colors.transparent);
  }

  @override
  bool isListenLifeCycle() {
    return false;
  }

  @override
  Widget getMainWidget(BuildContext context) {
    _isBuild = true;
    return WillPopScope(
      onWillPop: () async {
        if (_dialogs == null || _dialogs.isEmpty) {
          return true;
        } else {
          FBBaseOrderDialog fb = _dialogs.last;
          if (fb.isOnBackCancel) {
            //说明能返回消失改弹窗
            _removeOrderDialog(fb);
          }
          return false;
        }
      },
      child: Container(
        // color: Colors.red,
        width: FBScreenUtil.getScreenWidth(),
        height: FBScreenUtil.getScreenHeight(),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: _generateLists(),
        ),
      ),
    );
  }

  List<Widget> _generateLists() {
    if (_dialogs == null) return [];

    List<Widget> lists = [];

    for (int i = 0; i < _dialogs.length; i++) {
      FBBaseOrderDialog fbBaseOrderDialog = _dialogs[i];

      lists.add(Stack(
        //构建dialog item
        alignment: fbBaseOrderDialog?.gravity ?? AlignmentDirectional.center,
        children: <Widget>[
          Container(
            height: FBScreenUtil.getScreenHeight(),
            width: FBScreenUtil.getScreenWidth(),
            color: fbBaseOrderDialog.barrierColor,
            child: GestureDetector(
              onTap: () {
                if ((fbBaseOrderDialog?.isOuSideCancel ?? false)) {
                  _removeOrderDialog(fbBaseOrderDialog);
                }
              },
            ),
          ),
          fbBaseOrderDialog.widget ?? Container()
        ],
      ));
    }

    return lists;
  }

  void _addDialog(FBBaseOrderDialog fbBaseOrderDialog) {
    if (_dialogs.isEmpty) {
      _dialogs.add(fbBaseOrderDialog);
    } else {
      _addByOrder(fbBaseOrderDialog);
    }
    if (_isBuild) {
      setState(() {});
    }
  }

  void _removeOrderDialog(FBBaseOrderDialog fbBaseOrderDialog) {
    if (fbBaseOrderDialog != null && _dialogs != null) {
      _dialogs.remove(fbBaseOrderDialog);
      if (_dialogs.isEmpty) {
        DialogManger.removeDialogContainer(fbBaseOrderDialog.dialogContainer);
        Navigator.pop(context);
      } else {
        setState(() {});
      }
    }
  }

  void _addByOrder(FBBaseOrderDialog fbBaseOrderDialog) {
    for (int i = _dialogs.length - 1; i >= 0; i--) {
      //从后遍历现有弹窗，发现插进来的 层级大的话直接显示， 并停止遍历
      FBBaseOrderDialog comPareDialog = _dialogs[i];

      if (fbBaseOrderDialog.zIndex >= comPareDialog.zIndex) {
        _dialogs.insert(i + 1, fbBaseOrderDialog);
        return;
      }
    }
    _dialogs.insert(0, fbBaseOrderDialog); //说明插进来的层级最小，放在最前面
  }

  bool contains(Widget widget) {
    if (_dialogs == null || _dialogs.isEmpty) return false;

    for (int i = 0; i < _dialogs.length; i++) {
      FBBaseOrderDialog fbBaseOrderDialog = _dialogs[i];
      if (fbBaseOrderDialog.widget == widget) {
        _removeOrderDialog(fbBaseOrderDialog);
        return true;
      }
    }
    return false;
  }

  @override
  List<Widget> getMainChildrenWidget(BuildContext context) {
    // TODO: implement getMainChildrenWidget
    throw UnimplementedError();
  }

  @override
  BaseProvide registerProvide() {
    return null;
  }
}
