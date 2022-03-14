import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_common_plugin/base_lib.dart';

class SpUtilTestPage extends StatefulWidget {
  @override
  _SpUtilTestPageState createState() => _SpUtilTestPageState();
}

class _SpUtilTestPageState extends BaseState<SpUtilTestPage,BaseProvide> {
  String _intValue;
  String _doubleValue;

  String _boolValue;

  String _stringValue;

  @override
  Widget getMainWidget(BuildContext context) {
    return ListView(
      children: getListWidget(context),
    );
  }

  List<Widget> getListWidget(BuildContext context) {
    return [
      ...intTest(),
      SizedBox(
        height: 20,
      ),
      ...initDouble(),
      SizedBox(
        height: 20,
      ),
      ...initBoole(),
      SizedBox(
        height: 20,
      ),
      ...initString(),
      SizedBox(
        height: 20,
      ),
      ...initListString(),
      SizedBox(
        height: 20,
      ),
      ...initObject(),
      SizedBox(
        height: 20,
      ),
      ...initListObject(),
    ];
  }

  List<Widget> intTest() {
    return [
      TextField(
        onChanged: (content) {
          _intValue = content;
        },
        autofocus: false,
      ),
      RaisedButton(
        onPressed: () {
          try {
            int value = int.parse(_intValue);

            FBSpUtils().put("test_int", value);
          } catch (e) {
            FBToastUtils.show("请输入int型数据");
          }
        },
        child: Text("输入int型数据并，储存到本地"),
      ),
      RaisedButton(
        onPressed: () {
          int testInt = FBSpUtils().getInt("test_int");
          print("-获取的值是-$testInt-");
          FBToastUtils.show("获取的值为:$testInt");
        },
        child: Text("读取储存的int值"),
      ),
    ];
  }

  List<Widget> initDouble() {
    Key key1 = Key("raised");
    return [
      TextField(
        onChanged: (content) {
          _doubleValue = content;
        },
        autofocus: false,
      ),
      RaisedButton(
        key: key1,
        onPressed: () {
          click(String a) {
            print("--$a");
            context.visitAncestorElements((element) {
              Widget widget = element.widget;
              Key key = widget.key;
              if (key == key1) {
                print("-----$widget");
              }
              // List<DiagnosticsNode> node=   widget.debugDescribeChildren();
              print("----$key");
              return true;
            });
          }

          click("222");
          try {
            double value = double.parse(_doubleValue);

            FBSpUtils().put("test_double", value);
          } catch (e) {
            FBToastUtils.show("请输入double型数据");
          }
        },
        child: Text("输入double型数据并，储存到本地"),
      ),
      RaisedButton(
        onPressed: () {
          double testDouble = FBSpUtils().getDouble("test_double");
          print("-获取的值是-$testDouble-");
          FBToastUtils.show("获取的值为:$testDouble");
        },
        child: Text("读取储存的double值"),
      ),
    ];
  }

  List<Widget> initBoole() {
    return [
      TextField(
        onChanged: (content) {
          _boolValue = content;
        },
        autofocus: false,
      ),
      RaisedButton(
        onPressed: () {
          print(
              "_boolValue----$_boolValue" + "------${_boolValue.runtimeType}");
          try {
            if (_boolValue == "true" || _boolValue == "false") {
              bool boolValue = _boolValue == "true";
              FBSpUtils().put("test_bool", boolValue);
            } else {
              throw Exception("类型错误");
            }
          } catch (e) {
            FBToastUtils.show("请输入bool型数据");
          }
        },
        child: Text("输入bool型数据并，储存到本地"),
      ),
      RaisedButton(
        onPressed: () {
          bool testBool = FBSpUtils().getBool("test_bool");
          print("-获取的值是-$testBool-");
          FBToastUtils.show("获取的值为:$testBool");
        },
        child: Text("读取储存的bool值"),
      ),
    ];
  }

