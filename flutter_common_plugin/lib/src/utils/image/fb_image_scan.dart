import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common_plugin/base_lib.dart';
import 'package:flutter_common_plugin/src/route/route_builder/fade_route_builder.dart';
import 'package:loading_indicator_view/loading_indicator_view.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class _ImageScanPage extends StatefulWidget {
  final List<dynamic> images;

  // final List<Asset> imageAssets;
  final int index;
  final String heroTag;
  final LoadingBuilder loadingBuilder;
  PageController controller;

  _ImageScanPage(this.images,
      {Key key,
      this.index = 0,
      this.controller,
      this.heroTag = "",
      this.loadingBuilder})
      : super(key: key) {
    if (controller == null) {
      controller = PageController(initialPage: index);
    }
  }

  @override
  _ImageScanPageState createState() => _ImageScanPageState();
}

class _ImageScanPageState extends State<_ImageScanPage> {
  int currentIndex = 0;
  bool isInit = false;

  List<ImageProvider> imageProviders = [];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
    _transformImgProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      body: !isInit
          ? Container(
              alignment: Alignment.center,
              width: FBScreenUtil.getScreenWidth(),
              height: FBScreenUtil.getScreenHeight(),
              child: LineSpinFadeLoaderIndicator(
                minLineWidth: 50,
                minLineHeight: 50,
              ),
            )
          : Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  bottom: 0,
                  right: 0,
                  child: Container(
                      child: PhotoViewGallery.builder(
                    scrollPhysics: const BouncingScrollPhysics(),
                    builder: (BuildContext context, int index) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider: _getInitImgProvider(index),
                        heroAttributes: widget.heroTag.isNotEmpty
                            ? PhotoViewHeroAttributes(tag: widget.heroTag)
                            : null,
                      );
                    },
                    itemCount: widget.images?.length ?? 0,
                    loadingBuilder: widget.loadingBuilder ??
                        (
                          BuildContext context,
                          ImageChunkEvent event,
                        ) =>
                            getDefaultLoading(context),
                    backgroundDecoration: null,
                    pageController: widget.controller,
                    enableRotation: true,
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  )),
                ),
                Positioned(
                  //图片index显示
                  top: MediaQuery.of(context).padding.top + 15,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text("${currentIndex + 1}/${widget.images.length}",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
                Positioned(
                  //右上角关闭按钮
                  right: 10,
                  top: MediaQuery.of(context).padding.top,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 30,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
    );
  }

  //
  // Future<ImageProvider> _getImgProvider(int index) async {
  //   // Image.memory(bytes)
  //   // ByteData byteData = await imageList[i].getByteData();
  //
  //   var image = widget.images[index];
  //   if (image is String) {
  //     if (widget.images[index].startsWith("http")) {
  //       return NetworkImage(widget.images[index]);
  //     } else {
  //       return AssetImage(widget.images[index]);
  //     }
  //   } else if (image is Asset) {
  //     image.getByteData().then((value) {
  //       value.buffer.asUint8List();
  //     });
  //     return MemoryImage();
  //   }
  // }

  void _transformImgProvider() async {
    if (imageProviders == null) {
      imageProviders = [];
    }
    imageProviders.clear();
    for (int i = 0; i < widget.images.length; i++) {
      try {
        ImageProvider provider = await getProvider(widget.images[i]);
        if (provider != null) {
          imageProviders.add(provider);
        }
      } catch (e) {
        FBError.printError(e);
      }
    }

    setState(() {
      isInit = true;
    });
  }

  _getInitImgProvider(int index) {
    return imageProviders[index];
  }

  Future<ImageProvider> getProvider(dynamic image) async {
    if (image is String) {
      if (image.startsWith("http")) {
        return CachedNetworkImageProvider(image);
      } else {
        return AssetImage(image);
      }
    } else if (image is Asset) {
      ByteData byteData = await image.getByteData();
      //     .then((value) {
      //   value.buffer.asUint8List();
      // });
      return MemoryImage(byteData.buffer.asUint8List());
    } else if (image is File) {
      return FileImage(image);
    }

    return null;
  }

  getDefaultLoading(BuildContext context) {
    return Center(
      child: SizedBox(
        child: CircularProgressIndicator(),
        width: 50,
        height: 50,
      ),
    );
  }
}

class FBImageScanUtil {
  ///[images] 目前只支持 File Asset String 类型
  static Future scanImg(BuildContext context, List<dynamic> images,
      {Key key, int index = 0, PageController controller, String heroTag}) {
    return Navigator.of(context).push(new FadeRoute(
        page: _ImageScanPage(
      images, //传入图片list
      index: index, //传入当前点击的图片的index
      heroTag: heroTag ?? "", //传入当前点击的图片的hero tag （可选）
      controller: controller,
    )));
  }
}
