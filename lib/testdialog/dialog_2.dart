import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common_plugin/base_lib.dart';

// ignore: must_be_immutable
class FBOrderDialog2 extends StatefulWidget {
  final int tag;
  final int zIndex;
  final double size;

  final Color color;

  FBOrderDialog2(this.tag, this.size, this.color, this.zIndex);

  @override
  _FBBaseOrderDialogState createState() => _FBBaseOrderDialogState();
}

class _FBBaseOrderDialogState extends State<FBOrderDialog2> {
  List<Color> colors = [
    Colors.red,
    Colors.white,
    Colors.amber,
    Colors.black,
    Colors.green,
    Colors.orange[700],
    Colors.red,
    Colors.white,
    Colors.amber,
    Colors.black,
    Colors.green,
    Colors.orange[700],
    Colors.red,
    Colors.white,
    Colors.amber,
    Colors.black,
    Colors.green,
    Colors.orange[700],
    Colors.red,
    Colors.white,
    Colors.amber,
    Colors.black,
    Colors.green,
    Colors.orange[700],
    Colors.red,
    Colors.white,
    Colors.amber,
    Colors.black,
    Colors.green,
    Colors.orange[700],
    Colors.red,
    Colors.white,
    Colors.amber,
    Colors.black,
    Colors.green,
    Colors.orange[700],
    Colors.red,
    Colors.white,
    Colors.amber,
    Colors.black,
    Colors.green,
    Colors.orange[700]
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 100),
        alignment: AlignmentDirectional.center,
        color: widget.color ?? Colors.blue,
        height: (widget.size ?? 100) + 200,
        width: widget.size ?? 100,
        child: Column(
          children: <Widget>[
            Text("我是dialog2，tag是${widget?.tag}"),
            Container(
              color: Colors.white,
              child: FlatButton(
                onPressed: () {
                  DialogManger.showOrderDialog(
                      FBOrderDialog2(widget.tag + 1, widget.size - 20,
                          colors[widget.tag + 1], widget.zIndex - 1),
                      context,
                      zIndex: widget.zIndex - 1);
                },
                child: Text("${widget.tag ?? ""}跳转下一个，层级为减一"),
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Container(
              color: Colors.white,
              child: FlatButton(
                onPressed: () {
                  DialogManger.dismissDialog(widget);
                },
                child: Text("${widget.tag ?? ""}销毁"),
              ),
            ),
          ],
        ));
  }
}
