import 'package:flutter_common_plugin/base_lib.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'package:flutter/material.dart';

/// 经典Header
class FBHomeRefreshHeader extends Header {
  static const double Refresh_Extent = 90.0;
  static const double Refresh_TriggerDistance = 90.0;

  /// Key
  final Key key;
  final bool isDarkModel;
  final Function(RefreshMode) refreshCallBack;

  FBHomeRefreshHeader(
      {double extent = Refresh_Extent,
      double triggerDistance = Refresh_TriggerDistance,
      bool float = false,
      bool enableInfiniteRefresh = false,
      bool enableHapticFeedback = false,
      this.isDarkModel = true,
      this.key,
      this.refreshCallBack})
      : super(
          extent: extent,
          triggerDistance: triggerDistance,
          float: float,
          enableInfiniteRefresh: enableInfiniteRefresh,
          enableHapticFeedback: enableHapticFeedback,
          completeDuration: Duration(milliseconds: 500),
        );

  @override
  Widget contentBuilder(
      BuildContext context,
      RefreshMode refreshState,
      double pulledExtent,
      double refreshTriggerPullDistance,
      double refreshIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration completeDuration,
      bool enableInfiniteRefresh,
      bool success,
      bool noMore) {
    if (refreshCallBack != null) {
      refreshCallBack(refreshState);
    }
    return FBHomeRefreshHeaderWidget(
      key: key,
      refreshState: refreshState,
      pulledExtent: pulledExtent,
      refreshTriggerPullDistance: refreshTriggerPullDistance,
      isDarkModel: isDarkModel,
    );
  }
}

/// 经典Header组件
class FBHomeRefreshHeaderWidget extends StatefulWidget {
  final RefreshMode refreshState;
  final double pulledExtent;
  final double refreshTriggerPullDistance;

  final bool hasSecondFloor;
  final bool isDarkModel;

  FBHomeRefreshHeaderWidget({
    Key key,
    this.refreshState,
    this.pulledExtent,
    this.hasSecondFloor,
    this.refreshTriggerPullDistance,
    this.isDarkModel = true,
  }) : super(key: key);

  @override
  FBHomeRefreshHeaderWidgetState createState() =>
      FBHomeRefreshHeaderWidgetState();
}

class FBHomeRefreshHeaderWidgetState extends State<FBHomeRefreshHeaderWidget>
    with TickerProviderStateMixin<FBHomeRefreshHeaderWidget> {
  // 是否到达触发刷新距离
  bool _overTriggerDistance = false;

  bool get overTriggerDistance => _overTriggerDistance;

  set overTriggerDistance(bool over) {
    if (_overTriggerDistance != over) {
      _overTriggerDistance = over;
    }
  }

  /// 文本
  static const String _refreshText = "下拉刷新";

  static const String _refreshReadyText = "释放刷新";

  static const String _refreshingText = "刷新中...";

  static const String _refreshedText = "刷新完成";

  // 显示文字
  String get _showText {
    switch (widget.refreshState) {
      case RefreshMode.refresh:
        return _refreshingText;
      case RefreshMode.armed:
        return _refreshingText;
      case RefreshMode.refreshed:
        return _finishedText;
      case RefreshMode.done:
        return _finishedText;
      default:
        if (overTriggerDistance) {
          return _refreshReadyText;
        } else {
          return _refreshText;
        }
    }
  }

  // 刷新结束文字
  String get _finishedText {
    return _refreshedText;
  }

  @override
  Widget build(BuildContext context) {
    // 是否到达触发刷新距离
    overTriggerDistance = widget.refreshState != RefreshMode.inactive &&
        widget.pulledExtent >= widget.refreshTriggerPullDistance;

    return Container(
        height: FBScreenUtil.getScreenHeight(),
        decoration: widget?.isDarkModel ?? true
            ? BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xFF444E5C),
                  Color(0xFF3A3E44),
                  Color(0xFF3C3B3F)
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              )
            : BoxDecoration(color: Colors.white),
        padding: EdgeInsets.only(bottom: 20),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 5),
                child: refreshImage(_showText)),
            buildText(_showText)
          ],
        )
        // Text(_showText, style: TextStyle(color: Colors.white, fontSize: 18)),
        );
  }

  Widget buildText(String text) {
    return Text(
      text ?? "",
      style: TextStyle(
          fontSize: 18.0,
          color:
              widget?.isDarkModel ?? true ? Colors.white : Color(0xFF444E5C)),
    );
  }

  Widget refreshImage(String text) {

    return Text("你好啊");
  //   switch (text) {
  //     case _refreshText:
  //       return Image.asset(
  //         widget?.isDarkModel ?? true
  //             ? "packages/flutter_common_plugin/images/refresh/refresh_arrow_down.png"
  //             : "packages/flutter_common_plugin/images/refresh/refresh_arrow_down_black.png",
  //         height: 20,
  //         fit: BoxFit.contain,
  //       );
  //     case _refreshReadyText:
  //       return Image.asset(
  //         widget?.isDarkModel ?? true
  //             ? "packages/flutter_common_plugin/images/refresh/refresh_arrow_up.png"
  //             : "packages/flutter_common_plugin/images/refresh/refresh_arrow_up_black.png",
  //         height: 20,
  //         fit: BoxFit.contain,
  //       );
  //     case _refreshingText:
  //       return SizedBox(
  //         height: 20,
  //         width: 20,
  //         child: CircularProgressIndicator(
  //           strokeWidth: 2.4,
  //           valueColor: AlwaysStoppedAnimation(
  //               widget?.isDarkModel ?? true ? Colors.white : Color(0xFF444E5C)),
  //         ),
  //       );
  //     case _refreshedText:
  //     default:
  //       return Container(
  //         height: widget?.isDarkModel ?? true ? 20 : 0,
  //         width: widget?.isDarkModel ?? true ? 20 : 0,
  //       );
  //   }
  }
}
