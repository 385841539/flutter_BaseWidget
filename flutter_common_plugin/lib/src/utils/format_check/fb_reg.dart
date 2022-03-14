///常用的一些正则
class FBReg {
  static RegExp idCardReg = RegExp(
      r'^\d{6}(18|19|20)?\d{2}(0[1-9]|1[012])(0[1-9]|[12]\d|3[01])\d{3}(\d|X)$');

  static RegExp phoneReg = RegExp(
      r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');

  ///手机号验证
  static bool isChinaPhoneLegal(String str) {
    return RegExp(
        r"^1([38][0-9]|4[579]|5[0-3,5-9]|6[6]|7[0135678]|9[89])\d{8}$")
        .hasMatch(str);
  }

  ///邮箱验证
  static bool isEmail(String str) {
    return RegExp(
        r"^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$")
        .hasMatch(str);
  }
  ///验证URL
  static bool isUrl(String value) {
    return RegExp(
        r"^((https|http|ftp|rtsp|mms)?:\/\/)[^\s]+")
        .hasMatch(value);
  }

  ///验证身份证
  static bool isIdCard(String value) {
    return RegExp(
        r"\d{17}[\d|x]|\d{15}")
        .hasMatch(value);
  }

  ///验证中文
  static bool isChinese(String value) {
    return RegExp(
        r"[\u4e00-\u9fa5]")
        .hasMatch(value);
  }


}