  List<Widget> initString() {
    return [
      TextField(
        onChanged: (content) {
          _stringValue = content;
        },
        autofocus: false,
      ),
      RaisedButton(
        onPressed: () {
          print("_stringValue----$_stringValue" +
              "------${_stringValue.runtimeType}");
          try {
            FBSpUtils().put("test_string", _stringValue);
          } catch (e) {
            FBToastUtils.show("请输入String型数据");
          }
        },
        child: Text("输入String型数据并，储存到本地"),
      ),
      RaisedButton(
        onPressed: () {
          String testBool = FBSpUtils().getString("test_string");
          print("-获取的值是-$testBool-");
          FBToastUtils.show("获取的值为:$testBool");
        },
        child: Text("读取储存的String值"),
      ),
    ];
  }

  List<Widget> initListString() {
    return [
      RaisedButton(
        onPressed: () {
          try {
            List<String> testList = ["12,3", "432,", "你好啊"];
            FBSpUtils().put("test_listString", testList);
          } catch (e) {}
        },
        child: Text("存List<String>储存到本地"),
      ),
      RaisedButton(
        onPressed: () {
          List<String> testBool = FBSpUtils().getStringList("test_listString");
          print("-获取的值是-$testBool-");
          FBToastUtils.show("获取的值为:$testBool");
        },
        child: Text("读取储存的List<String>值"),
      ),
    ];
  }

  List<Widget> initObject() {
    return [
      RaisedButton(
        onPressed: () {
          try {
            FBSpUtils().putObject(
                "test_listString",
                TestBean("王鑫", 23, "中国", "六码", Result("这是老王吧"),
                    ["阿拉斯基", 1, 423, false]));
          } catch (e) {}
        },
        child: Text("存object储存到本地"),
      ),
      RaisedButton(
        onPressed: () {
          Map testMap = FBSpUtils().getObject("test_listString");
          print("-获取的值是-$testMap-");
          FBToastUtils.show("获取的值为:$testMap");
          TestBean tb = FBSpUtils()
              .getObj("test_listString", (v) => TestBean.fromJson(v));
          print(
              "-获取的值是---{tb.toJson-----${tb?.toJson()}---tb.name--${tb?.name}-date--${tb?.result?.date}-");
        },
        child: Text("读取储存的bject值"),
      ),
    ];
  }

  List<Widget> initListObject() {
    return [
      RaisedButton(
        onPressed: () {
          try {
            FBSpUtils().putObjectList("test_listObject", [
              TestBean("王鑫1111", 2311, "中国111", "六码111", Result("这是老王吧111"),
                  ["阿拉斯基111", 11111, 4231111, false]),
              TestBean("王鑫2222", 232222, "中国22222", "六码2222",
                  Result("这是老王吧2222"), ["阿拉斯基2222", 22222, 4232222, false]),
              TestBean("王鑫3333", 2333333, "中国3333", "六码33333",
                  Result("这是老王吧3333"), ["阿拉斯基3333", 33333, 4233333, true]),
            ]);
          } catch (e) {}
        },
        child: Text("存objectList储存到本地"),
      ),
      RaisedButton(
        onPressed: () {
          List<Map> testMap = FBSpUtils().getObjectList("test_listObject");
          print("-获取的值是--test_listObject-$testMap-");
          FBToastUtils.show("获取的值为:$testMap");
          List<TestBean> tb = FBSpUtils()
              .getObjList("test_listObject", (v) => TestBean.fromJson(v));
          print(
              "-获取的值是--test_listObject---tb.toJson-----${tb?.toList()}---tb--$tb-date--${tb?.length}-");
        },
        child: Text("读取储存的存objectList储存到本地值"),
      ),
    ];
  }

  @override
  BaseProvide registerProvide() {
    // TODO: implement registerProvide
    throw UnimplementedError();
  }

  @override
  List<Widget> getMainChildrenWidget(BuildContext context) {
    // TODO: implement getMainChildrenWidget
    throw UnimplementedError();
  }
}

class TestBean {
  String name;
  int age;
  String home;
  String job;
  Result result;
  List<dynamic> list;

  TestBean(this.name, this.age, this.home, this.job, this.result, this.list);

  TestBean.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    age = json['age'];
    home = json['home'];
    job = json['job'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
    list = json['list'].cast<dynamic>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['age'] = this.age;
    data['home'] = this.home;
    data['job'] = this.job;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    data['list'] = this.list;
    return data;
  }
}

class Result {
  String date;

  Result(this.date);

  Result.fromJson(Map<String, dynamic> json) {
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    return data;
  }
}

class A {}
