import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:multi_image_picker/src/exceptions.dart';

class MultiImagePicker {
  static const MethodChannel _channel =
      const MethodChannel('multi_image_picker');

  /// Invokes the multi image picker selector.
  ///
  /// You must provide [maxImages] option, which will limit
  /// the number of images that the user can choose. On iOS
  /// you can pass also [cupertinoOptions] parameter which should be
  /// an instance of [CupertinoOptions] class. It allows you
  /// to customize the look of the image picker. On Android
  /// you can pass the [materialOptions] parameter, which should
  /// be an instance of [MaterialOptions] class.
  /// As from version  2.1.40 a new parameter [enableCamera]
  /// was added, which allows the user to take a picture
  /// directly from the gallery.
  ///
  /// If you would like to present the picker with pre selected
  /// photos, you can pass [selectedAssets] with List of Asset
  /// objects picked previously from the picker.
  ///
  /// This method returns list of [Asset] objects. Because
  /// they are just placeholders containing the actual
  /// identifier to the image, not the image itself you can
  /// pick thousands of images at a time, with no performance
  /// penalty. How to request the original image or a thumb
  /// you can refer to the docs for the Asset class.
  static Future<List<Asset>> pickImages({
    @required int maxImages,
    bool enableCamera = false,
    List<Asset> selectedAssets = const [],
    CupertinoOptions cupertinoOptions = const CupertinoOptions(),
    MaterialOptions materialOptions = const MaterialOptions(),
  }) async {
    assert(maxImages != null);

    if (maxImages != null && maxImages < 0) {
      throw new ArgumentError.value(maxImages, 'maxImages cannot be negative');
    }

    try {
      final List<dynamic> images = await _channel.invokeMethod(
        'pickImages',
        <String, dynamic>{
          'maxImages': maxImages,
          'enableCamera': enableCamera,
          'iosOptions': cupertinoOptions.toJson(),
          'androidOptions': materialOptions.toJson(),
          'selectedAssets': selectedAssets
              .map(
                (Asset asset) => asset.identifier,
              )
              .toList(),
        },
      );
      var assets = List<Asset>();
      for (var item in images) {
        var asset = Asset(
          item['identifier'],
          item['name'],
          item['width'],
          item['height'],
        );
        assets.add(asset);
      }
      return assets;
    } on PlatformException catch (e) {
      switch (e.code) {
        case "CANCELLED":
          throw NoImagesSelectedException(e.message);
        default:
          throw e;
      }
    }
  }

  /// Requests a thumbnail with [width], [height]
  /// and [quality] for a given [identifier].
  ///
  /// This method is used by the asset class, you
  /// should not invoke it manually. For more info
  /// refer to [Asset] class docs.
  ///
  /// The actual image data is sent via BinaryChannel.
  static Future<bool> requestThumbnail(
      String identifier, int width, int height, int quality) async {
    assert(identifier != null);
    assert(width != null);
    assert(height != null);

    if (width != null && width < 0) {
      throw new ArgumentError.value(width, 'width cannot be negative');
    }

    if (height != null && height < 0) {
      throw new ArgumentError.value(height, 'height cannot be negative');
    }

    if (quality < 0 || quality > 100) {
      throw new ArgumentError.value(
          quality, 'quality should be in range 0-100');
    }

    try {
      bool ret = await _channel.invokeMethod(
          "requestThumbnail", <String, dynamic>{
        "identifier": identifier,
        "width": width,
        "height": height,
        "quality": quality
      });
      return ret;
    } on PlatformException catch (e) {
      switch (e.code) {
        case "ASSET_DOES_NOT_EXIST":
          throw AssetNotFoundException(e.message);
        case "PERMISSION_DENIED":
          throw PermissionDeniedException(e.message);
        case "PERMISSION_PERMANENTLY_DENIED":
          throw PermissionPermanentlyDeniedExeption(e.message);
        default:
          throw e;
      }
    }
  }

  /// Requests the original image data for a given
  /// [identifier].
  ///
  /// This method is used by the asset class, you
  /// should not invoke it manually. For more info
  /// refer to [Asset] class docs.
  ///
  /// The actual image data is sent via BinaryChannel.
  static Future<bool> requestOriginal(String identifier, quality) async {
    try {
      bool ret =
          await _channel.invokeMethod("requestOriginal", <String, dynamic>{
        "identifier": identifier,
        "quality": quality,
      });
      return ret;
    } on PlatformException catch (e) {
      switch (e.code) {
        case "ASSET_DOES_NOT_EXIST":
          throw AssetNotFoundException(e.message);
        default:
          throw e;
      }
    }
  }

  // Requests image metadata for a given [identifier]
  static Future<Metadata> requestMetadata(String identifier) async {
    Map<dynamic, dynamic> map = await _channel.invokeMethod(
      "requestMetadata",
      <String, dynamic>{
        "identifier": identifier,
      },
    );

    Map<String, dynamic> metadata = Map<String, dynamic>.from(map);
    if (Platform.isIOS) {
      metadata = _normalizeMetadata(metadata);
    }

    return Metadata.fromMap(metadata);
  }

  /// Normalizes the meta data returned by iOS.
  static Map<String, dynamic> _normalizeMetadata(Map<String, dynamic> json) {
    Map map = Map<String, dynamic>();

    json.forEach((String metaKey, dynamic metaValue) {
      if (metaKey == '{Exif}' || metaKey == '{TIFF}') {
        map.addAll(Map<String, dynamic>.from(metaValue));
      } else if (metaKey == '{GPS}') {
        Map gpsMap = Map<String, dynamic>();
        Map<String, dynamic> metaMap = Map<String, dynamic>.from(metaValue);
        metaMap.forEach((String key, dynamic value) {
          if (key == 'GPSVersion') {
            gpsMap['GPSVersionID'] = value;
          } else {
            gpsMap['GPS$key'] = value;
          }
        });
        map.addAll(gpsMap);
      } else {
        map[metaKey] = metaValue;
      }
    });

    return map;
  }
}
