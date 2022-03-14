import 'dart:convert';

import 'package:flutter_common_plugin/base_lib.dart';

import 'base_transform.dart';

class FBParseTransform extends ResponseTransform {
  Function(Map data) parse;

  FBParseTransform(this.parse);

  @override
  transformData<T>(String data) {
    if (parse != null) {
      return parse(json.decode(data));
    } else {
      throw FBError(400, "解析方法不能为空");
    }
  }
}
