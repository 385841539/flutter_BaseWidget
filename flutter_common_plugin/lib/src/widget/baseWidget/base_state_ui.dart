import 'dart:ui';

import 'package:flutter/material.dart';

import '../../provider/base_model.dart';
import '../../route/nav_utils.dart';
import '../appbar/base_app_bar.dart';
import 'base_state_config.dart';

abstract class BasePageUI {
  BuildContext _context;

  ///状态栏高度
  double _statusBarHeight;

  ///状态栏是否可见
  bool _isStatusBarVisible;

  ///状态栏颜色
  Color _statusBarColor;

  ///导航栏是否可见
  bool _isNavigationBarVisible;

  ///导航栏颜色
  Color _navigationBaFBackgroundColor;

  ///导航栏高度
  double _navigatorBarHeight;

  /// 背景颜色
  Color _backGroundColor;

  ///导航栏返回按钮做内边距
  double _navLeftPadding;

  ///导航栏返回按钮颜色
  Color _navBarContentColor;

  ///导航栏 左边布局是否可见
  bool _navBarLeftVisible;

  bool _navBarCenterVisible;

  String _centerTitle;
  String _rightText;

  double _titleSize;

  bool isErrorWidgetVisible = false;

  String _errorText = "错误了";

  String _errorImgPath;

  bool _isBuild = false;
  bool _isHeadFloating = false;

  FBAppBarControl appBarControl = FBAppBarControl();
  Function setStateCallBack;

  IconData _backIcon;

  double _centerTitlePosition;

  String mBackGroundImagePath;

  BoxFit mBackImageFit;

  ///垂直布局水平方向的 布局方式
  CrossAxisAlignment crossAxisAlignment;

  ///如果需要用到布局最大高度 ，且头部和底部 有 其他 非主容器的 布局
  ///需要减去非主容器的布局高度 ，才能拿到准确的 总布局高度
  double _verticalPaddingSize = 0;

  double get verticalPaddingSize => _verticalPaddingSize ?? 0;

  set verticalPaddingSize(double value) {
    _verticalPaddingSize = value;
  }

  bool get isHeadFloating => _isHeadFloating;

  set isHeadFloating(bool value) {
    _isHeadFloating = value;
    _setState();
  }

  registerSetStateCalBack(Function setStateCallBack) {
    this.setStateCallBack = setStateCallBack;
  }

  BaseProvide mBaseProvide;

  Widget uiBuild(BuildContext context, {BaseProvide model}) {
    return _build(context, model);
  }

  bool _needHorizontalPadding() {
    return horizontalPadding != null && horizontalPadding > 0;
  }

