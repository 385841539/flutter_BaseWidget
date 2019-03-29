import 'package:flutter/material.dart';
import 'package:flutter_base_widget/base/_base_widget.dart';
import 'package:flutter_base_widget/base/base_inner_widget.dart';
import 'package:flutter_base_widget/test_package/asinnerpage/first_inner_page.dart';
import 'package:flutter_base_widget/test_package/asinnerpage/GSYTabBarWidget.dart';
import 'package:flutter_base_widget/test_package/asinnerpage/second_inner_page.dart';
import 'package:flutter_base_widget/test_package/asinnerpage/third_inner_page.dart';

/**
 * Created by guoshuyu
 * on 2018/7/29.
 */

class TabBarWidget extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> getState() {
    // TODO: implement getState
    return _TabBarBottomPageWidgetState();
  }
}

class _TabBarBottomPageWidgetState extends BaseWidgetState<TabBarWidget> {
  final PageController topPageControl = new PageController();

  final List<String> tab = ["动态", "趋势", "我的"];

  List<int> indexs = [0];

  int _preIndex = 0;

  _renderTab() {
    List<Widget> list = new List();
    for (int i = 0; i < tab.length; i++) {
      list.add(new FlatButton(
          onPressed: () {
            topPageControl.jumpTo(MediaQuery.of(context).size.width * i);
//            changePage(i);
          },
          child: new Text(
            tab[i],
            maxLines: 1,
          )));
    }
    return list;
  }

  _renderPage() {
    return [
      new FirstInnerPage(),
      new SecondInnerPage(),
      new ThirdInnerPage(),
    ];
  }

  List<BaseInnerWidget> _tabs;
  @override
  Widget buildWidget(BuildContext context) {
    // TODO: implement buildWidget
    return new GSYTabBarWidget(
        type: GSYTabBarWidget.BOTTOM_TAB,

        ///渲染tab
        tabItems: _renderTab(),

        ///渲染页面
        tabViews: _tabs,
        topPageControl: topPageControl,
        backgroundColor: Colors.red,
        indicatorColor: Colors.white,
        onPageChanged: (index) {
          changePage(index);
        },
        title: new Text("BaseWidget"));
    ;
  }

  @override
  void onCreate() {
    log("onCreate");
    setBackIconHinde();
    _tabs = _renderPage();
  }

  @override
  void onPause() {
    log("onPause");
    if (_tabs[_preIndex].baseInnerWidgetState != null) {
      _tabs[_preIndex].baseInnerWidgetState.onPause();
    }
  }

  @override
  void onResume() {
    log("onResume");
    if (_tabs[_preIndex].baseInnerWidgetState != null) {
      _tabs[_preIndex].baseInnerWidgetState.onResume();
    }
  }

  void changePage(int index) {
    if (index != _preIndex) {
      if (indexs.contains(index)) {
        if (_tabs[index].baseInnerWidgetState != null) {
          _tabs[index].baseInnerWidgetState.changePageVisible(index, _preIndex);
          _tabs[_preIndex]
              .baseInnerWidgetState
              .changePageVisible(index, _preIndex);
        }
      } else {
        if (_tabs[_preIndex].baseInnerWidgetState != null) {
          _tabs[_preIndex]
              .baseInnerWidgetState
              .changePageVisible(-3, _preIndex); //防止onPause被不调用
        }
      }

      indexs.add(index); //用来过滤内部页面 onResume 会加载两次
      _preIndex = index;
    }
  }
}
