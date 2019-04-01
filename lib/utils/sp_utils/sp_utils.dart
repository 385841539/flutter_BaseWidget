import 'package:shared_preferences/shared_preferences.dart';

///http请求
class SpUtils {
  SpUtils._internal() {}
  static SpUtils _spUtils = SpUtils._internal();

  static SharedPreferences _sp;
  factory SpUtils() {
    return _spUtils;
  }

  //初始化，必须要初始化
  Future<SharedPreferences> init() async {
    _sp = await SharedPreferences.getInstance();
    return _sp;
  }

  Future<bool> put(String key, Object value) {
    if (value is int) {
      return setInt(key, value);
    } else if (value is String) {
      return setString(key, value);
    } else if (value is bool) {
      return setBool(key, value);
    } else if (value is double) {
      return setDouble(key, value);
    } else if (value is List<String>) {
      return setList(key, value);
    }
    throw Exception("存入的不是能存入的数据类型~~~");
  }

  Future<bool> setList(String key, List<String> value) async {
    if (_sp != null) {
      return _sp.setStringList(key, value);
    }
    return false;
  }

  Future<bool> setInt(String key, int value) async {
    if (_sp != null) {
      return _sp.setInt(key, value);
    }
    return false;
  }

  Future<bool> setBool(String key, bool value) async {
    if (_sp != null) {
      return _sp.setBool(key, value);
    }
    return false;
  }

  Future<bool> setDouble(String key, double value) async {
    if (_sp != null) {
      return _sp.setDouble(key, value);
    }
    return false;
  }

  Future<bool> setString(String key, String value) async {
    if (_sp != null) {
      return _sp.setString(key, value);
    }
    return false;
  }

  double getDouble(String key) {
    if (_sp != null) {
      return _sp.getDouble(key);
    }
    return 0;
  }

  String getString(String key) {
    if (_sp != null) {
      return _sp.getString(key);
    }
    return "";
  }

  bool getBool(String key) {
    if (_sp != null) {
      return _sp.getBool(key);
    }
    return false;
  }

  int getInt(String key) {
    if (_sp != null) {
      return _sp.getInt(key);
    }
    return 0;
  }

  List<String> getList(String key) {
    if (_sp != null) {
      return _sp.getStringList(key);
    }
    return List<String>();
  }
}