  ///开发者 的布局逻辑
  List<Widget> _getColumnList(BuildContext context,
      {bool showStatusBar = true}) {
    List<Widget> list = [];

    if (showStatusBar) {
      ///状态栏部分
      list.add(_getStatusBar());

      ///导航栏部分
      list.add(_getNavigationBar());
    }

    Widget header = getTopHeader();
    List<Widget> headers = getTopHeaders();
    if (header != null) {
      list.add(header);
    }

    if (headers != null && headers.isNotEmpty) {
      list.addAll(headers);
    }
    Widget mainWidget;

    bool isShowError = false;

    ///如果 在显示 错误布局， 则  不显示内容部分
    if ((mBaseProvide?.isEmptyWidgetHoldAll == true) &&
        getIsErrorWidgetVisible()) {
      isShowError = true;
      list.add(Expanded(child: getErrorClickWidget()));
    } else {
      mainWidget = getMainWidget(context);

      /// 主布局逻辑部分  ,  如果子布局 不需要列表 ，
      /// 则直接重写 [getMainWidget] 方法即可
      if (mainWidget != null) {
        list.add(Expanded(
          child: _needHorizontalPadding()
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: mainWidget,
                )
              : mainWidget,
        ));
      } else {
        list.addAll(_needHorizontalPadding()
            ? getMainChildrenWidget(context)
                .map((widget) => Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: widget,
                    ))
                ?.toList()
            : getMainChildrenWidget(context));
      }
    }

    Widget footer = getBottomFooter();
    List<Widget> footers = getBottomFooters();

    if (footer != null || footers != null) {
      if ((isShowError != true) && mainWidget == null) {
        //这种情况需要填充 expand ， 以让底部沉底

        list.add(Expanded(child: Container()));
      }
      if (footer != null) {
        list.add(footer);
      }
      if (footers != null) {
        list.addAll(footers);
      }
    }

    return list;
  }

  ///是否使用脚手架布局
  bool useBaseLayout() {
    return true;
  }

  ///状态栏 布局 ， 可重写
  Widget getStatusBar() {
    return Container(
      height: getStatusBarHeight(),
      color:
          _statusBarColor ?? BaseUiConfig.globalStatusBarColor ?? Colors.white,
    );
  }

  ///导航栏 布局 ， 可重写
  Widget _getNavigationBar() {
    return isNavigationBarVisible() ? getNavigationBar() : Container();
  }

  Widget getNavigationBar() {
    return FBAppBar(
      title: getTitle() ?? "",
      navigationBarBackgroundColor: _navigationBaFBackgroundColor,
      navBarContentColor: _navBarContentColor,
      leftWidget: getNavBarLeftWidget(),
      centerWidget: getNavCenterWidget(),
      rightWidget: getNavBarRightWidget(),
      isLeftVisible: _navBarLeftVisible ?? true,
      isCenterVisible: _navBarCenterVisible ?? true,
      navLeftPadding: _navLeftPadding,
      navBarHeight: getNavBarHeight(),
      titleSize: _titleSize,
      backIcon: _backIcon,
      centerTitlePosition: _centerTitlePosition,
      onBackClick: onBackClick,
      baseAppBarControl: appBarControl,
    );
  }

  ///设置状态栏是否可见
  void setStatusBarVisible(bool isVisible) {
    _isStatusBarVisible = isVisible;
    _setState();
  }

  bool isBuild() {
    return _isBuild;
  }

  void setSafeState() {
    _setState();
  }

  void _setState() {
    if (_isBuild) {
      setStateCallBack?.call();
    }
  }

  ///设置状态栏颜色
  void setStatusBarColor(Color color) {
    _statusBarColor = color;
    _setState();
  }

  ///设置 返回按钮 icon
  void setBackIcon(IconData backIcon) {
    _backIcon = backIcon;
    _setState();
  }

  ///设置导航栏颜色
  void setNavigationBarColor(Color color, {bool isChangeWithStatusBar = true}) {
    if (color != getNavBarBackgroundColor()) {
      _navigationBaFBackgroundColor = color;
      if (isChangeWithStatusBar) {
        _statusBarColor = color;
      }
      _setState();
    }
  }

  Color getNavBarBackgroundColor() {
    return _navigationBaFBackgroundColor ??
        BaseUiConfig.globalNavigationBarBackgroundColor ??
        Colors.white;
  }

  Color getNavBarContentColor() {
    return _navBarContentColor ??
        BaseUiConfig.globalNavigationBarContentColor ??
        Colors.white;
  }

  ///设置导航栏高度
  void setNavigationBarHeight(double height) {
    _navigatorBarHeight = height;
    _setState();
  }

  ///设置背景颜色
  void setBackgroundColor(Color color) {
    _backGroundColor = color;
    _setState();
  }

  ///设置状态栏高度
  void setStatusBarHeight(double height) {
    _statusBarHeight = height;
    _setState();
  }

  void setNavigationBarVisible(bool visible) {
    _isNavigationBarVisible = visible;
    _setState();
  }

  ///设置返回按钮左边距
  void setNavLeftPadding(double padding) {
    _navLeftPadding = padding;
    _setState();
  }

  ///设置导航栏 中间部分的位置
  void setNavBarCenterPosition(double leftPosition,
      {bool isCenterPosition = false}) {
    if (isCenterPosition) {
      _centerTitlePosition = -1;
    } else {
      _centerTitlePosition = leftPosition;
    }
    _setState();
  }

  ///设置 导航栏 内容颜色
  void setNavBarContentColor(Color color) {
    _navBarContentColor = color;
    _setState();
  }

  ///设置返回按钮颜色
  void setNavBarLeftVisible(bool visible) {
    _navBarLeftVisible = visible;
    appBarControl?.setLeftVisible?.value = visible;
  }

  ///导航栏左半部分 ， 可重写
  Widget getNavBarLeftWidget() {
    return null;
  }

  ///点击返回按钮
  Future<bool> onBackClick() async {
    print("返回..");
    FBNavUtils.close(_context);
    return true;
  }

  double getStatusBarHeight() {
    return _statusBarHeight ?? MediaQuery.of(_context).padding.top ?? 0;
  }

  double getNavBarHeight() {
    return _navigatorBarHeight ??
        BaseUiConfig.globalNavigationBarHeight ??
        kToolbarHeight;
  }

  ///导航栏中间组件 ， 可重写
  Widget getNavCenterWidget() {
    return null;
  }

  void setTitle(String content) {
    if (_centerTitle != content) {
      _centerTitle = content;
      appBarControl?.setPageTitle?.value = content;
    }
  }

  void setRightText(String rightText) {
    if (_rightText != rightText) {
      _rightText = rightText;

      setSafeState();
    }
  }

  void setTitleSize(double titleSize) {
    _titleSize = titleSize;
    _setState();
  }

  void setTitleVisible(bool isVisible) {
    _navBarCenterVisible = isVisible;
    appBarControl?.setCenterVisible?.value = isVisible;
  }

  String getTitle() {
    return _centerTitle;
  }

  /// 导航栏右侧部分 , 可重写
  Widget getNavBarRightWidget() {
    return _rightText == null
        ? Container()
        : TextButton(
            onPressed: onAppBarRightClick,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "$_rightText",
                style: TextStyle(
                    color: Color(0xFF01C2C3), fontWeight: FontWeight.w700),
              ),
            ),
          );
  }

  ///单控件 布局 ，，如果重写这个方法 ，  [getMainWidget] 的布局 将失效
  Widget getMainWidget(BuildContext context) {
    return null;
  }

  ///返回 主布局 以列表形式 ，如果重写这个方法 ，  [getMainWidget] 的布局 将失效
  List<Widget> getMainChildrenWidget(BuildContext context);

  EdgeInsetsGeometry padding;

  ///水平内边距
  double horizontalPadding;

  void setPadding(EdgeInsetsGeometry padding) {
    this.padding = padding;
    _setState();
  }

  bool getIsErrorWidgetVisible() {
    return (((mBaseProvide?.isEmpty ?? false) || isErrorWidgetVisible)) ??
        false;
  }

  ///显示和隐藏 错误布局 ， 可以配置 错误图片路径 和错误内容
  void setErrorWidgetVisible(bool visible,
      {String errImgPath, String errTextString}) {
    if (isErrorWidgetVisible != visible ||
        _errorImgPath != _errorImgPath ||
        _errorText != errTextString) {
      isErrorWidgetVisible = visible;
      if (errImgPath != null) {
        _errorImgPath = errImgPath;
      }

      if (errTextString != null) {
        _errorText = errTextString;
      }
      _setState();
    }
  }

  Widget getErrorText(double paddingBottom) {
    return Container(
        margin: EdgeInsets.only(top: 30, bottom: 20),
        child: Text(
          mBaseProvide?.errorText ?? _errorText ?? "",
          style: TextStyle(fontSize: 18, color: Color(0XFFABADC2)),
        ));
  }

  Widget getErrorClickWidget() {
    return GestureDetector(
      onTap: () {
        onErrorClick();
      },
      child: Container(
        // color: Colors.red,
        width: double.infinity,
        // height: getMainContentHeight(),
        child: getErrorWidget(),
      ),
    );
  }

  ///可以显示 空 数据 或者 网络错误等

  Widget getErrorWidget() {
    Widget footer = getErrorFooter();
    Widget header = getErrorHeader();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        header == null
            ? Container(
                height: 140,
              )
            : header,
        getErrorImg(),
        getErrorText(footer == null ? 200 : 20),
        footer == null ? Container() : footer,
      ],
    );
  }

  ///状态栏是否显示
  bool isStatusBarVisible() {
    return _isStatusBarVisible ?? BaseUiConfig.globalIsStatusBarVisible ?? true;
  }

  ///导航栏是否显示
  bool isNavigationBarVisible() {
    return _isNavigationBarVisible ??
        BaseUiConfig.globalNavigationBarVisible ??
        true;
  }

  ///主内容 布局的 可用最大高度
  double getMainContentHeight() {
    return (window.physicalSize.height /
            MediaQuery.of(_context).devicePixelRatio) -
        (isStatusBarVisible() ? getStatusBarHeight() : 0) -
        (isNavigationBarVisible() ? getNavBarHeight() : 0) -
        (verticalPaddingSize ?? 0);
  }

  Widget getErrorImg() {
    return Container(
      child: Image.asset(
        getErrorImgPath(),
        width: 120,
        height: 120,
      ),
    );
  }

  String getErrorImgPath() {
    return mBaseProvide?.errorImgPath ??
        _errorImgPath ??
        BaseUiConfig.globalErrorImgPath ??
        "";
  }

  ///隐藏状态栏和导航栏
  void hideStatusWithNavigationBar({bool visible = false}) {
    if (_isStatusBarVisible != visible) {
      setStatusBarVisible(visible);
      setNavigationBarVisible(visible);
    }
  }

  Widget _buildLayout(BuildContext context) {
    List<Widget> floatWidgets = getFloatWidgets();
    return !useBaseLayout()
        ? getMainWidget(context)
        : (isHeadFloating || (floatWidgets != null && floatWidgets.isNotEmpty))

            ///悬浮 导航栏 的话 ， 用stack包裹 ， 可拓展成 顶部随手势 改变透明度
            ? _getFloatingLayout(context, floatWidgets)
            : Column(
                crossAxisAlignment:
                    crossAxisAlignment ?? CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: _getColumnList(context),
              );
  }

  ///点击错误或空布局调此方法 ， 可重写
  void onErrorClick() {
    try {
      mBaseProvide?.requestData();
    } catch (e) {}
  }

  void setBackImage(String backGroundImage, {BoxFit fit = BoxFit.fill}) {
    mBackGroundImagePath = backGroundImage;
    mBackImageFit = fit;
  }

  Widget _getStatusBar() {
    return isStatusBarVisible() ? getStatusBar() : Container();
  }

  ///错误布局底部
  Widget getErrorFooter() {
    return null;
  }

  ///错误布局头部
  Widget getErrorHeader() {
    return null;
  }

  ///悬浮 在顶层的布局， 重写可以实现 ,容器为: stack
  List<Widget> getFloatWidgets() {
    return null;
  }

  List<Widget> _getFloatingWidgets(List<Widget> floatWidgets) {
    if (floatWidgets == null) {
      return [];
    }
    return floatWidgets;
  }

  ///一些页面 整体 样式
  Widget _build(BuildContext context, BaseProvide model) {
    if (_isBuild != true) {
      this.mBaseProvide = model;
      this._context = context;
      _isBuild = true;
    }
    return Material(
      ///页面背景
      color: _backGroundColor ??
          BaseUiConfig.globalPageBackgroundColor ??
          Colors.white,

      ///如果有设置图片背景
      child: (mBackGroundImagePath == null || mBackGroundImagePath.isEmpty)
          ? (padding == null
              ? _buildLayout(context)
              : Container(
                  padding: padding,
                  child: _buildLayout(context),
                ))
          : Container(
              padding: padding,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  alignment: AlignmentDirectional.topStart,
                  fit: mBackImageFit ?? BoxFit.fill,

                  ///这里只是本地图片 ， 如果需要网络 图片 则可以拓展
                  image: AssetImage(mBackGroundImagePath),
                ),
              ),
              child: _buildLayout(context),
            ),
    );
  }

  void onAppBarRightClick() {}

  ///悬浮情况的布局
  _getFloatingLayout(BuildContext context, List<Widget> floatWidgets) {
    return Stack(children: [
      Column(
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: _getColumnList(context, showStatusBar: !isHeadFloating),
      ),

      ///状态栏
      _getStatusBar(),

      ///导航栏
      Positioned(
        child: Container(
          padding: EdgeInsets.only(
              top: isStatusBarVisible() ? getStatusBarHeight() : 0),
          child: isNavigationBarVisible() ? getNavigationBar() : Container(),
        ),
      ),

      ///页面上的悬浮控件，需要 重写方法即可
      ..._getFloatingWidgets(floatWidgets),
    ]);
  }

  Widget getBottomFooter() {
    return null;
  }

  Widget getTopHeader() {
    return null;
  }

  List<Widget> getBottomFooters() {
    return null;
  }

  List<Widget> getTopHeaders() {
    return null;
  }
}
