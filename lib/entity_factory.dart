import 'package:flutter_base_widget/network/bean/login_response_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "LoginResponseEntity") {
      return LoginResponseEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}
