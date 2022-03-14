import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common_plugin/base_lib.dart';

// ignore: must_be_immutable
class FBOrderDialog1 extends StatefulWidget {
  final int tag;
  final double size;

  final Color color;

  FBOrderDialog1(this.tag, this.size, this.color);

  @override
  _FBBaseOrderDialogState createState() => _FBBaseOrderDialogState();
}

class _FBBaseOrderDialogState extends State<FBOrderDialog1> {
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
            Container(
              color: Colors.white,
              child: FlatButton(
                onPressed: () {
                  DialogManger.showOrderDialog(
                      FBOrderDialog1(widget.tag + 1, widget.size - 20,
                          colors[widget.tag + 1]),
                      context);
                },
                child: Text("${widget.tag ?? ""}跳转"),
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
