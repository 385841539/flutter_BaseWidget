import 'package:flutter/material.dart';

import '../../base_lib.dart';

abstract class BaseEvent<T extends BaseProvide> {
  T provide;

  BuildContext get buildContext => provide?.context;

  Future eventExecute();
}
