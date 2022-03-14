import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common_plugin/base_lib.dart';
import 'package:loading_indicator_view/loading_indicator_view.dart';

class FBImage extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final BorderRadius borderRadius;
  final Widget placeholderWidget;
  final Widget errorWidget;
  final String imageUrl;
  final BoxFit fit;
  final File file;
  final bool isClipOval;
  final Function onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  FBImage.custom(
      {Key key,
      @required this.imageUrl,
      this.file,
      this.width,
      this.height,
      this.fit = BoxFit.fill,
      this.placeholderWidget,
      this.errorWidget,
      this.isClipOval = false,
      this.radius,
      this.borderRadius,
      this.onTap,
      this.padding,
      this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    return onTap == null
        ? _getMainWidget()
        : InkWell(
            onTap: onTap,
            child: _getMainWidget(),
          );
  }

  Widget _getNetImage() {
    return CachedNetworkImage(
      placeholder: (context, url) {
        // return placeholderWidget ?? Container(width: width, height: height);
        return placeholderWidget ??
            Center(
              child: Container(
                child: CircularProgressIndicator(
                    // color: Colors.black26,
                    // duration: Duration(seconds: 2),
                    ),
                width: _getSize(),
                height: _getSize(),
              ),
            );
      },
      errorWidget: (context, url, err) {
        return errorWidget ??
            placeholderWidget ??
            Container(width: width, height: height);
      },
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
    );
  }

  Widget _getImageUrlImage() {
    if (StringUtils.isEmpty(imageUrl)) {
      return Container(
        width: width,
        height: height,
      );
    }
    if (imageUrl.startsWith("http://") || imageUrl.startsWith("https://")) {
      return _getNetImage();
    }

    return Image.asset(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
    );
  }

  Widget _getImageWidget() {
    return file == null
        ? _getImageUrlImage()
        : Image.file(
            file,
            width: width,
            height: height,
            fit: fit,
          );
  }

  _getIsRadiusWidget() {
    if (radius != null || borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius == null
            ? BorderRadius.circular(radius ?? 3)
            : borderRadius,
        child: _getImageWidget(),
      );
    }
    return _getImageWidget();
  }

  Widget _getMainWidget() {
    return Container(
        padding: padding,
        margin: margin,
        child: isClipOval
            ? ClipOval(
                child: _getImageWidget(),
              )
            : _getIsRadiusWidget());
  }

  static getImgSize(
      Image image, Function(Image image, int width, int height) callBackInfo) {
    if (image != null) {
      image.image
          .resolve(new ImageConfiguration())
          .addListener(new ImageStreamListener(
        (ImageInfo info, bool _) {
          callBackInfo?.call(image, info.image.width, info.image.height);
        },
      ));
    }
  }

  double _getSize() {
    if (width == null || height == null) {
      return 30.0;
    }
    double _size = 0;
    if (width > height) {
      _size = width;
    } else {
      _size = height;
    }

    if (_size > 100) {
      return 50;
    } else {
      return _size / 2;
    }
  }
}
