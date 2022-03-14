import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_common_plugin/base_lib.dart';

import 'base_list_ui.dart';


abstract class BaseListState<T extends StatefulWidget, E extends BaseProvide>
    extends BaseState<T, E> with BaseListUi {
  @override
  void initState() {
    super.initState();
    registerStateForList(this);
  }

  @override
  Widget getMainWidget(BuildContext context) {
    return getListView(context, provide);
  }

  ///刷新的空布局 需要在 舒心控件中
  @override
  bool getIsErrorWidgetVisible() {
    return false;
  }

  @override
  Future onRefreshCallback() async {
    try {
      await provide?.requestData();
    } catch (e) {}
    return super.onRefreshCallback();
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
    scrollController?.dispose();
  }
}

