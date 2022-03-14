import 'package:flutter/widgets.dart';

import '../baseWidget/base_stateless.dart';
import 'base_list_ui.dart';

// ignore: must_be_immutable
abstract class BaseListStateless extends BaseStatelessWidget with BaseListUi {
  @override
  Widget getMainWidget(BuildContext context) {
    return getListView(context, null);
  }
}
