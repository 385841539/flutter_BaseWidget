import 'package:flutter/material.dart';
import 'package:flutter_common_plugin/base_lib.dart';
import 'package:flutter_module_login/page/radiusbtnbean.dart';

class TestRadiusBtnPage extends StatefulWidget {
  @override
  _TestRadiusBtnPageState createState() => _TestRadiusBtnPageState();
}

class _TestRadiusBtnPageState extends BaseState<TestRadiusBtnPage, BaseProvide> {
  RadiusSelectedControl radiusSelectedControl;
  List<String> list = [
    "全选",
    "快乐崇拜",
    "走过日子",
    "有没有歌",
    "快乐1拜",
    "走3日子",
    "有没有5",
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    radiusSelectedControl = RadiusSelectedControl();
  }

  @override
  List<Widget> getMainChildrenWidget(BuildContext context) {
    return [
      RadiusSelectedWidget(
        ["你好", "我不好", "你好", "你不好"],
        leftPadding: 20,
        rightPadding: 20,
        unSelected: (i, text) {
          FBToastUtils.show("取消选中$i:$text");
        },
        selected: (i, text) {
          FBToastUtils.show("选中$i:$text");
        },
      ),
      RadiusSelectedWidget(
        ["头部外0", "头部外1", "头部外2", "头部外3", "头部外4", "头部外5"],
        leftPadding: 20,
        rightPadding: 20,
        spacing: 20,
        itemCount: 3,
        unSelected: (i, text) {
          FBToastUtils.show("取消选中$i:$text");
        },
        selected: (i, text) {
          FBToastUtils.show("选中$i:$text");
        },
      ),
      Container(
        width: FBScreenUtil.getScreenWidth(),
        color: Colors.white,
        // padding: EdgeInsets.only(left: 30,ri),
        child: RadiusSelectedWidget(
          list,
          radiusSelectedControl: radiusSelectedControl,
          selectedIndex: {1},
          allSelectedIndex: 0,
          singleChoice: false,
          allSelectedText: "全选",
          allUnSelectedText: "全不选",
          boolAllSelectedIndexReverse: true,
          topWidget: Container(
            margin: EdgeInsets.only(top: 30),
            width: FBScreenUtil.getScreenWidth(),
            color: Colors.blueAccent,
            child: Text("我是自定义头部，和自定义选中未选中"),
          ),
          selectedBuilder: (i, string) {
            return Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              color: Colors.orangeAccent,
              child: Text("$string"),
            );
          },
          unSelectedBuilder: (i, string) {
            return Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              color: Colors.red,
              child: Text("$string"),
            );
          },
        ),
      ),
      Container(
        color: Colors.blue,
        height: 50,
      ),
      RaisedButton(
        onPressed: () {
          radiusSelectedControl.selectAll();
        },
        child: Text("全选"),
      ),
      RaisedButton(
        onPressed: () {
          radiusSelectedControl.unSelectAll();
        },
        child: Text("全不选"),
      ),
      Container(
        // width: 30,
        child: RaisedButton(
          color: Colors.orange,
          onPressed: () {
            radiusSelectedControl.selectSet({2, 3, 4});
          },
          child: Text("选2,3,4"),
        ),
      ),
      RaisedButton(
        onPressed: () {
          radiusSelectedControl.selectedIndex.forEach((element) {
            print("选中的:$element");
          });
          radiusSelectedControl.unSelectedIndex.forEach((element) {
            print("未选中的:$element");
          });
        },
        child: Text("输出全选和全不选"),
      ),
      RadiusSelectedWidget(
        _generateBean(),
        leftPadding: 20,
        rightPadding: 20,
        topWidget: Container(
          width: FBScreenUtil.getScreenWidth(),
          color: Colors.red,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Text("实体类测试"),
        ),
        spacing: 20,
        itemCount: 3,
        unSelected: (i, text) {
          FBToastUtils.show("取消选中$i:$text");
        },
        selected: (i, text) {
          FBToastUtils.show("选中$i:$text");
        },
      ),
    ];
  }

  @override
  BaseProvide registerProvide() {
    return null;
  }

  List _generateBean() {
    List list = [];
    RadiusTestBean r1 = RadiusTestBean("小明1", 13, false);
    RadiusTestBean r2 = RadiusTestBean("小明2", 13, false);
    RadiusTestBean r3 = RadiusTestBean("小明3", 14, false);
    RadiusTestBean r4 = RadiusTestBean("小明4", 14, false);
    RadiusTestBean r5 = RadiusTestBean("小明5", 14, false);
    RadiusTestBean r6 = RadiusTestBean("小明6", 14, false);
    RadiusTestBean r7 = RadiusTestBean("小明7", 14, false);

    list.add(r1);
    list.add(r2);
    list.add(r3);
    list.add(r4);
    list.add(r5);
    list.add(r6);
    list.add(r7);
    list.add(123);
    list.add(123.0);
    list.add(false);
    return list;
  }
}
