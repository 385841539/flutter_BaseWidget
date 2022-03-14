import 'dart:convert';

import 'package:pointycastle/digests/sha256.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart';

/// 小数据数据持久化类，例如储存用户信息等
class FBSpUtils {
  SHA256Digest sha256 = SHA256Digest();

  Key key;

  IV iv;

  Encrypter encrypt;

  FBSpUtils._internal();

  static FBSpUtils _spUtils = FBSpUtils._internal();

  static SharedPreferences _sp;

  factory FBSpUtils() {
    return _spUtils;
  }

  String _keyString = "fb iv32get loves";

  //初始化，必须要初始化
  Future<String> init({String keyString}) async {
    await SharedPreferences.getInstance().then((value) {
      _sp = value;
    });

    if (keyString != null && keyString != "") {
      _keyString = keyString;
    }

    key = Key.fromUtf8(_keyString);
    iv = IV.fromLength(16);

    encrypt = Encrypter(AES(key));

    return "";
  }

  Future<bool> put(String key, Object value) {
    if (value is int) {
      return _putString("int_$key", "$value");
    } else if (value is String) {
      return _putString("string_$key", value);
    } else if (value is bool) {
      return _putString("bool_$key", "$value");
    } else if (value is double) {
      return _putString("double_$key", "$value");
    } else if (value is List<String>) {
      String valueEncode = json.encode(value);
      return _putString("list_string_$key", valueEncode);
    }

    throw Exception("存入的不是基础数据类型~~~,请使用putObject方法进行储存,然后使用getObject获取");
  }

  /// put object.
  Future<bool> putObject(String key, Object value) {
    if (_sp == null) return null;
    return _putString("object_$key", value == null ? "" : json.encode(value));
  }

  T getObj<T>(String key, T f(Map v), {T defValue}) {
    Map map = getObject(key);
    return map == null ? defValue : f(map);
  }

  Map getObject(String key) {
    if (_sp == null) return null;
    String _data = _getString("object_$key");
    return (_data == null || _data.isEmpty) ? null : json.decode(_data);
  }

  Future<bool> putObjectList(String key, List<Object> list) {
    if (_sp == null) return null;
    List<String> _dataList = list?.map((value) {
      return json.encode(value);
    })?.toList();
    return put("list_obj_$key", _dataList);
  }

  List<T> getObjList<T>(String key, T f(Map v), {List<T> defValue = const []}) {
    List<Map> dataList = getObjectList(key);
    List<T> list = dataList?.map((value) {
      return f(value);
    })?.toList();
    return list ?? defValue;
  }

  List<Map> getObjectList(String key) {
    if (_sp == null) return null;
    List<String> dataLis = getStringList("list_obj_$key");
    return dataLis?.map((value) {
      Map _dataMap = json.decode(value);
      return _dataMap;
    })?.toList();
  }

  bool getBool(String key, {bool defValue = false}) {
    try {
      String decValue = _getString("bool_$key", defValue: "$defValue");
      return decValue == "true";
    } catch (e) {
      return defValue;
    }
  }

  String getString(String key, {String defValue}) {
    try {
      return _getString("string_$key", defValue: defValue);
    } catch (e) {
      return defValue;
    }
  }

  int getInt(String key, {int defValue = 0}) {
    try {
      String intValue = _getString("int_$key", defValue: "$defValue");
      print("----intvaluw---$intValue");
      return int.parse(intValue);
    } catch (e) {
      return defValue;
    }
  }

  double getDouble(String key, {double defValue = 0.0}) {
    try {
      String doubleValue = _getString("double_$key", defValue: "$defValue");
      print("----doubleValue---$doubleValue");
      return double.parse(doubleValue);
    } catch (e) {
      return defValue;
    }
  }

  List<String> getStringList(String key, {List<String> defValue = const []}) {
    try {
      String decode = _getString("list_string_$key");
      print("----stringValue----$decode");
      // List<String> list = decode.split(',');
      List<String> list = (json.decode(decode) as List<dynamic>)
          .map<String>((e) => "$e")
          .toList();
      print("---list--$list");

      return list;
    } catch (e) {
      return defValue;
    }
  }

  ///获取加密值方法
  String _getString(String key, {String defValue}) {
    try {
      if (_sp == null) return defValue;
      return encrypt.decrypt(
          Encrypted.fromBase64(_sp.getString(key) ?? defValue),
          iv: iv);
    } catch (e) {
      return defValue;
    }
  }

  ///存入加密值方法
  Future<bool> _putString(String key, String value) {
    if (_sp == null) return null;
    String base64 = encrypt.encrypt(value, iv: iv).base64;
    // print("--存入的base64-$base64---value--$value");
    return _sp.setString(key, base64);
  }

  Future<bool> clear() {
    if (_sp == null) return null;
    return _sp.clear();
  }
}
