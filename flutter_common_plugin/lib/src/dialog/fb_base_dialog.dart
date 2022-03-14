import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common_plugin/base_lib.dart';

/// 自定义弹窗抽象类
abstract class FBBaseDialog {
  BuildContext context;
  bool outsideCancel;
  bool backCancel = true;

  bool fullStyle = false;
  final bool isIosStyle;
  AlignmentGeometry gravity;
  bool _isShow = false;
  Color backgroundColor;
  Color barrierColor ;
  double elevation;
  ShapeBorder shape;
  double horizontal;
  int zIndex;
  double radius;
  BorderRadiusGeometry borderRadius;

  ///对话框层级
  FBBaseDialog(this.context,
      {this.outsideCancel: false,
      this.isIosStyle: false,
      this.backCancel: true,
      this.fullStyle: false,
      this.backgroundColor,
      this.gravity,
      this.elevation = 0,
      this.horizontal,
      this.barrierColor= Colors.black54,
      this.zIndex = 0,
      this.radius = 7.0,
      this.borderRadius,
      this.shape}) {
    if (shape == null) {
      shape = RoundedRectangleBorder(
        borderRadius: borderRadius ??
            BorderRadius.all(
              Radius.circular(this.radius ?? 7.0),
            ),
      );
    }
  }

  bool get isShow => _isShow;
  Widget _dialogWidget;

  void show({AlignmentGeometry showGravity}) {
    if (!isShow) {
      if (_dialogWidget == null) {
        _dialogWidget = _buildDialogContent();
      }
      DialogManger.showOrderDialog(_dialogWidget, context,
          isOuSideCancel: outsideCancel,
          isOnBackCancel: backCancel,
          gravity: showGravity ?? gravity,
          barrierColor: barrierColor,
          zIndex: zIndex);
      _isShow = true;
    }
  }

  Widget _buildDialogContent() {
    return _buildDialogBackground(context);
  }

  Widget _buildDialogBackground(BuildContext context) {
    return WHDialogBackground(
      elevation: elevation,
      shape: shape,
      horizontal: horizontal,
      fullStyle: fullStyle,
      child: build(context),
    );
  }

  Widget build(BuildContext context);

  dismiss() {
    if (isShow) {
      _isShow = false;
      DialogManger.dismissDialog(_dialogWidget);
    }
  }
}

/// 弹窗背景
class WHDialogBackground extends StatelessWidget {
  const WHDialogBackground(
      {Key key,
      this.horizontal,
      this.backgroundColor,
      this.elevation,
      this.insetAnimationDuration = const Duration(milliseconds: 100),
      this.insetAnimationCurve = Curves.decelerate,
      this.shape,
      this.child,
      this.fullStyle = false})
      : super(key: key);

  final bool fullStyle;
  final Color backgroundColor;

  final double elevation;

  final Duration insetAnimationDuration;

  final Curve insetAnimationCurve;

  final ShapeBorder shape;

  final Widget child;

  final double horizontal;

  static const RoundedRectangleBorder _defaultDialogShape =
      RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7.0)));
  static const double _defaultElevation = 24.0;

  @override
  Widget build(BuildContext context) {
    final DialogTheme dialogTheme = DialogTheme.of(context);
    return fullStyle
        ? child
        : AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets +
                EdgeInsets.symmetric(horizontal: horizontal ?? 40.0),
            duration: insetAnimationDuration,
            curve: insetAnimationCurve,
            child: MediaQuery.removeViewInsets(
              removeLeft: true,
              removeTop: true,
              removeRight: true,
              removeBottom: true,
              context: context,
              child: Material(
                color: backgroundColor ??
                    dialogTheme.backgroundColor ??
                    Theme.of(context).dialogBackgroundColor,
                elevation:
                    elevation ?? dialogTheme.elevation ?? _defaultElevation,
                shape: shape ?? dialogTheme.shape ?? _defaultDialogShape,
                type: MaterialType.card,
                child: child,
              ),
            ),
          );
  }
}

/// 弹窗按钮
class FBDialogButtons extends StatelessWidget {
  final double height;
  final double width;
  final double virtualBorderWidth;
  final double topBorderWidth;
  final Color virtualBorderColor;
  final Color topBorderColor;
  final Text cancelText;
  final Text confirmText;
  final VoidCallback cancelLisenter;
  final VoidCallback confirmLisenter;
  static const double defultHeight = 42;

  FBDialogButtons({
    Key key,
    this.cancelText,
    this.confirmText,
    this.cancelLisenter,
    this.confirmLisenter,
    this.height = defultHeight,
    this.width,
    this.virtualBorderWidth,
    this.topBorderWidth,
    this.virtualBorderColor,
    this.topBorderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            top: Divider.createBorderSide(context,
                width: topBorderWidth ?? 0.5,
                color: topBorderColor ?? Color(0XFF8B8B8E))),
      ),
      height: height,
      width: width,
      child: Row(
        children: <Widget>[
          cancelText != null
              ? Expanded(
                  child: CupertinoButton(
                  padding: EdgeInsets.all(0),
                  pressedOpacity: 0.6,
                  onPressed: () {
                    if (cancelLisenter == null) {
                      Navigator.of(context).pop();
                    } else {
                      cancelLisenter();
                    }
                  },
                  child: cancelText,
                ))
              : Container(),
          cancelText != null && confirmText != null
              ? Container(
                  height: double.maxFinite,
                  margin: EdgeInsets.only(top: 0.3),
                  decoration: BoxDecoration(
                      border: Border(
                          left: Divider.createBorderSide(context,
                              width: virtualBorderWidth ?? 0.5,
                              color: virtualBorderColor ?? Color(0XFFACACAE)))),
                )
              : Container(),
          confirmText != null
              ? Expanded(
                  child: CupertinoButton(
                  padding: EdgeInsets.all(0),
                  pressedOpacity: 0.6,
                  onPressed: () {
                    if (confirmLisenter != null) {
                      confirmLisenter();
                    }
                  },
                  child: confirmText,
                ))
              : Container()
        ],
      ),
    );
  }
}
