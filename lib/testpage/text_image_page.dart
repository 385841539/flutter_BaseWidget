import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common_plugin/base_lib.dart';

class TextImagePage extends BaseStatelessWidget {
  @override
  Widget getMainWidget(BuildContext context) {
    return null;
  }

  @override
  List<Widget> getMainChildrenWidget(BuildContext context) {
    return [
      FBDoubleWidget(
        Image.asset("assets/images/shop.png"),
        Container(
          child: Text("View1"),
        ),

        // Container(
        //   child: Text("View2"),
        //   color: Colors.red,
        // )

        isHorizontal: true,
        decoration: BoxDecoration(color: Colors.green),
      ),
      SizedBox(
        width: 30,
        height: 30,
        child: Container(),
      ),
      FBDoubleWidget(
        Image.asset("assets/images/shop.png"),
        Container(
          child: Text("View1"),
        ),
        onTap: () {
          FBToastUtils.show("你好图片");
        },

        // Container(
        //   child: Text("View2"),
        //   color: Colors.red,
        // )

        isHorizontal: false,
        // padding: EdgeInsets.only(top: 20, bottom: 20),
        // decoration: BoxDecoration(color: Colors.blueAccent),
      ),
      SizedBox(
        width: 30,
        height: 30,
        child: Container(),
      ),
      FBDoubleWidget(
        Container(
          child: Text("设置"),
        ),
        Image.asset("assets/images/shop.png"),

        width: double.infinity,
        onTap: () {
          FBToastUtils.show("我是设置");
        },
        decoration: BoxDecoration(color: Colors.yellow),

        // Container(
        //   child: Text("View2"),
        //   color: Colors.red,
        // )

        isHorizontal: true,
        padding: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
      ),
    ];
  }

}
