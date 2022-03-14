import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common_plugin/base_lib.dart';

class FBAppBar extends StatefulWidget {
  final double navBarHeight;
  final double statusBarHeight;
  final double titleSize;
  final String title;
  final Color navBarContentColor;
  final Color navigationBarBackgroundColor;
  final Widget leftWidget;
  final Widget centerWidget;
  final Widget rightWidget;
  final VoidCallback onBackClick;
  final bool isLeftVisible;
  final bool isCenterVisible;
  final bool isHaveStatusBar;
  final double navLeftPadding;
  final double centerTitlePosition;
  final FBAppBarControl baseAppBarControl;
  final IconData backIcon;

  FBAppBar(
      {this.title = "",
      this.navBarContentColor,
      this.navigationBarBackgroundColor,
      this.leftWidget,
      this.centerWidget,
      this.rightWidget,
      this.isLeftVisible = true,
      this.isCenterVisible = true,
      this.navLeftPadding = 10,
      this.navBarHeight = 48,
      this.statusBarHeight,
      this.titleSize = 20,
      this.onBackClick,
      this.baseAppBarControl,
      this.isHaveStatusBar = false,
      this.backIcon,
      this.centerTitlePosition});

  @override
  _FBAppBarState createState() => _FBAppBarState(title, isHaveStatusBar,
      isLeftVisible, isCenterVisible, baseAppBarControl, centerTitlePosition);
}

class _FBAppBarState extends State<FBAppBar> {
  bool isLeftVisible;

  bool isCenterVisible;

  String title;
  FBAppBarControl baseAppBarControl;

  final bool isHaveStatusBar; //是否有状态栏

  final double centerTitlePosition;

  double _mSetOffsetScale = 1;

  double get mSetOffsetScale =>
      (_mSetOffsetScale ?? 1) < 0 ? 0 : (_mSetOffsetScale ?? 1);

  _FBAppBarState(
    this.title,
    this.isHaveStatusBar,
    this.isLeftVisible,
    this.isCenterVisible,
    this.baseAppBarControl,
    this.centerTitlePosition,
  ) {
    setTitle(String title) {
      if (this.title != title) {
        setState(() {
          this.title = title;
        });
      }
    }

    setLeftVisible(bool isLeftVisible) {
      if (this.isLeftVisible != isLeftVisible) {
        setState(() {
          this.isLeftVisible = isLeftVisible;
        });
      }
    }

    setCenterVisible(bool isCenterVisible) {
      if (this.isCenterVisible != isCenterVisible) {
        setState(() {
          this.isCenterVisible = isCenterVisible;
        });
      }
    }

    if (baseAppBarControl != null) {
      baseAppBarControl.setPageTitle?.addListener(() {
        setTitle(baseAppBarControl.setPageTitle?.value);
      });
      baseAppBarControl.setLeftVisible?.addListener(() {
        setLeftVisible(baseAppBarControl.setLeftVisible?.value);
      });
      baseAppBarControl.setCenterVisible?.addListener(() {
        setCenterVisible(baseAppBarControl.setCenterVisible?.value);
      });

      baseAppBarControl.setOffsetScale?.addListener(() {
        setOffsetScale(baseAppBarControl.setOffsetScale?.value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // FBScreenUtil.getStatusBarHeight()
    return isHaveStatusBar
        ? Column(
            children: [
              Container(
                height:
                    widget.statusBarHeight ?? FBScreenUtil.getStatusBarHeight(),
                color: widget.navigationBarBackgroundColor ??
                    BaseUiConfig.globalNavigationBarBackgroundColor ??
                    Colors.white,
              ),
              getNavBar()
            ],
            mainAxisSize: MainAxisSize.min,
          )
        : getNavBar();
  }

  double getHeight() {
    return widget.navBarHeight;
  }

  Widget _getNavBarLeftWidget() {
    return RawMaterialButton(
      padding: EdgeInsets.only(
          right: widget.navLeftPadding ?? 15,
          left: widget.navLeftPadding ?? 15,
          top: widget.navBarHeight / 2,
          bottom: widget.navBarHeight / 2),
      onPressed: widget.onBackClick == null
          ? () {
              FBNavUtils.close(context);
            }
          : widget.onBackClick,
      // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      highlightColor: Colors.transparent,
      constraints: BoxConstraints(
        minHeight: widget.navBarHeight < 0 ? 1 : widget.navBarHeight,
      ),
      child: widget.leftWidget ?? getNavBarLeftWidget(),
    );
  }

  ///导航栏左半部分 ， 可重写
  Widget getNavBarLeftWidget() {
    return Icon(
      widget?.backIcon ??
          BaseUiConfig.globalBackIcon ??
          Icons.arrow_back_ios_rounded,
      color: widget.navBarContentColor ??
          BaseUiConfig.globalNavigationBarContentColor ??
          Colors.white,
    );
  }

  Widget getNavCenterWidget() {
    return widget.centerWidget ??
        Text(
          title ?? "",
          style: TextStyle(
              fontSize:
                  (widget.titleSize ?? BaseUiConfig.globalTitleSize ?? 20),
              color: widget.navBarContentColor ??
                  BaseUiConfig.globalNavigationBarContentColor ??
                  Colors.white),
        );
  }

  Widget getNavBar() {
    return Container(
        width: double.infinity,
        height: mSetOffsetScale * getHeight(),
        color: widget.navigationBarBackgroundColor ??
            BaseUiConfig.globalNavigationBarBackgroundColor ??
            Colors.white,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            Positioned(
              ///导航左部分
              left: 0,
              // child: Container(),
              child:
                  isLeftVisible ?? true ? _getNavBarLeftWidget() : Container(),
              // color: Colors.green,
            ),

            ///导航栏中间部分
            ((centerTitlePosition ??
                        BaseUiConfig.globalCenterTitlePosition ??
                        0) >
                    0)
                ? Positioned(
                    left: 54,
                    child: isCenterVisible ??
                            BaseUiConfig.globalNavBarCenterVisible ??
                            true
                        ? getNavCenterWidget()
                        : Container(),
                  )
                : getNavCenterWidget(),

            Positioned(

                ///导航右部分
                right: 0,
                // child: Container(),
                child: widget.rightWidget ?? Container()
                // color: Colors.green,
                )
          ],
        ));
  }

  void setOffsetScale(double value) {
    print("----value:$value");
    if (_mSetOffsetScale != value) {
      _mSetOffsetScale = value;
      setState(() {});
    }
  }
}

class FBAppBarControl {
  ///容易变更的几个属性放在这里单独控制
  ValueNotifier<String> setPageTitle = ValueNotifier("");
  ValueNotifier<bool> setLeftVisible = ValueNotifier(true);
  ValueNotifier<bool> setCenterVisible = ValueNotifier(true);
  ValueNotifier<double> setOffsetScale = ValueNotifier(1);

  //小余0 则居中， 否则 则以设置的值

  void dispose() {
    setPageTitle?.dispose();
    setLeftVisible?.dispose();
    setCenterVisible?.dispose();
    setOffsetScale?.dispose();
  }
}
