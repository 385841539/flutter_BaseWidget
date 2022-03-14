import 'package:flutter/material.dart';
import 'package:flutter_common_plugin/base_lib.dart';
import 'extension.dart';

class InterViewPage extends StatefulWidget {
  @override
  _InterViewPageState createState() => _InterViewPageState();
}

class _InterViewPageState extends BaseState<InterViewPage, BaseProvide> {
  @override
  List<Widget> getMainChildrenWidget(BuildContext context) {
    return [
      RaisedButton(
          onPressed: () {
            FBNavUtils.open(context, "threeTreeTest");
          },
          child: Text("三棵树关系")),
      RaisedButton(
          onPressed: () {
            testRef();
          },
          child: Text("测试引用还是值传递")),
      RaisedButton(
          onPressed: () {
            TestChannel testChannel = TestChannel();
            testChannel.name = "张三";
            testChannel.path = "anima";
            Map<String, dynamic> map = {};
            map["zhangsan"] = "testChannel";
            DartToNative.requestNative("native://test_model", params: map);
          },
          child: Text("发送Bean类型到native")),
      Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'You have pushed the button this many times:',
          ).padding(EdgeInsets.all(10)).gesture(onTap: () {
            FBToastUtils.show("${isMobile()}");
          }),
        ],
      ))
    ];
  }

  @override
  BaseProvide registerProvide() {
    return null;
  }

  isMobile() {
    setState(() {

    });
    return "13023222737".isMobile();
  }

  void testRef() {
    TestChannel testChannel = TestChannel();
    testChannel.name="初始name";
    print("改变前的值:${testChannel.name}");
    changeName(testChannel);
    print("改变后的值:${testChannel.name}");

  }

  void changeName(TestChannel testChannel) {
    testChannel.name="改变后的name";
  }
}

class TestChannel {
  String name;
  String path;
}
