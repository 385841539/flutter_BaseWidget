import 'package:flutter/material.dart';

class FBDoubleWidget extends StatelessWidget {
  ///文本位于图片左边或者上面，false 时则位于下面或者右边，结合[direction]
  final bool isTextLeftOrTop;

  ///排列方向 , 是否水平
  final bool isHorizontal;

  ///图片控件(可以是其他widget)
  final Widget widget2;

  ///文本控件(可以是其他widget)
  final Widget widget1;

  ///两个Widget的间距
  final double distance;

  ///控件宽度，不指定则最小
  final double width;

  ///控件高度，不指定则最小
  final double height;
  final GestureTapCallback onTap;

  final EdgeInsetsGeometry padding;
  final Decoration decoration;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  final Color backColor;

  FBDoubleWidget(
    this.widget1,
    this.widget2, {
    this.isTextLeftOrTop = true,
    this.width,
    this.height,
    this.isHorizontal = false,
    this.distance = 10,
    this.padding,
    this.decoration,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.onTap,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.backColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          color: decoration == null ? (backColor ?? Colors.white) : null,
          padding: padding,
          decoration: decoration,
          width: width,
          height: height,
          child: getFlex(),
        ));

    // return  getFlex();
  }

  Widget getText() {
    return widget1;
  }

  Widget getImageView() {
    return widget2;
  }

  Widget getFlex() {
    return Flex(
      mainAxisSize: MainAxisSize.min,
      direction: isHorizontal ?? true ? Axis.horizontal : Axis.vertical,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        isTextLeftOrTop ?? true ? getText() : getImageView(),
        SizedBox(
          width: isHorizontal ?? true ? distance : 0,
          height: isHorizontal ?? true ? 0 : distance,
        ),
        isTextLeftOrTop ?? true ? getImageView() : getText(),
      ],
    );
  }
}
