import 'package:flutter/material.dart';
import 'package:flutter_common_plugin/base_lib.dart';

// ignore: must_be_immutable
class H5TestPage extends BaseListStateless {
  int itemCount = 10;



  Widget _getItem(BuildContext context, int index) {
    if (index == 0) {
      return RaisedButton(
        onPressed: () {
          spellUrl();
        },
        child: Text("拼接参数"),
      );
    } else if (index == 1) {
      return RaisedButton(
        onPressed: () {
          FBNavUtils.open(context, "http://www.baidu.com",
              params: {"name": "王矮虎"});
        },
        child: Text("跳转百度地址"),
      );
    }

    return Container();
  }

  void spellUrl() {
    Map<String, dynamic> map = Map();
    map["name"] = "小明";
    map["age"] = 19;
    String url1 = UrlUtils.spellUrlWithMap(null, map);
    String url2 = UrlUtils.spellUrlWithMap("http://baidu.com", map);
    String url3 = UrlUtils.spellUrlWithMap("http://baidu.com?", map);
    String url4 = UrlUtils.spellUrlWithMap("http://baidu.com?teacher=瓦罐面", map);
    String url5 = UrlUtils.spellUrlWithMap(
        "http://baidu.com?teacher=瓦罐面&student=牛顿", map);

    print("url----$url1");
    print("url----$url2");
    print("url----$url3");
    print("url----$url4");
    print("url----$url5");
  }

  @override
  List<Widget> getMainChildrenWidget(BuildContext context) {
    List<Widget>  widget=[];
    for(int i=0;i<itemCount;i++){

      widget.add(_getItem(context, i));

    }
    return widget;

  }
}
