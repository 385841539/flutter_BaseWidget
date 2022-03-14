// widget扩展：
import 'package:flutter/material.dart';

class MyWidget extends Widget{
  @override
  Element createElement() {
    // TODO: implement createElement
    throw UnimplementedError();
  }

}
extension WidgetExt on Widget {
  Widget padding(EdgeInsetsGeometry padding) {
    return Padding(
      child: this,
      padding: padding,
    );
  }

  Material gesture({
    GestureTapCallback onTap,
    GestureTapCallback onDoubleTap,
    GestureLongPressCallback onLongPress,
  }) {
    return Material(
      child: InkWell(
        child: this,
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
      ),
    );
  }
}

// String扩展：
extension StringExt on String {
  double toDouble() {
    return double.parse(this);
  }

  int toInt() {
    return int.parse(this);
  }

  bool isMobile() {
    return RegExp(
            r'^((13[0-9])|(14[5,7,9])|(15[^4])|(18[0-9])|(17[0,1,3,5,6,7,8])|(19)[0-9])\d{8}$')
        .hasMatch(this);
  }
}

// Object扩展：
extension ObjectExt on Object {
  bool isNullOrEmpty() {
    if (this is String)
      return (this as String).isEmpty;
    else if (this is Iterable) return (this as Iterable).isEmpty;
    return this == null;
  }
}

// bool扩展：
extension BoolExt on bool {
  bool not() {
    return !this;
  }

  bool and(bool val) {
    return this && val;
  }

  bool or(bool val) {
    return this || val;
  }
}

//泛型扩展：
extension AllExt<T> on T {
  T apply(f(T e)) {
    f(this);
    return this;
  }

  R let<R>(R f(T e)) {
    return f(this);
  }
}
