import 'package:flutter_common_plugin/src/utils/string_util/string_utils.dart';

class UrlUtils {
  ///获取Url 链接上面的参数
  static Map<String, dynamic> searchParams(String url) {
    Map<String, dynamic> map = Map<String, dynamic>();

    if ("$url" == "") {
      return map;
    }
    try {
      int index = url.indexOf("?");
      String param = url.substring(index + 1);

      map.addAll(_splitUrlMap(param));
    } catch (e) {}

    return map;
  }

  static Map<String, dynamic> _splitUrlMap(String param) {
    Map<String, dynamic> map = Map<String, dynamic>();

    try {
      List<dynamic> params = param.split("&");

      params.forEach((item) {
        try {
          List<dynamic> kv = item.split("=");
          map[kv[0]] = kv[1];
        } catch (e) {}
      });
    } catch (e) {}
    return map;
  }

  ///拼接url 和 map参数
  static String spellUrlWithMap(String url, Map<String, dynamic> param) {
    if (url == null) {
      url = "";
    }
    if (!url.contains("?")) {
      url = "$url?";
    }
    if (param != null) {
      param.forEach((key, value) {
        if (url.endsWith("?") || url.endsWith("&")) {
          url = "$url$key=$value";
        } else {
          url = "$url&$key=$value";
        }
      });
    }
    return url;
  }

  ///合并url 上的参数和现有参数合并
  static Map<String, dynamic> getParams(
      String path, Map<String, dynamic> params) {
    if (params == null) {
      params = {};
    }
    Map<String, dynamic> newParams = searchParams(path) ?? {};
    if (newParams != null && newParams.isNotEmpty) {
      params.addAll(newParams);
    }
    return params;
  }

  static bool isHttpUrl(String url) {
    return StringUtils.startWithText(url, "http://") ||
        StringUtils.startWithText(url, "https://");
  }
}
