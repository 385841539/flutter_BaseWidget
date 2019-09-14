import 'dart:math';


/// 饼状图 各种计算工具
class ChartUtils {


  ///弧度换算成角度
  static double radianToAngle(double radian) {
    return radian * 180 / (pi);
  }


  ///角度换算成弧度

  static double angleToRadian(double angle) {
    return angle * pi / 180;
  }

  ///提供精确的小数位四舍五入处理。
  ///v     需要四舍五入的数字,
  ///scale 小数点后保留几位
  ///return 四舍五入后的结果
  static double round(double v, int scale) {
    if (scale < 0) {
      throw "The scale must be a positive integer or zero";
    }

    return double.parse(v.toStringAsFixed(scale));
  }

  ///获取象限
  static int getQuadrant(double x, double y) {
    if (x >= 0) {
      return y >= 0 ? 4 : 1;
    }
    return y >= 0 ? 3 : 2;
  }

  ///两点之间的距离
  static double distanceForTwoPoint(double x1, double y1, double x2,
      double y2) {
    double distanceX = x1 - x2;
    double distanceY = y1 - y2;
    return sqrt(pow(distanceX, 2) + pow(distanceY, 2));
  }

  ///
  ///获取点相对中心点的角度
  ///
  ///@param centerX 基准点x
  ///@param centerY 基准的y
  ///@param x       当前点x
  ///@param y       当前点y
  ///@return

  static double getPointAngle(double centerX, double centerY, double x,
      double y) {
    double distance = distanceForTwoPoint(centerX, centerY, x, y);
//弧度
    double radian = 0;
    if (x > centerX && y < centerY) {
      radian = pi * 2 - asin((centerY - y) / distance);
    } else if (x < centerX && y < centerY) {
      radian = pi + asin((centerY - y) / distance);
    } else if (x < centerX && y > centerY) {
      radian = pi - asin((y - centerY) / distance);
    } else if (x > centerX && y > centerY) {
      radian = asin((y - centerY) / distance);
    }
//转角度
    return radianToAngle(radian);
  }

