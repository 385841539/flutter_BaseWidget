import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/material.dart';
import 'package:city_pickers/src/util.dart';
import 'package:flutter_common_plugin/base_lib.dart';

class FBCityPicker {
  ///https://blog.csdn.net/qq_34198653/article/details/103899439
  static Future<Result> showCityPicker(BuildContext context,
      {showType = ShowType.pca,
      double height = 400.0,
      String locationCode = '110000',
      ThemeData theme,
      Map<String, dynamic> citiesData,
      Map<String, dynamic> provincesData,
      bool barrierDismissible = true,
      double barrierOpacity = 0.5,
      ItemWidgetBuilder itemBuilder,
      double itemExtent,
      Widget cancelWidget,
      Widget confirmWidget,
      bool isSort = false}) {
    SoftKeyBoardUtil.unFocus(context);
    return CityPickers.showCityPicker(
      context: context,
      showType: showType,
      height: height,
      locationCode: locationCode,
      theme: theme,
      citiesData: citiesData,
      provincesData: provincesData,
      barrierDismissible: barrierDismissible,
      barrierOpacity: barrierOpacity,
      itemBuilder: itemBuilder,
      itemExtent: itemExtent,
      cancelWidget: Text("取消"),
      confirmWidget: confirmWidget,
      isSort: isSort,
    );
  }

  static Future showFullPageCityPicker(BuildContext context,
      {ThemeData theme,
      ShowType showType = ShowType.pca,
      String locationCode = '110000',
      Map<String, dynamic> citiesData,
      Map<String, dynamic> provincesData}) {
    SoftKeyBoardUtil.unFocus(context);
    return CityPickers.showFullPageCityPicker(
        context: context,
        theme: theme,
        showType: showType,
        citiesData: citiesData,
        provincesData: provincesData);
  }
}
