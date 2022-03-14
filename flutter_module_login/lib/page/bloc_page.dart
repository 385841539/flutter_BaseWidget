import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_module_login/page/counter_bloc.dart';

class BlocCounterTestPage extends StatefulWidget {
  @override
  _BlocCounterTestPageState createState() => _BlocCounterTestPageState();
}

class _BlocCounterTestPageState extends State<BlocCounterTestPage> {
  int count = 0;
  final StreamController<int> streamController = StreamController();
  CounterBloc counterBloc = CounterBloc();

  @override
  Widget build(BuildContext context) {
    //
    // BlocProvider.value(
    //   value: BlocProvider.of<CounterBloc>(context),
    //   child: Text("你好啊。。。"),
    // );
    return Scaffold(
      body: BlocProvider<CounterBloc>(
        create: (context) => counterBloc,
        child: Container(
            color: Colors.blue,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder<int>(
                    stream: streamController?.stream,
                    builder: (context, snapshot) {
                      print("---snapshot--${snapshot?.data}");
                      return Text("${snapshot?.data ?? '哈哈 ， 原始Stream'}");
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  CounterWidget(),
                  _getEventWidget(counterBloc)
                ],
              ),
            )),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(
          Icons.add,
          color: Colors.amber,
        ),
        onPressed: () {
          streamController?.sink?.add(count++);
        },
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    streamController?.close();
    counterBloc?.close();
  }

  _getEventWidget(CounterBloc counterBloc) {
    // CounterBloc counterBloc = BlocProvider.of<CounterBloc>(context);
    return Row(
      children: [
        FlatButton(
            onPressed: () {
              counterBloc.add(CounterEvent.increment);
            },
            child: Text("bloc测试增加1")),
        FlatButton(
            onPressed: () {
              counterBloc.add(CounterEvent.decrement);
            },
            child: Text("bloc测试减少1"))
      ],
    );
  }
}

class CounterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CounterBloc, int>(
        builder: (context, count) => Text("111我是bloc的调试$count"));
  }
}
