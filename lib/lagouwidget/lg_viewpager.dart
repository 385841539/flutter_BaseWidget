import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_lib/lagouwidget/lg_simulation.dart';
import 'package:flutter_common_plugin/base_lib.dart';
import 'dart:math' as math;

class LGViewPager extends StatefulWidget {
  @override
  _LGViewPagerState createState() => _LGViewPagerState();
}

class _LGViewPagerState extends State<LGViewPager> {
  List<Widget> widgets = [];
  double itemPadding = 10;
  double sidePadding = 15;
  double height = 100;
  double widthScale = 20 / (20 + 4); //Item宽度与占比（必须大于等于0.5，小于等于1）

  double itemWidth;
  double _maxScrollExtent;

  ScrollController _scrollController;

  VoidCallback scrollCallBack;

  @override
  void initState() {
    addWidget();

    if (widthScale < 0.5 || widthScale > 1) {
      throw Exception(
          "widthScale:$widthScale 是个不合理的值，widthScale必须大于等于0.5且小于等于1");
    }
    itemWidth = (FBScreenUtil.getScreenWidth() - itemPadding - sidePadding) *
        widthScale;
    _scrollController = ScrollController();
    scrollCallBack = () {
      if (_maxScrollExtent == null) {
        _maxScrollExtent = _scrollController?.position?.maxScrollExtent;
      }
    };
    _scrollController?.addListener(scrollCallBack);

    // _scrollController.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      // color: Colors.blue,
      height: height,
      child: getGesList(),
      //
      // Listener(
      //   onPointerDown: (event) {
      //     print("---onPointerDown---");
      //   },
      //   onPointerMove: (event) {
      //     print("---onPointerMove--${event.position.dx}---${event.size}--${event.distance}---");
      //     return true;
      //   },
      //   onPointerUp: (event) {
      //     print("---onPointerUp---");
      //   },
      //   onPointerSignal: (event) {
      //     print("---onPointerSignal---");
      //   },
      //   onPointerCancel: (event) {
      //     print("---onPointerCancel---");
      //   },
      //   child: getListPart()

      // ),
    );
  }

  void addWidget() {
    for (int i = 0; i < 20; i++) {
      widgets.add(Container(
        color: Colors.red,
        width: FBScreenUtil.getScreenWidth() - 50,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("你好头部$i"),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 60,
              height: 40,
              child: FlatButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    _scrollController?.animateTo(0,
                        // _maxScrollExtent ??
                        duration: Duration(seconds: 1),
                        curve: Curves.easeOutSine);
                  },
                  child: Container(
                    color: Colors.green,
                    width: 60,
                    height: 40,
                  )),
            )
          ],
        ),
      ));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController?.removeListener(scrollCallBack);
    _scrollController?.dispose();
  }

  Widget getListPart() {
    return ListView.builder(
      // https://www.codercto.com/a/55919.html
      // https://cloud.tencent.com/developer/article/1516957
      physics: LGScrollableScrollPhysics(unitLength: itemPadding + itemWidth),
      controller: _scrollController,
      // padding: EdgeInsets.only(left: sidePadding, right: sidePadding),
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(
              left: index == 0 ? sidePadding : itemPadding,
              right: index == widgets.length - 1 ? sidePadding : 0),
          width: itemWidth,
          child: widgets[index],
        );
      },
      scrollDirection: Axis.horizontal,
      itemCount: widgets?.length ?? 0,
    );
  }

  getGesList() {
    return GestureDetector(
      onTapDown: (ev) {
        print("--onTapDown-$ev---");
      },
      onTap: () {
        print("--onTap----");
      },
      onPanDown: (event) {
        print("--onPanDown---$event----");
      },
      onPanUpdate: (event) {
        print("--onPanUpdate-$event---");
      },
      // onHorizontalDragEnd: ,
      onHorizontalDragUpdate: (event) {
        print("---onHorizontalDragUpdate---");
      },
      child: getListPart(),
    );
  }
}

class LGScrollableScrollPhysics extends ScrollPhysics {
  /// Creates scroll physics that does not let the user scroll.

  final double unitLength;

  const LGScrollableScrollPhysics({ScrollPhysics parent, this.unitLength})
      : super(parent: parent);

  @override
  LGScrollableScrollPhysics applyTo(ScrollPhysics ancestor) {
    return LGScrollableScrollPhysics(
        parent: buildParent(ancestor), unitLength: this.unitLength);
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    return super.applyPhysicsToUserOffset(position, offset);
  }

  @override
  Simulation createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    final Tolerance tolerance = this.tolerance;

    if (position.pixels >= position.maxScrollExtent || position.pixels <= 0) {
      return null;
    }

    ///current Index
    if (velocity != 0) {
      int index = (position.pixels / unitLength).round();

      if (velocity > 0) {
        ///计算剩余长度
        double distance = unitLength * (index + 1) - position.pixels;

        return LgScrollSimulation(
            velocity: velocity, distance: distance, position: position.pixels);
      } else {
        // <0
        double distance = unitLength * (index - 1) - position.pixels;

        return LgScrollSimulation(
            velocity: velocity, distance: distance, position: position.pixels);
      }
    } else {
      return null;
    }

    if (velocity.abs() < tolerance.velocity) return null;
    if (velocity > 0.0 && position.pixels >= position.maxScrollExtent)
      return null;
    if (velocity < 0.0 && position.pixels <= position.minScrollExtent)
      return null;

    return ClampingScrollSimulation(
      position: position.pixels,
      velocity: velocity,
      tolerance: tolerance,
    );
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) => true;

  @override
  bool get allowImplicitScrolling => false;
}

class LGextends extends Simulation {
  @override
  double dx(double time) {
    // TODO: implement dx
    throw UnimplementedError();
  }

  @override
  bool isDone(double time) {
    // TODO: implement isDone
    throw UnimplementedError();
  }

  @override
  double x(double time) {
    // TODO: implement x
    throw UnimplementedError();
  }
}
