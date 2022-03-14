import 'dart:convert';

import 'package:flutter_module_login/model/assets_path_uti.dart';

class FilterBean {
  List<Structure> structure;
  Map<String, List<StructureValue>> values;

  FilterBean({this.structure, this.values});

  FilterBean.fromJson(Map<String, dynamic> jsonString) {
    if (jsonString['structure'] != null) {
      structure = new List<Structure>();
      jsonString['structure'].forEach((v) {
        structure.add(new Structure.fromJson(v));
      });
    }
    // print("--jsonString['values']---${jsonString}");
    Map<String, dynamic> valuesTem;

    valuesTem = jsonString['values'] != null ? jsonString['values'] : null;
    if (valuesTem != null) {
      values = {};

      JKListType jkListType =
          JKListType<StructureValue>((json) => StructureValue.fromJson(json));
      valuesTem.forEach((key, value) {
        // print("--keytype--${key.runtimeType}----value--${value.runtimeType}");
        List<StructureValue> list = jkListType.parserList(value);
        values[key] = list;
      });
      // print("----list--$values");
    }
  }
}

class Structure {
  String title;
  int index;
  String param;
  String type;
  String value;

  Structure({this.title, this.index, this.param, this.type, this.value});

  Structure.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    index = json['index'];
    param = json['param'];
    type = json['type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['index'] = this.index;
    data['param'] = this.param;
    data['type'] = this.type;
    data['value'] = this.value;
    return data;
  }
}

class StructureValue {
  String name;
  String value;

  StructureValue({this.name, this.value});

  StructureValue.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}