  ///
  ///根据手势滑动速度，计算角速度
  ///@param velocityX  up时x方向的线速度
  ///@param velocityY  up时y方向的线速度
  ///@param levelAngle 触点到中心点的线与水平线正方向的夹角
  ///@param quadrant   象限
  ///@param distance   触点到中心店的距离
  static double calculateAngleFromVelocity(double velocityX, double velocityY,
      double levelAngle, int quadrant, double distance) {
//转换成与水平线的夹角
    if (levelAngle > 270) {
      levelAngle = 360 - levelAngle;
    } else if (levelAngle > 90 && levelAngle < 180) {
      levelAngle = 180 - levelAngle;
    } else {
      levelAngle = levelAngle % 90;
    }
//获得线速度与水平夹角,即矢量速度与水平方向的夹角
    double lineSpeed = (sqrt(
        pow(velocityX, 2) + pow(velocityY, 2)));
        double

        vectorAngle = radianToAngle(
        asin(abs(velocityY) / lineSpeed));
//不需要惯性旋转
    if (vectorAngle == levelAngle) {
    return 0;
    }
//圆切速度与线速度的夹角
    double circleLineAngle;
    bool isCW; //是否顺时针
    if (quadrant == 4) {
    if (velocityX > 0 && velocityY < 0) {
    isCW = false;
    circleLineAngle =
    vectorAngle > levelAngle ? vectorAngle - levelAngle : 90 - vectorAngle -
    levelAngle;
    } else if (velocityX > 0 && velocityY > 0) {
    isCW = vectorAngle > levelAngle;
    circleLineAngle =
    vectorAngle > levelAngle ? 90 - vectorAngle + levelAngle
        : 90 + vectorAngle - levelAngle;
    } else if (velocityX < 0 && velocityY < 0) {
    isCW = vectorAngle < levelAngle;
    circleLineAngle =
    vectorAngle > levelAngle ? 90 - vectorAngle + levelAngle
        : 90 + vectorAngle - levelAngle;
    } else {
    isCW = true;
    circleLineAngle =
    vectorAngle > levelAngle ? vectorAngle + levelAngle - 90
        : 90 - vectorAngle - levelAngle;
    }
    } else if (quadrant == 3) {
    if (velocityX > 0 && velocityY < 0) {
    isCW = vectorAngle > levelAngle;
    circleLineAngle =
    vectorAngle > levelAngle ? 90 - vectorAngle + levelAngle
        : 90 + vectorAngle - levelAngle;
    } else if (velocityX > 0 && velocityY > 0) {
    isCW = false;
    circleLineAngle =
    vectorAngle > levelAngle ? vectorAngle - levelAngle : vectorAngle +
    levelAngle;
    } else if (velocityX < 0 && velocityY > 0) {
    isCW = vectorAngle < levelAngle;
    circleLineAngle =
    vectorAngle > levelAngle ? 90 - vectorAngle + levelAngle
        : 90 + vectorAngle - levelAngle;
    } else {
    isCW = true;
    circleLineAngle =
    vectorAngle > levelAngle ? vectorAngle + levelAngle - 90
        : 90 - vectorAngle - levelAngle;
    }
    } else if (quadrant == 2) {
    if (velocityX > 0 && velocityY < 0) {
    isCW = true;
    circleLineAngle =
    vectorAngle > levelAngle ? vectorAngle + levelAngle - 90
        : 90 - vectorAngle - levelAngle;
    } else if (velocityX > 0 && velocityY > 0) {
    isCW = vectorAngle < levelAngle;
    circleLineAngle =
    vectorAngle > levelAngle ? 90 - vectorAngle + levelAngle
        : 90 + vectorAngle - levelAngle;
    } else if (velocityX < 0 && velocityY > 0) {
    isCW = false;
    circleLineAngle =
    vectorAngle > levelAngle ? vectorAngle - levelAngle : 90 - vectorAngle -
    levelAngle;
    } else {
    isCW = vectorAngle > levelAngle;
    circleLineAngle =
    vectorAngle > levelAngle ? 90 - vectorAngle + levelAngle
        : 90 + vectorAngle - levelAngle;
    }
    } else {
    if (velocityX > 0 && velocityY < 0) {
    isCW = vectorAngle < levelAngle;
    circleLineAngle =
    vectorAngle > levelAngle ? 90 - vectorAngle + levelAngle
        : 90 + vectorAngle - levelAngle;
    } else if (velocityX > 0 && velocityY > 0) {
    isCW = true;
    circleLineAngle =
    vectorAngle > levelAngle ? vectorAngle + levelAngle - 90
        : 90 - vectorAngle - levelAngle;
    } else if (velocityX < 0 && velocityY > 0) {
    isCW = vectorAngle > levelAngle;
    circleLineAngle =
    vectorAngle > levelAngle ? 90 - vectorAngle + levelAngle
        : 90 + vectorAngle - levelAngle;
    } else {
    isCW = false;
    circleLineAngle =
    vectorAngle > levelAngle ? vectorAngle - levelAngle : vectorAngle +
    levelAngle;
    }
    }

//计算圆切速度,通过弧度计算，角度要先转换为弧度
    double circleSpeed = abs(lineSpeed * cos(circleLineAngle));
//角速度w与线速度v的关系:  wr = v
    return(circleSpeed / distance * (isCW ? 1 : -1));
    }

//  /**
//   * 获取初始进入动画动态总角度
//   *
//   * @param interpolator 插值器
//   * @param judgeValue   判断值
//   * @param targetValue  目标值
//   * @param duration     时长
//   * @return
//   */
//  static double
//
//  getAnimationTotalAngle
//      (Interpolator interpolator, double
//
//  judgeValue,
//
//      double
//
//      targetValue,
//      double
//
//      duration) {
//    double
//
//    percent = (System.currentTimeMillis() - judgeValue) * 1.0f / duration;
//    percent = percent > 1 ? 1 : percent;
//    return interpolator.getInterpolation(percent) * targetValue;
//  }

  static abs(double value) {
    if (value >= 0)
      return value;
    else {
      return -1 * value;
    }
  }
}
