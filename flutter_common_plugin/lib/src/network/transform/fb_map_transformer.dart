import 'dart:convert';

import 'package:flutter_common_plugin/src/network/transform/base_transform.dart';

class FBMapTransformer extends ResponseTransform {
  @override
  transformData<HashMap>(String data) {
    return json.decode(data);
  }
}
