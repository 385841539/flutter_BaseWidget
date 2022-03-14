import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_common_plugin/base_lib.dart';

class AssetsPathUtils {


  //加载文件
  static Future<T> load<T>(String assetsPath,
      {JKParser parser, JKListType listType}) async {
    String _data = await rootBundle.loadString(assetsPath).catchError((e) {});

    // print("----$assetsPath获取数据:\n$_data");
    if (T.toString() == "String" || T.toString() == "dynamic") {
      return _data as T;
    } else if (T.toString().startsWith("Map")) {
      return json.decode(_data);
    } else if (T.toString().startsWith("List")) {
      if (listType == null) {
        throw FBError(-100, "listType不能为null");
      }
      return listType.parserList((json.decode(_data) as List)) as T;
    } else {
      if (parser == null) {
        throw FBError(-100, "parser不能为null");
      }
      return parser(json.decode(_data));
    }
  }
}

typedef JKParser = Function(Map json);

class JKListType<T> {
  JKParser parser;

  JKListType(this.parser);

  List<T> parserList(List list) {
    return list.map<T>((json) => parser(json)).toList();
  }
}
