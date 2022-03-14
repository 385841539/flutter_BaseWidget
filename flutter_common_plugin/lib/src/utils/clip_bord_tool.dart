import 'package:flutter/services.dart';
import 'package:flutter_common_plugin/base_lib.dart';

//复制粘贴
class ClipboardTool {
  //复制内容
  static setDataToastMsg(String data,
      {bool showSuccess = true, String successMsg = "复制成功"}) {
    if (data != null && data != '') {
      Clipboard.setData(ClipboardData(text: data));
      if (showSuccess) {
        FBToastUtils.show(successMsg);
      }
    }
  }

  //获取内容
  static Future<ClipboardData> getData() {
    return Clipboard.getData(Clipboard.kTextPlain);
  }

//将内容复制系统
//   ClipboardUtil.setData('123');
//从系统获取内容
//   ClipboardUtil.getData().then((data){}).catchError((e){});

}
