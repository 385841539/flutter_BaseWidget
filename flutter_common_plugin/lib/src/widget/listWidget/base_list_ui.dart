import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:flutter_common_plugin/base_lib.dart';

import 'package:flutter_easyrefresh/easy_refresh.dart';


abstract class BaseListUi {
  EasyRefreshController controller = EasyRefreshController();
  Header header;
  Footer footer;

  // this.textColor: ,
  // this.infoColor: ,
  Color headerTextColor = Colors.black;

  Color footerTextColor = Colors.teal;

  ///是否能下拉刷新
  bool _isCanRefresh = true;

  ///是否能上拉加载
  bool isCanLoad = false;
  ScrollController _scrollController;

  Axis scrollDirection = Axis.vertical;

  bool shrinkWrap = false;

  Key key;

  ///是否支持刷新
  bool useRefresh = false;

  BaseState _baseState;

  ///可否手动控制加载和刷新
  bool enableControlFinishLoad = false;
  bool enableControlFinishRefresh = false;

  Color appBarDefaultColor;
  Color appBarContentDefaultColor;

  ///滑动偏移量监听， 用于手势处理
  Function(double) _offsetListen;

  Function(double) mOffsetListen;

  ///头部回弹
  bool topBouncing = false;

  ///底部回弹
  bool bottomBouncing = false;

  BaseProvide mProvide;

  ///挂载 基础state
  void registerStateForList(BaseState baseState) {
    header = _getDefaultHeader();
    footer = _getDefaultFooter();
    _baseState = baseState;
    appBarDefaultColor = baseState.getNavBarBackgroundColor();
    appBarContentDefaultColor = baseState.getNavBarContentColor();
    mOffsetListen = (offset) {
      ///处理头部缩放
      _offsetListen?.call(offset);
    };
    scrollController = ScrollController();
  }

  Widget getListView(BuildContext context, BaseProvide provide) {
    this.mProvide = provide;
    List<Widget> listChildren = getMainChildrenWidget(context);

    return EasyRefresh.custom(
        onRefresh: isUseRefresh && isCanRefresh ? onRefreshCallback : null,
        onLoad: (isUseRefresh &&
            ((bottomBouncing) ||
                (mProvide?.enableLoadMore ?? false) ||
                isCanLoad ||
                (mProvide?.isShowNoMoreFooter ?? false)))
            ? onLoadCallback
            : null,
        key: key,
        header: isUseRefresh ? header : null,
        footer: isUseRefresh ? (_getFooter()) : null,
        controller: isUseRefresh ? controller : null,
        enableControlFinishLoad: isUseRefresh ? enableControlFinishLoad : false,
        enableControlFinishRefresh:
        isUseRefresh ? enableControlFinishRefresh : false,
        scrollController: scrollController,
        shrinkWrap: shrinkWrap,
        scrollDirection: scrollDirection,
        topBouncing: topBouncing,
        bottomBouncing: bottomBouncing,
        slivers: getAdapterWidget(listChildren));
  }

  ///返回不为空 则 依据 getMainChildrenWidget 来 绘制 ，
  ///否则根据 [getItemCount] 和  [getItem]来返回 列表
  List<Widget> getMainChildrenWidget(BuildContext context);

  List<Widget> getAdapterWidget(List<Widget> listChildren) {
    List<Widget> customScrollViewListChildren = [];
    if ((mProvide?.isEmpty ?? false) && (mProvide?.isEmptyWidgetHoldAll ?? false)) {
      customScrollViewListChildren.add(SliverToBoxAdapter(
        child: _baseState?.getErrorClickWidget() ?? Container(),
      ));
    } else {
      listChildren.forEach((widget) {
        if (widget is SliverToBoxAdapter ||
            widget is SliverPersistentHeader ||
            widget.runtimeType.toString().toLowerCase().contains("sliver")) {
          customScrollViewListChildren.add(widget);
        } else {
          customScrollViewListChildren.add(SliverToBoxAdapter(
            child: widget,
          ));
        }
      });
    }
    return customScrollViewListChildren;
  }

  Future onRefreshCallback() async {
    return null;
  }

  Future onLoadCallback() async {
    if (mProvide?.enableLoadMore == true) {
      await mProvide?.loadMore();
    }
  }

  Footer _getDefaultFooter() {
    return ClassicalFooter(
        noMoreText: "没有更多数据",
        loadingText: "加载中",
        loadFailedText: "加载失败",
        loadedText: "加载完成",
        infoText: "更新于%T");
  }

  Header _getDefaultHeader() {
    return ClassicalHeader(
        refreshedText: "刷新完成",
        refreshingText: "刷新中...",
        refreshText: "下拉刷新",
        refreshReadyText: "释放刷新",
        textColor: headerTextColor,
        infoText: "更新于%T");
  }

  bool get isCanRefresh => _isCanRefresh || (mProvide?.isCanRefresh ?? false);

  set isCanRefresh(bool value) {
    _isCanRefresh = value;
    mProvide?.isCanRefresh = value;
  }

  ScrollController get scrollController => _scrollController;

  set scrollController(ScrollController scrollControl) {
    _scrollController = scrollControl;
    _addOffsetListen();
  }

  set offsetListen(Function(double) offsetListen) {
    _offsetListen = offsetListen;
  }

  bool get isUseRefresh => useRefresh || (mProvide?.useRefresh ?? false);

  set isUseRefresh(bool value) {
    useRefresh = value;
    mProvide?.useRefresh = value;
  }

  void setSafeState() {
    _baseState?.setSafeState();
  }

  void _addOffsetListen() {
    scrollController?.addListener(() {
      mOffsetListen?.call(scrollController?.offset);
    });
  }

  _getFooter() {
    if (mProvide?.enableLoadMore ?? true) {
      return footer;
    } else if ((mProvide?.isShowNoMoreFooter ?? false) &&
        (!(mProvide?.isEmpty ?? true))) {
      return getNoMoreFooter();
    }
    return EmptyFooter(overScroll: bottomBouncing);
  }

  Footer getNoMoreFooter() {
    return NoMoreFooter(overScroll: bottomBouncing);
  }
}