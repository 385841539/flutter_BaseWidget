import 'dart:io';

import 'package:device_info/device_info.dart';



/// 安卓和ios设备信息获取类，相关信息 可见文章 https://blog.csdn.net/weixin_34389926/article/details/88834125
class DeviceUtils{


  //系统标记类
  static bool isDebug = !bool.fromEnvironment("dart.vm.product");
  static bool isAndroid = Platform.isAndroid;
  static bool isIos = Platform.isIOS;

  IosDeviceInfo iosDeviceInfo;

  AndroidDeviceInfo androidDeviceInfo;




  static DeviceUtils _deviceManger = DeviceUtils._internal();
  factory DeviceUtils() {
    return _deviceManger;
  }
  DeviceUtils._internal();
  Future initPlatInfo() async {
    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    if(Platform.isIOS){
      iosDeviceInfo =  await deviceInfo.iosInfo;
    }else if(Platform.isAndroid){
      androidDeviceInfo = await  deviceInfo.androidInfo;

    }
  }


  String getSystemModel(){

    return "LON-AL00";
    if(isAndroid){
      if(androidDeviceInfo!=null){
        return androidDeviceInfo.model;
      }
    }else if(isIos){

    }

    return "";

  }


  ///占位 值
  String getIMEI() {


    return "862031031508387";
    if(isAndroid){
      if(androidDeviceInfo!=null){
        return androidDeviceInfo.id;
      }
    }

  }



  ///占位 值
  String getMacAddress() {

    if(isAndroid){
      if(androidDeviceInfo!=null){
        return androidDeviceInfo.model;
      }
    }

  }



  String getSystemVersion() {

    if(isAndroid){
      if(androidDeviceInfo!=null){
        return androidDeviceInfo.version.release;
      }else{
        return "9.0";
      }
    }else{
      if(iosDeviceInfo!=null){

        return iosDeviceInfo.systemVersion;

      }else{

        return "12.0";
      }

    }

  }


  ///占位 值
  String getUMengChannel() {
    return "328533";
  }



  ///占位 值
  String getDeviceId() {

    return "43920481883";

  }

}