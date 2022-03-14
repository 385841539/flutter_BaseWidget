import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_lib/api/test_api.dart';
import 'package:flutter_base_lib/lagouwidget/lg_viewpager.dart';
import 'package:flutter_common_plugin/base_lib.dart';
import 'package:flutter_module_login/model/assets_path_uti.dart';
import 'package:flutter_module_login/model/filter_model.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends BaseListState<Page1, BaseProvide> // with RouteAware
{
  List<Asset> imageList;

  List<AssetEntity> weChatImg;

  @override
  void initState() {
    super.initState();
    // setStatusBarVisible(false);
    setStatusBarColor(Colors.black);
    testFutureWait();
  }

  @override
  void onCreate() {
    super.onCreate();
    setNavBarCenterPosition(10);

  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: null),
      ],
      child: super.build(context),
    );
  }

  @override
  List<Widget> getMainChildrenWidget(BuildContext context) {
    return [
      // LGViewPager(),
      GestureDetector(
        onTap: () {
          testRequest();
        },
        child: FlatButton(
          onPressed: () {
            testRequest();
          },
          child: Text("发起请求"),
        ),
      ),
      FlatButton(
          onPressed: () {
            ///调试通过name跳转
            Navigator.of(context)
                .pushNamed("nihao", arguments: {"name": "小王啊"});
            // Navigator.of(context).push(null);
          },
          child: Text("跳转你好")),
      FlatButton(
          onPressed: () {
            ///调试通过name跳转
            AssetsPathUtils.load("assets/filter.json").then((value) {
              print("---value--$value");
              FilterBean filter = FilterBean.fromJson(json.decode(value));
              // print("----filter--${filter.toJson()}");
            }).catchError((e) {
              FBError.printError(e);
            });
            // Navigator.of(context).push(null);
          },
          child: Text("解析Filter数据")),
      GestureDetector(
        onTap: () {
          testRequest();
        },
        child: FlatButton(
          onPressed: () {
            FBNavUtils.open(context, TestApi.routeSpUtils,
                params: {"pageTitle": "routeSpUtilsByAction"});
          },
          child: Text("跳转到SpUtils"),
        ),
      ),
      GestureDetector(
        onTap: () {
          testRequest();
        },
        child: FlatButton(
          onPressed: () {
            FBNavUtils.open(context, TestApi.statelessPage1,
                params: {"pageTitle": "routeSpUtilsByAction"});
          },
          child: Text("跳转到无状态页"),
        ),
      ),
     Center(child:

     Container(
       width: 100,
       height: 30,
       child: InkWell(
         child: Text("跳转bloc页"),
         onTap: () {
           FBNavUtils.open(context, "blocTest");
         },
       ),
     )
       ,),
      GestureDetector(
        onTap: () {
          testRequest();
        },
        child: FlatButton(
          onPressed: () {
            FBNavUtils.open(context, TestApi.mainPage,
                params: {"pageTitle": "mainPage"});
          },
          child: Text("跳转到MainPage页"),
        ),
      ),
      FlatButton(
          onPressed: () {
            FBNavUtils.open(context, TestApi.textImageWidget,
                params: {"pageTitle": "mainPage"});
          },
          child: Text("去ImageText组合键")),
      GestureDetector(
        onTap: () {
          testRequest();
        },
        child: FlatButton(
          onPressed: () {
            ///判断是否位于栈顶

            // print("-----位于栈顶吗？------${FBNavUtils.isCurrent(context)}");
            FBToastUtils.show(
                "-----位于栈顶吗？------${FBNavUtils.isCurrent(context)}");
          },
          child: Text("是否在顶部"),
        ),
      ),
      FlatButton(
          onPressed: () {
            setBackgroundColor(Colors.green);
          },
          child: Text("修改背景")),
      FlatButton(
          onPressed: () {
            FBNavUtils.goToDeskTop();
          },
          child: Text("返回手机的主屏幕")),
      FlatButton(
          onPressed: () {
            FBNavUtils.open(context, "loginModulePage");
          },
          child: Text("跳转测试登录页")),
      FlatButton(
          onPressed: () {
            FBNavUtils.open(context, TestApi.p2PDemo);
          },
          child: Text("去webRtc视频页")),
      FlatButton(
          onPressed: () {
            FBNavUtils.open(context, "testEntryPage");
          },
          child: Text("去聊天入口页")),
      FlatButton(
          onPressed: () {
            FBNavUtils.open(context, "testRadiusBtnPage");
          },
          child: Text("跳转radiusBtn测试页")),
      FlatButton(
          onPressed: () {
            FBImageSelector.openImageSelector(maxSelect: 9).then((value) {
              print("---value != null---${value != null}");
              if (value != null) {
                imageList = value;
                setState(() {});
              }
            }).catchError((e, ts) {
              print("---value != error");

              FBError.printError(e, ts);
            });
          },
          child: Text("选择图片并浏览")),
      Container(
        child:
            (imageList == null || imageList.isEmpty) ? Container() : _getImg(),
        height: 120,
      ),
      Center(
        child: InkWell(
            onTap: () {
              chooseImageViewByWeChat();
            },
            child: Container(
              // width: 60,
              // height: 40,
              alignment: Alignment.center,
              child: Text("用wechat_assets_picker选择图片并浏览"),
            )),
      ),
      (weChatImg == null || weChatImg.isEmpty)
          ? Container()
          : Container(
              child: _getWeChatImg(),
              height: 120,
            ),
      FlatButton(
          onPressed: () {
            FBNavUtils.open(context, "tesDeviceInfoRoute");
          },
          child: Text("设备信息页")),
      FlatButton(
          onPressed: () {
            FBImageSelector.openImageSelector();
          },
          child: Text("跳转图片选择")),
      FlatButton(
          onPressed: () {
            FBChannelUtils.requestChannel("flutter_function://requestLogin",
                params: {"title": "我是从page1来的请求"}).then((value) {
              print("收到回信，内容是:$value");
            });

            FBChannelUtils.requestChannel(
                    "flutter_function://requestLoginRegister",
                    params: {"title": "requestLoginRegister我是从page1来的请求"})
                .then((value) {
              print("requestLoginRegister收到回信，内容是:$value");
            }).catchError((err) {
              print(err.runtimeType);
              print(err.toString());
            });
          },
          child: Text("测试组件间通信")),
    ];
  }

  Future testRequest() async {
    await FBHttpUtil.get<Map>(context, "v2/resignIn").then(((data) {
      print("${data.runtimeType}");
      print("data---$data--${data["msg"]}-");
      return FBHttpUtil.get<Map>(context, "v2/signIn/setting");
    })).then((value) {
      print("------value---$value");
    }).catchError((err) {
      print("----err--$err---");
    });
    return "";
  }

  void testFutureWait() async {
    Future.wait([demo1(), demo2(), demo3()]).then((value) {
      print("-Future.wait-$value");
    }).catchError((err) {
      print("-Future.wait---err-$err");
    }).whenComplete(() => {});
  }

  Future demo3() async {
    // sleep(Duration(seconds: 5));
    // await testRequest(); //如果 有异常直接就走报错了
    testRequest();
    // testSleep();
    return Future(() {});
  }

  Future demo2() async {
    // await sleepFuture();
    // throw Exception(["err"]);
    return "demo22";
  }

  Future demo1() async {
    // sleep(Duration(seconds: 3));
    return "demo11";
  }

  Future testSleep() async {
    return sleep(Duration(seconds: 5));
  }

  Future sleepFuture() async {
    return Future.delayed(Duration(seconds: 5), () {
      sleep(Duration(seconds: 3));
    });
  }

  @override
  Future<bool> onBackClick() {
    //调试 回到其他context
    // FBNavUtils.close(MyHomePage.mContext);
    return super.onBackClick();
  }

  _Page1State() : super();

  @override
  Widget getItem(BuildContext context, int index) {
    // TODO: implement getItem
    throw UnimplementedError();
  }

  @override
  int getItemCount() {
    // TODO: implement getItemCount
    throw UnimplementedError();
  }

  @override
  BaseProvide registerProvide() {
    // TODO: implement registerProvide
    throw UnimplementedError();
  }

  _getImg() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            FBImageScanUtil.scanImg(context, imageList);
          },
          child: AssetThumb(
            asset: imageList[index],
            width: 120,
            height: 120,
          ),
        );
      },
      itemCount: imageList.length,
    );
  }

  void chooseImageViewByWeChat() {
    // final List<AssetEntity> assets =
    AssetPicker.pickAssets(context).then((List<AssetEntity> assets) {
      if (assets != null) {
        setState(() {
          weChatImg = assets;
        });
      }
    });

    //  CameraPicker.pickFromCamera(
    //   context,
    //   enableRecording: true,
    // ).then((List<AssetEntity> assets) {
    //    if (assets != null) {
    //      setState(() {
    //        weChatImg = assets;
    //      });
    //    }
    //  });
  }

  _getWeChatImg() {
    return ListView.builder(
        itemCount: weChatImg.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Image(
                image: AssetEntityImageProvider(weChatImg[index],
                    isOriginal: false)),
          );
        });
  }
}

class ABa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Aa extends StatefulWidget {
  @override
  _AaState createState() => _AaState();
}

class _AaState extends State<Aa> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
