import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter_common_plugin/base_lib.dart';
import 'package:package_info/package_info.dart';

/// 安卓和ios设备信息获取类，相关信息 可见文章 https://blog.csdn.net/weixin_34389926/article/details/88834125
class FBDeviceUtils {
  //系统标记类
  static bool isDebug = AppConfig.isDebug;
  static bool isAndroid = AppConfig.isAndroid;
  static bool isIos = AppConfig.isIos;

  IosDeviceInfo iosDeviceInfo;

  AndroidDeviceInfo androidDeviceInfo;

  static FBDeviceUtils _deviceManger = FBDeviceUtils._internal();

  String _deviceId;

  String appName;

  String packageName;

  String version;

  String buildNumber;

  factory FBDeviceUtils() {
    return _deviceManger;
  }

  FBDeviceUtils._internal();

  Future initPlatInfo() async {
    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    if (Platform.isIOS) {
      iosDeviceInfo = await deviceInfo.iosInfo;
    } else if (Platform.isAndroid) {
      androidDeviceInfo = await deviceInfo.androidInfo;
    }
    await _initVersion();
  }

  ///设备型号
  String getSystemModel() {
    if (isAndroid) {
      if (androidDeviceInfo != null) {
        return androidDeviceInfo.model;
      }
    } else {
      return iosDeviceInfo?.model;
    }
    return "LON-AL00";
  }

  ///系统版本
  String getSystemVersion() {
    if (isAndroid) {
      if (androidDeviceInfo != null) {
        return androidDeviceInfo.version.release;
      } else {
        return "10.0";
      }
    } else {
      if (iosDeviceInfo != null) {
        return iosDeviceInfo.systemVersion;
      } else {
        return "12.0";
      }
    }
  }

  ///安卓sdk 版本
  int getSdkInt() {
    if (isAndroid) {
      return androidDeviceInfo.version.sdkInt;
    } else {
      return 0;
    }
  }

  ///占位 值
  String getDeviceId() {
    if (StringUtils.isNotEmpty(_deviceId)) {
      return _deviceId;
    }

    String deviceId = FBSpUtils().getString("device_id_base");

    if (StringUtils.isNotEmpty(deviceId)) {
      _deviceId = deviceId;
      return _deviceId;
    }
    if (isAndroid) {
      _deviceId = androidDeviceInfo?.androidId;
    } else {
      _deviceId = iosDeviceInfo?.identifierForVendor;
    }

    if (StringUtils.isEmpty(_deviceId)) {
      _generateLocalDeviceId();
    }
    print("_deviceId----$_deviceId");
    try {
      FBSpUtils().put("device_id_base", _deviceId);
    } catch (e, ts) {
      FBError.printError(e, ts);
    }

    return _deviceId;
  }

  static String _deviceBrand;

  ///获取手机品牌
  String getDeviceBrand() {
    if (StringUtils.isNotEmpty(_deviceBrand)) {
      return _deviceBrand;
    }
    if (isAndroid) {
      _deviceBrand = androidDeviceInfo?.brand ?? "HuaWei";
    } else {
      _deviceBrand = "APPLE";
    }
    return _deviceBrand;
  }

  ///获取app版本
  String getAppVersion() {
    if (isAndroid) {
      return version;
    }

    return iosDeviceInfo.utsname.version;
  }

  ///获取app版本
  String getBuildNumber() {
    return buildNumber;
  }

  ///手机厂商
  String getManufacturer() {
    if (isAndroid) {
      return androidDeviceInfo.manufacturer;
    }

    return "apple";
  }

  String _generateLocalDeviceId() {
    return "hold_id";
  }

  String getAppName() {
    return appName;
  }

  String getPackageName() {
    return packageName;
  }

  _initVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    //APP名称
    appName = packageInfo.appName;
    //包名
    packageName = packageInfo.packageName;
    //版本名
    version = packageInfo.version;
    //版本号
    buildNumber = packageInfo.buildNumber;

    print("$appName=$packageName=$version=$buildNumber");
  }
}
