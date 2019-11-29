import 'dart:convert';

import 'package:flutter_base_widget/network/response/Transform.dart';
import 'package:flutter_base_widget/utils/entity_factory.dart';
import 'package:rxdart/src/subjects/publish_subject.dart';

import '../api.dart';

class ApiFullTransform<T> extends ResponseTransform<T>{
  ApiFullTransform() : super();

  @override
  void apply(String data) {

    bool isError = json.decode(data)["error"];

    if (isError == true) {
      callError(
        MyError(10, "请求失败~"),
      );
    } else {
      //这里的解析 请参照 https://www.jianshu.com/p/e909f3f936d6 , dart的字符串 解析蛋碎一地
      add(EntityFactory.generateOBJ<T>(json.decode(data.toString())));
    }

  }
}