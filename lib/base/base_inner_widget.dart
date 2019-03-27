import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_widget/network/api.dart';

///通常是和 viewpager 联合使用  ， 类似于Android 中的 fragment
/// 不过生命周期 还需要在容器父类中根据tab切换来完善
abstract class BaseInnerWidget extends StatefulWidget {
  BaseInnerWidgetState baseInnerWidgetState;
  int index;
  @override
  BaseInnerWidgetState createState() {
    baseInnerWidgetState = getState();
    index = setIndex();
    return baseInnerWidgetState;
  }

  ///作为内部页面 ， 设置是第几个页面 ，也就是在list中的下标 ， 方便 生命周期的完善
  int setIndex();

  BaseInnerWidgetState getState();
  String getStateName() {
    return baseInnerWidgetState.getClassName();
  }
}

abstract class BaseInnerWidgetState<T extends BaseInnerWidget> extends State<T>
    with AutomaticKeepAliveClientMixin {
  //平台信息
//  bool isAndroid = Platform.isAndroid;

//是不是debug
  bool isDebug = !bool.fromEnvironment("dart.vm.product");

  bool _isTopBarShow = false; //状态栏是否显示
  bool _isAppBarShow = false; //导航栏是否显示

  bool _isErrorWidgetShow = false; //错误信息是否显示

  Color _topBarColor = Colors.red;
  Color _appBarColor = Colors.red;
  Color _appBarContentColor = Colors.white;

  //标题字体大小
  double _appBarCenterTextSize = 20; //根据需求变更
  String _appBarTitle;

  //小标题信息
  String _appBarRightTitle;
  double _appBarRightTextSize = 15.0;

  String _errorContentMesage = "网络错误啦~~~";

  String _errImgPath = "images/load_error_view.png";

  bool _isLoadingWidgetShow = false;

  bool _isEmptyWidgetVisible = false;

  String _emptyWidgetContent = "暂无数据~";

  String _emptyImgPath = "images/ic_empty.png"; //自己根据需求变更

  double _bottomVsrtical; //作为内部页面距离底部的高度

  bool _isBackIconShow = false;

  FontWeight _fontWidget = FontWeight.w600; //错误页面和空页面的字体粗度
  @override
  void initState() {
    if (isDebug) {
      _appBarTitle = getClassName();
      _appBarRightTitle = "标题二";
    }
    onCreate();
    onResume();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _bottomVsrtical = getVerticalMargin();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: _getBaseView(context),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    onDestory();
    HttpManager.cancelHttp(getClassName());
    super.dispose();
  }

  void log(String content) {
    print(getClassName() + "-innerWidget-----:" + content);
  }

  ///页面被覆盖,暂停
  void onPause();

  ///相当于onResume, 只要页面来到栈顶， 都会调用此方法，网络请求可以放在这个方法
  void onResume();

  ///返回UI控件 相当于setContentView()
  Widget buildWidget(BuildContext context);

  ///初始化一些变量 相当于 onCreate ， 放一下 初始化数据操作
  void onCreate();

  ///页面注销方法
  void onDestory() {
    log("destory");
  }

  Widget _getBaseView(BuildContext context) {
    return Column(
      children: <Widget>[
        _getBaseTopBar(),
        _getBaseAppBar(),
        Container(
          width: getScreenWidth(),
          height: getMainWidgetHeight(),
          color: Colors.white, //背景颜色，可自己变更
          child: Stack(
            children: <Widget>[
              buildWidget(context),
              _getBaseErrorWidget(),
              _getBaseEmptyWidget(),
              _getBassLoadingWidget(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getBaseTopBar() {
    return Offstage(
      offstage: !_isTopBarShow,
      child: getTopBar(),
    );
  }

  Widget _getBaseAppBar() {
    return Offstage(
      offstage: !_isAppBarShow,
      child: getAppBar(),
    );
  }

  ///设置状态栏，可以自行重写拓展成其他的任何形式
  Widget getTopBar() {
    return Container(
      height: getTopBarHeight(),
      width: double.infinity,
      color: _topBarColor,
    );
  }

  ///设置状态栏隐藏或者显示
  void setTopBarVisible(bool isVisible) {
    setState(() {
      _isTopBarShow = isVisible;
    });
  }

  ///默认这个状态栏下，设置颜色
  void setTopBarBackColor(Color color) {
    setState(() {
      _topBarColor = color == null ? _topBarColor : color;
    });
  }

  ///导航栏 appBar 可以重写
  Widget getAppBar() {
    return Container(
      height: getAppBarHeight(),
      width: double.infinity,
      color: _appBarColor,
      child: Stack(
        alignment: FractionalOffset(0, 0.5),
        children: <Widget>[
          Align(
            alignment: FractionalOffset(0.5, 0.5),
            child: getAppBarCenter(),
          ),
          Align(
            //左边返回导航 的位置，可以根据需求变更
            alignment: FractionalOffset(0.02, 0.5),
            child: Offstage(
              offstage: !_isBackIconShow,
              child: getAppBarLeft(),
            ),
          ),
          Align(
            alignment: FractionalOffset(0.98, 0.5),
            child: getAppBarRight(),
          ),
        ],
      ),
    );
  }

  ///设置导航栏的字体以及图标颜色
  void setAppBarContentColor(Color contentColor) {
    if (contentColor != null) {
      setState(() {
        _appBarContentColor = contentColor;
      });
    }
  }

  ///设置导航栏隐藏或者显示
  void setAppBarVisible(bool isVisible) {
    setState(() {
      _isAppBarShow = isVisible;
    });
  }

  ///默认这个导航栏下，设置颜色
  void setAppBarBackColor(Color color) {
    setState(() {
      _appBarColor = color == null ? _appBarColor : color;
    });
  }

  void setAppBarTitle(String title) {
    if (title != null) {
      setState(() {
        _appBarTitle = title;
      });
    }
  }

  void setAppBarRightTitle(String title) {
    if (title != null) {
      setState(() {
        _appBarRightTitle = title;
      });
    }
  }

  ///暴露的错误页面方法，可以自己重写定制
  Widget getErrorWidget() {
    return Container(
      //错误页面中心可以自己调整
      padding: EdgeInsets.fromLTRB(0, 0, 0, 200),
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: InkWell(
          onTap: onClickErrorWidget,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage(_errImgPath),
                width: 150,
                height: 150,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(_errorContentMesage,
                    style: TextStyle(
                      fontWeight: _fontWidget,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getLoadingWidget() {
    return Container(
      //错误页面中心可以自己调整
      padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
      color: Colors.black12,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child:
            // 圆形进度条
            new CircularProgressIndicator(
          strokeWidth: 4.0,
          backgroundColor: Colors.blue,
          // value: 0.2,
          valueColor: new AlwaysStoppedAnimation<Color>(_appBarColor),
        ),

//        Container(
//          alignment: Alignment.center,
//          color: Colors.white70,
//          width: 200,
//          height: 200,
//          child: Text("你懂么？~~~"),
//        )
//
      ),
    );
  }

  ///导航栏appBar中间部分 ，不满足可以自行重写
  Widget getAppBarCenter() {
    return Text(
      _appBarTitle,
      style: TextStyle(
        fontSize: _appBarCenterTextSize,
        color: _appBarContentColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  ///导航栏appBar中间部分 ，不满足可以自行重写
  Widget getAppBarRight() {
    return Text(
      _appBarRightTitle == null ? "" : _appBarRightTitle,
      style: TextStyle(
        fontSize: _appBarRightTextSize,
        color: _appBarContentColor,
      ),
    );
  }

  ///导航栏appBar左边部分 ，不满足可以自行重写
  Widget getAppBarLeft() {
    return InkWell(
      onTap: clickAppBarBack,
      child: Icon(
        Icons.arrow_back,
        color: _appBarContentColor,
      ),
    );
  }

  void clickAppBarBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      //说明已经没法回退了 ， 可以关闭了
      finishDartPageOrApp();
    }
  }
//
//
//  defaultRouteName → String 启动应用程序时嵌入器请求的路由或路径。
//  devicePixelRatio → double 每个逻辑像素的设备像素数。 例如，Nexus 6的设备像素比为3.5。
//  textScaleFactor → double 系统设置的文本比例。默认1.0
//  toString（） → String 返回此对象的字符串表示形式。
//  physicalSize → Size 返回一个包含屏幕宽高的对象，单位是dp
//
//

  ///返回中间可绘制区域，也就是 我们子类 buildWidget 可利用的空间高度
  double getMainWidgetHeight() {
    double screenHeight = getScreenHeight() - _bottomVsrtical;

    if (_isTopBarShow) {
      screenHeight = screenHeight - getTopBarHeight();
    }
    if (_isAppBarShow) {
      screenHeight = screenHeight - getAppBarHeight();
    }

    return screenHeight;
  }

  ///返回屏幕高度
  double getScreenHeight() {
    return MediaQuery.of(context).size.height;
  }

  ///返回状态栏高度
  double getTopBarHeight() {
    return MediaQuery.of(context).padding.top;
  }

  ///返回appbar高度，也就是导航栏高度
  double getAppBarHeight() {
    return kToolbarHeight;
  }

  ///返回屏幕宽度
  double getScreenWidth() {
    return MediaQuery.of(context).size.width;
  }

  Widget _getBaseErrorWidget() {
    return Offstage(
      offstage: !_isErrorWidgetShow,
      child: getErrorWidget(),
    );
  }

  Widget _getBassLoadingWidget() {
    return Offstage(
      offstage: !_isLoadingWidgetShow,
      child: getLoadingWidget(),
    );
  }

  Widget _getBaseEmptyWidget() {
    return Offstage(
      offstage: !_isEmptyWidgetVisible,
      child: getEmptyWidget(),
    );
  }

  Widget getEmptyWidget() {
    return Container(
      //错误页面中心可以自己调整
      padding: EdgeInsets.fromLTRB(0, 0, 0, 200),
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                color: Colors.black12,
                image: AssetImage(_emptyImgPath),
                width: 150,
                height: 150,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(_emptyWidgetContent,
                    style: TextStyle(
                      fontWeight: _fontWidget,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  ///关闭最后一个 flutter 页面 ， 如果是原生跳过来的则回到原生，否则关闭app
  void finishDartPageOrApp() {
    SystemNavigator.pop();
  }

  ///点击错误页面后展示内容
  void onClickErrorWidget() {
    onResume(); //此处 默认onResume 就是 调用网络请求，
  }

  ///设置错误提示信息
  void setErrorContent(String content) {
    if (content != null) {
      setState(() {
        _errorContentMesage = content;
      });
    }
  }

  ///设置错误页面显示或者隐藏
  void setErrorWidgetVisible(bool isVisible) {
    setState(() {
      if (isVisible) {
        //如果可见 说明 空页面要关闭啦
        _isEmptyWidgetVisible = false;
      }
      // 不管如何loading页面要关闭啦，
      _isLoadingWidgetShow = false;
      _isErrorWidgetShow = isVisible;
    });
  }

  ///设置空页面显示或者隐藏
  void setEmptyWidgetVisible(bool isVisible) {
    setState(() {
      if (isVisible) {
        //如果可见 说明 错误页面要关闭啦
        _isErrorWidgetShow = false;
      }

      // 不管如何loading页面要关闭啦，
      _isLoadingWidgetShow = false;
      _isEmptyWidgetVisible = isVisible;
    });
  }

  void setLoadingWidgetVisible(bool isVisible) {
    setState(() {
      _isLoadingWidgetShow = isVisible;
    });
  }

  ///设置空页面内容
  void setEmptyWidgetContent(String content) {
    if (content != null) {
      setState(() {
        _emptyWidgetContent = content;
      });
    }
  }

  ///设置错误页面图片
  void setErrorImage(String imagePath) {
    if (imagePath != null) {
      setState(() {
        _errImgPath = imagePath;
      });
    }
  }

  ///设置空页面图片
  void setEmptyImage(String imagePath) {
    if (imagePath != null) {
      setState(() {
        _emptyImgPath = imagePath;
      });
    }
  }

  String getClassName() {
    if (context == null) {
      return null;
    }
    String className = context.toString();
    if (className == null) {
      return null;
    }
    className = className.substring(0, className.indexOf("("));
    return className;
  }

  void setBackIconHinde({bool isHiinde = true}) {
    setState(() {
      _isBackIconShow = !isHiinde;
    });
  }

  ///返回作为内部页面，垂直方向 头和底部 被占用的 高度
  double getVerticalMargin();

  @override
  bool get wantKeepAlive => true;

  ///通过设置点击的这个下下标，来判断是onPause 还是 onResume
  void changeVisible(int index, int preIndex) {
    log("-----------${index}-----${preIndex}------minii--");
    if (index != preIndex) {
      //如果前后一样，说明 没点击切换，不用操作，否则进行判定
      if (preIndex == widget.index) {
        //说明是之前显示的页面，现在被隐藏了,调用onPause
        onPause();
      } else if (index == widget.index) {
        //说明是被切换到的页面，调用onResume
        onResume();
      }
    }
  }

  ///为了完善生命周期而特意搞得 方法 ， 手动调用 onPause 和onResume
  void changePageVisible(int index, int preIndex) {
    if (index != preIndex) {
      if (preIndex == widget.index) {
        onPause();
      } else if (index == widget.index) {
        onResume();
      }
    }
  }
}
