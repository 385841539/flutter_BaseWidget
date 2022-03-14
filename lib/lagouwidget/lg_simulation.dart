import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_common_plugin/base_lib.dart';

class LgScrollSimulation extends Simulation {
  /// Creates a scroll physics simulation that matches Android scrolling.
  LgScrollSimulation({
    @required this.velocity,
    @required this.position,
    @required this.distance,
    this.friction = 0.015,
  }) : super(tolerance: Tolerance.defaultTolerance);

  final double velocity;

  final double friction; //摩擦力，理解为单位时间内 速度降低的数值

  double _distance;
  double distance;
  double position;

  @override
  double x(double time) {
    return position +
        (2 * velocity + getFirDirection(velocity) * friction * time) * time / 2;
  }

  @override
  double dx(double time) {
    return (2 * velocity + getFirDirection(velocity) * friction * time) *
        time /
        2;
  }

  @override
  bool isDone(double time) {
    _distance =
        (2 * velocity + getFirDirection(velocity) * friction * time) * time / 2;
    logger
        .e("------distance:$_distance--:distance:$distance" + "----time:$time");

    return _distance >= distance;
  }

  getFirDirection(double velocity) {
    if (velocity > 0) {
      return -1;
    }
    return 1;
  }
}
