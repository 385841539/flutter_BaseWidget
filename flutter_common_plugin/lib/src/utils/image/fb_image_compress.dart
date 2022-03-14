import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class FBImageCompress {
  ///压缩图片
  static Future compressImage(File file) async {
    Directory directory = await getTemporaryDirectory();
    File result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      directory.path +
          "/" +
          DateTime.now().millisecondsSinceEpoch.toString() +
          ".jpg",
      minWidth: 720,
      minHeight: 1080,
      quality: 80,
      rotate: 0,
    );
    return result;
  }
}
