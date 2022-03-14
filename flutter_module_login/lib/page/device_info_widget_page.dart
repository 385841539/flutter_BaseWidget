import 'package:flutter/material.dart';
import 'package:flutter_common_plugin/base_lib.dart';

class DeviceInfoWidgetPage extends StatefulWidget {
  @override
  _DeviceInfoWidgetPageState createState() => _DeviceInfoWidgetPageState();
}

class _DeviceInfoWidgetPageState
    extends BaseState<DeviceInfoWidgetPage, BaseProvide> {
  @override
  List<Widget> getMainChildrenWidget(BuildContext context) {
    return [
      Container(
        child: Text("唯一标识:${FBDeviceUtils().getDeviceId()}"),
      ),
      Container(
        child: Text("手机品牌:${FBDeviceUtils().getDeviceBrand()}"),
      ),
      Container(
        child: Text("系统版本:${FBDeviceUtils().getSystemVersion()}"),
      ),
      // Container(
      //   child: Text("系统SdkInt:${FBDeviceUtils().getSdkInt()}"),
      // ),
      Container(
        child: Text("手机型号:${FBDeviceUtils().getSystemModel()}"),
      ),
      Container(
        child: Text("app版本:${FBDeviceUtils().getAppVersion()}"),
      ),
      Container(
        child: Text("手机厂商:${FBDeviceUtils().getManufacturer()}"),
      ),
      Container(
        child: Text("App名称:${FBDeviceUtils().getAppName()}"),
      ),
      Container(
        child: Text("App包名:${FBDeviceUtils().getPackageName()}"),
      ),
      Container(
        child: Text("buidNumber:${FBDeviceUtils().getBuildNumber()}"),
      ),
    ];
  }

  @override
  BaseProvide registerProvide() {
    return null;
  }
}
