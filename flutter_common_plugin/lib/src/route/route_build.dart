import 'package:flutter/material.dart';

class CustomerRoute extends PageRouteBuilder {
  final Widget widget;
  final RouteSettings setting;

  CustomerRoute(this.widget, this.setting)
      : super(
            transitionDuration: Duration(seconds: 1),
            pageBuilder: (
              BuildContext context,
              Animation<double> animation1,
              Animation<double> animation2,
            ) {
              return widget;
            },
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation1,
              Animation<double> animation2,
              Widget child,
            ) {
//      //逐渐消失的动画效果
//      return FadeTransition(
//        opacity: Tween(begin: 0.0,end: 1.0) //设置不透明度
//        .animate(CurvedAnimation(
//            parent: animation1,
//            curve: Curves.fastOutSlowIn)
//        ),
//      child: child,
//      );

//    //缩放的动画效果
//      return ScaleTransition(
//        scale: Tween(begin: 0.0, end: 1.0).animate(
//          CurvedAnimation(
//            parent: animation1,
//            curve: Curves.fastOutSlowIn
//          )
//        ),
//        child: child,
//      );

//    //旋转+缩放动画效果
//      return RotationTransition(
//        turns: Tween(begin: 0.0, end:1.0).animate(
//          CurvedAnimation(
//            parent: animation1,
//            curve: Curves.fastOutSlowIn,
//          )
//        ),
//        child: ScaleTransition(
//          scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
//            parent: animation1,
//            curve: Curves.fastOutSlowIn,
//          )),
//          child: child,
//        ),
//      );

              //左右滑动动画效果
              return SlideTransition(
                position: Tween<Offset>(
                        begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0))
                    .animate(CurvedAnimation(
                        parent: animation1, curve: Curves.fastOutSlowIn)),
                child: child,
              );
            });
}
