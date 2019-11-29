import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_base_widget/base/_base_widget.dart';
import 'package:provider/src/provider.dart';

import 'PieChartWidget.dart';


class PieChartPage extends BaseWidget {
  @override
  _BingTuPageState getState() => _BingTuPageState();
}

class _BingTuPageState extends BaseWidgetState<PieChartPage> {
  List<double> angles;

  List<Color> colors;
  List<String> contents;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();


     colors=[Colors.red,Colors.cyan,Colors.black,Colors.yellow,Colors.grey];
     angles=[1/7,2/7,2/7,1/14,3/14];
     contents=["梁朝伟","刘德华","郭富城","周星驰","张学友"];
  }
  @override
  Widget buildWidget(BuildContext context) {
    // TODO: implement buildWidget
    return Center(child: PieChartWidget(angles,colors,startTurns:.0,radius: 130,contents: contents));
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
    setAppBarRightTitle("");
  }

  @override
  void onPause() {
    // TODO: implement onPause
  }

  @override
  void onResume() {
    // TODO: implement onResume
  }

  @override
  List<SingleChildCloneableWidget> getProvider() {
    // TODO: implement getProvider
    return null;
  }

}
