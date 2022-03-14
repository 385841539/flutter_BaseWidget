import 'dart:async';

import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class Asset {
  /// The resource identifier
  String _identifier;

  /// The resource file name
  String _name;

  /// Original image width
  int _originalWidth;

  /// Original image height
  int _originalHeight;

  Asset(
    this._identifier,
    this._name,
    this._originalWidth,
    this._originalHeight,
  );

  /// The BinaryChannel name this asset is listening on.
  String get _channel {
    return 'multi_image_picker/image/$_identifier';
  }

  String get _thumbChannel => '$_channel.thumb';

  String get _originalChannel => '$_channel.original';

  /// Returns the original image width
  int get originalWidth {
    return _originalWidth;
  }

  /// Returns the original image height
  int get originalHeight {
    return _originalHeight;
  }

  /// Returns true if the image is landscape
  bool get isLandscape {
    return _originalWidth > _originalHeight;
  }

  /// Returns true if the image is Portrait
  bool get isPortrait {
    return _originalWidth < _originalHeight;
  }

  /// Returns the image identifier
  String get identifier {
    return _identifier;
  }

  /// Returns the image name
  String get name {
    return _name;
  }

  /// Requests a thumbnail for the [Asset] with give [width] and [hegiht].
  ///
  /// The method returns a Future with the [ByteData] for the thumb,
  /// as well as storing it in the _thumbData property which can be requested
  /// later again, without need to call this method again.
  ///
  /// You can also pass the optional parameter [quality] to reduce the quality
  /// and the size of the returned image if needed. The value should be between
  /// 0 and 100. By default it set to 100 (max quality).
  ///
  /// Once you don't need this thumb data it is a good practice to release it,
  /// by calling releaseThumb() method.
  Future<ByteData> getThumbByteData(int width, int height,
      {int quality = 100}) async {
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

    Completer completer = new Completer<ByteData>();
    ServicesBinding.instance.defaultBinaryMessenger
        .setMessageHandler(_thumbChannel, (ByteData message) async {

      completer.complete(message);
      ServicesBinding.instance.defaultBinaryMessenger
          .setMessageHandler(_thumbChannel, null);
      return message;
    });

    await MultiImagePicker.requestThumbnail(
        _identifier, width, height, quality);
    return completer.future;
  }

  /// Requests the original image for that asset.
  ///
  /// You can also pass the optional parameter [quality] to reduce the quality
  /// and the size of the returned image if needed. The value should be between
  /// 0 and 100. By default it set to 100 (max quality).
  ///
  /// The method returns a Future with the [ByteData] for the image,
  /// as well as storing it in the _imageData property which can be requested
  /// later again, without need to call this method again.
  Future<ByteData> getByteData({int quality = 100}) async {
    if (quality < 0 || quality > 100) {
      throw new ArgumentError.value(
          quality, 'quality should be in range 0-100');
    }

    Completer completer = new Completer<ByteData>();
    ServicesBinding.instance.defaultBinaryMessenger
        .setMessageHandler(_originalChannel, (ByteData message) async {
      completer.complete(message);
      ServicesBinding.instance.defaultBinaryMessenger
          .setMessageHandler(_originalChannel, null);
      return message;
    });

    await MultiImagePicker.requestOriginal(_identifier, quality);
    return completer.future;
  }

  /// Requests the original image meta data
  Future<Metadata> get metadata {
    return MultiImagePicker.requestMetadata(_identifier);
  }

  @Deprecated(
    'This method will be deprecated in the next major release. Please use getByteData method instead.',
  )
  Future<ByteData> requestOriginal({int quality = 100}) {
    return getByteData(quality: quality);
  }

  @Deprecated(
    'This method will be deprecated in the next major release. Please use getThumbByteData method instead.',
  )
  Future<ByteData> requestThumbnail(
    int width,
    int height, {
    int quality = 100,
  }) async {
    return getThumbByteData(width, height, quality: quality);
  }

  @Deprecated(
    'This method will be deprecated in the next major release. Please use metadata getter instead.',
  )
  Future<Metadata> requestMetadata() {
    return metadata;
  }
}
