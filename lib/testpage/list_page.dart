import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common_plugin/base_lib.dart';

class ListTestPage extends StatefulWidget {
  @override
  _ListTestPageState createState() => _ListTestPageState();
}

class _ListTestPageState extends BaseListState<ListTestPage, BaseProvide> {
  @override
  void initState() {
    super.initState();
    setTitle("列表测试");
  }

  @override
  Widget getItem(BuildContext context, int index) {
    if (index == 0) {
      return Container(
        color: Colors.amber,
        height: 200,
      );
    }
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            "我是item---$index",
            style: TextStyle(color: Colors.blue, fontSize: 20),
          ),
          Text(
            "第$index个",
          ),
          Container(
            height: 1,
          )
        ],
      ),
    );
  }

  @override
  int getItemCount() {
    return 100;
  }

  @override
  bool useBaseLayout() {
    // TODO: implement useBaseLayout
    return true;
  }

  @override
  List<Widget> getMainChildrenWidget(BuildContext context) {
    List<Widget> widget = [];

    for (int i = 0; i < 100; i++) {
      widget.add(getItem(context, i));
    }

    return widget;
  }

  @override
  BaseProvide registerProvide() {
    return null;
  }
}
