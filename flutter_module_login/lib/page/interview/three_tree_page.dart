import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_common_plugin/base_lib.dart';

class ThreeTreeTestPage extends StatefulWidget {
  @override
  _ThreeTreeTestPageState createState() => _ThreeTreeTestPageState();
}

class _ThreeTreeTestPageState extends State<ThreeTreeTestPage> {
  List list = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return Container(
              child: ItemWidgetStful(
                index: list[index],
                // key: Key("${list[index]}"),

              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          list.removeAt(0);
          setState(() {});
        },
        child: Icon(Icons.delete),
      ),
    );
  }
}

class ItemWidget extends StatelessWidget {
  final Color randomColor = Color.fromARGB(
      250, Random().nextInt(250), Random().nextInt(250), Random().nextInt(250));

  final int index;

  ItemWidget({Key key, this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: randomColor,
      child: Text("我是$index"),
      height: 50,
    );
  }
}

class ItemWidgetStful extends StatefulWidget {
  final int index;


  ItemWidgetStful({this.index}){
    print("---_ItemWidgetStfulState111111--${index}---");
  }

  @override
  _ItemWidgetStfulState createState() => _ItemWidgetStfulState();
}

class _ItemWidgetStfulState extends State<ItemWidgetStful> {
  final Color randomColor = Color.fromARGB(
      250, Random().nextInt(250), Random().nextInt(250), Random().nextInt(250));


  @override
  Widget build(BuildContext context) {
    print("---_ItemWidgetStfulState--${widget.index}---");

    return Container(
      alignment: Alignment.center,
      color: randomColor,
      child: Text("我是${widget.index}"),
      height: 50,
    );
  }
}
