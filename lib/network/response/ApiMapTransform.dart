
import 'dart:convert';

import 'Transform.dart';



class ApiMapTransform extends ResponseTransform<Map>{


  @override
  void apply(String data) {
    //直接返回 map 字典
    add(json.decode(data));
  }

}