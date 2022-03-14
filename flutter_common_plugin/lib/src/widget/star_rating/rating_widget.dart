import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StarRatingWidget extends StatefulWidget {
  /// star number
  final int count;

  /// Max score
  final double maxRating;

  /// Current score value
  final double value;

  /// Star size
  final double size;

  /// Space between the stars
  final double padding;

  /// empty star image assets url
  final String nomalImage;

  /// full star image assets url
  final String selectImage;

  /// Whether the score can be modified by sliding
  final bool selectAble;

  /// Callbacks when ratings change
  final ValueChanged<String> onRatingUpdate;

  StarRatingWidget(
      {this.maxRating = 10.0,
      this.count = 5,
      this.value = 10.0,
      this.size = 20,
      this.selectImage =
          "packages/flutter_common_plugin/images/icon_star_select.png",
      this.nomalImage =
          "packages/flutter_common_plugin/images/icon_star_unselect.png",
      this.padding,
      this.selectAble = false,
      this.onRatingUpdate})
      : assert(nomalImage != null),
        assert(selectImage != null);

  @override
  _StarRatingWidgetState createState() => _StarRatingWidgetState();
}

class _StarRatingWidgetState extends State<StarRatingWidget> {
  double value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (widget.padding + widget.size) * widget.count,
      height: widget.size,
      child: Listener(
        child: buildRowRating(),
        onPointerDown: (PointerDownEvent event) {
          double x = event.localPosition.dx;
          if (x < 0) x = 0;
          pointValue(x);
        },
        onPointerMove: (PointerMoveEvent event) {
          double x = event.localPosition.dx;
          if (x < 0) x = 0;
          pointValue(x);
        },
        onPointerUp: (_) {},
        behavior: HitTestBehavior.deferToChild,
      ),
    );
  }

  pointValue(double dx) {
    if (!widget.selectAble) {
      return;
    }
    if (dx <= 0) {
      // value = 0;
      value = (widget.maxRating / widget.count);
    } else if (dx >=
        widget.size * widget.count + widget.padding * (widget.count - 1)) {
      value = widget.maxRating;
    } else {
      for (double i = 1; i < widget.count + 1; i++) {
        if (dx > widget.size * i + widget.padding * (i - 1) &&
            dx < widget.size * i + widget.padding * i) {
          value = i * (widget.maxRating / widget.count);
          break;
        } else if (dx > widget.size * (i - 1) + widget.padding * (i - 1) &&
            dx < widget.size * i + widget.padding * i) {
          // value = (dx - widget.padding * (i - 1)) /
          //     (widget.size * widget.count) *
          //     widget.maxRating;
          value = (i) * (widget.maxRating / widget.count)
              // +(widget.maxRating/widget.count/2)
              ;
          break;
        }
      }
    }
    setState(() {
      if (widget.onRatingUpdate != null) {
        widget.onRatingUpdate(value.toStringAsFixed(1));
      }
    });
  }

  int fullStars() {
    if (value != null) {
      return (value / (widget.maxRating / widget.count)).floor();
    }
    return 0;
  }

  double star() {
    if (value != null) {
      if (widget.count / fullStars() == widget.maxRating / value) {
        return 0;
      }
      return (value % (widget.maxRating / widget.count)) /
          (widget.maxRating / widget.count);
    }
    return 0;
  }

  List<Widget> buildRow() {
    int full = fullStars();
    List<Widget> children = [];
    for (int i = 0; i < full; i++) {
      children.add(Image.asset(
        widget.selectImage,
        height: widget.size,
        width: widget.size,
      ));
      if (i < widget.count - 1) {
        children.add(
          SizedBox(
            width: widget.padding,
          ),
        );
      }
    }
    if (full < widget.count) {
      children.add(ClipRect(
        clipper: SMClipper(rating: star() * widget.size),
        child: Image.asset(widget.selectImage,
            height: widget.size, width: widget.size),
      ));
    }

    return children;
  }

  List<Widget> buildNomalRow() {
    List<Widget> children = [];
    for (int i = 0; i < widget.count; i++) {
      children.add(Image.asset(
        widget.nomalImage,
        height: widget.size,
        width: widget.size,
      ));
      if (i < widget.count - 1) {
        children.add(SizedBox(
          width: widget.padding,
        ));
      }
    }
    return children;
  }

  Widget buildRowRating() {
    return Container(
      // color: Colors.red,
      alignment: AlignmentDirectional.centerStart,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: buildNomalRow(),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: buildRow(),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    value = widget.value;
  }
}

class SMClipper extends CustomClipper<Rect> {
  final double rating;

  SMClipper({this.rating}) : assert(rating != null);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0.0, 0.0, rating, size.height);
  }

  @override
  bool shouldReclip(SMClipper oldClipper) {
    return rating != oldClipper.rating;
  }
}
