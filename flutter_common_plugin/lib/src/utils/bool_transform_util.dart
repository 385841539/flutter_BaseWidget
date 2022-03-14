class BoolTransformUtil {
  ///中转bool值
  static bool transform(dynamic oriBoolText) {
    if (oriBoolText == null) {
      return false;
    }
    if (oriBoolText is bool) {
      return oriBoolText;
    }

    if (oriBoolText is int) {
      return oriBoolText == 1;
    }

    if(oriBoolText is String){
      return oriBoolText=="true"||oriBoolText=="True"||oriBoolText=="TRUE";
    }

    throw Exception("非可转成bool的类型，需要的话自己加");
  }
}
