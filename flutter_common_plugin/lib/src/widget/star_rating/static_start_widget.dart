import 'package:flutter/material.dart';

/**
 * 使用方法：
 * StarRating(
    rating: 1.5,
    maxRating: 5.0
    size: 30,
    count: 5,
    ),
 */

/// 静止的评分星星
class StaticStarRating extends StatefulWidget {
  final double rating; // 评分值
  final double maxRating; // 最大评分值
  final Widget unselectedImage; // 没有选中图片
  final Widget selectedImage; // 选中图片
  final int count; // 星星个数
  final double size; // 星星大小
  final Color unselectedColor; // 没有选中的颜色
  final Color selectedColor; // 选中颜色

  StaticStarRating({
    @required this.rating,
    this.maxRating = 10,
    this.size = 20,
    this.unselectedColor = const Color(0xffbbbbbb),
    this.selectedColor = const Color(0xffe0aa46),
    Widget unselectedImage,
    Widget selectedImage,
    this.count = 5,
  })  : unselectedImage = unselectedImage ??
      Icon(
        Icons.star,
        size: size,
        color: unselectedColor,
      ),
        selectedImage = selectedImage ??
            Icon(
              Icons.star,
              size: size,
              color: selectedColor,
            );

  @override
  _StaticStarRatingState createState() => _StaticStarRatingState();
}

/// 状态
class _StaticStarRatingState extends State<StaticStarRating> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Row(
            children: getUnSelectImage(),
            mainAxisSize: MainAxisSize.min,
          ),
          Row(
            children: getSelectImage(),
            mainAxisSize: MainAxisSize.min,
          ),
        ],
      ),
    );
  }

  // 获取评星
  List<Widget> getUnSelectImage() {
    return List.generate(widget.count, (index) => widget.unselectedImage);
  }

  List<Widget> getSelectImage() {
    // 1.计算Star个数和剩余比例等
    double oneValue = widget.maxRating / widget.count;
    int entireCount = (widget.rating / oneValue).floor();
    double leftValue = widget.rating - entireCount * oneValue;
    double leftRatio = leftValue / oneValue;

    // 2.获取start
    List<Widget> selectedImages = [];
    for (int i = 0; i < entireCount; i++) {
      selectedImages.add(widget.selectedImage);
    }

    // 3.计算
    Widget leftStar = ClipRect(
      clipper: MyRectClipper(width: leftRatio * widget.size),
      child: widget.selectedImage,
    );
    selectedImages.add(leftStar);

    return selectedImages;
  }
}

class MyRectClipper extends CustomClipper<Rect> {
  final double width;

  MyRectClipper({this.width});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, width, size.height);
  }

  @override
  bool shouldReclip(MyRectClipper oldClipper) {
    return width != oldClipper.width;
  }
}