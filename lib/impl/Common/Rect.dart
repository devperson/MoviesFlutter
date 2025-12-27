

import 'dart:math';

import 'Point.dart';
import 'Size.dart';

class Rect {
  double x;
  double y;
  double width;
  double height;

  Rect({
    this.x = 0.0,
    this.y = 0.0,
    this.width = 0.0,
    this.height = 0.0,
  });

  Rect.fromPointSize(Point loc, Size sz)
      : x = loc.x,
        y = loc.y,
        width = sz.width,
        height = sz.height;

  // Edges
  double get top => y;
  double get bottom => y + height;
  double get left => x;
  double get right => x + width;

  bool get isEmpty => width <= 0 || height <= 0;

  Size get size => Size(width: width, height: height);
  set size(Size value) {
    width = value.width;
    height = value.height;
  }

  Point get location => Point(x: x, y: y);
  set location(Point value) {
    x = value.x;
    y = value.y;
  }

  Point get center => Point(
    x: x + width / 2,
    y: y + height / 2,
  );

  // Equality
  bool equals(Rect other) =>
      x == other.x &&
          y == other.y &&
          width == other.width &&
          height == other.height;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Rect &&
              x == other.x &&
              y == other.y &&
              width == other.width &&
              height == other.height;

  @override
  int get hashCode => Object.hash(x, y, width, height);

  // Containment
  bool containsRect(Rect rect) {
    return x <= rect.x &&
        right >= rect.right &&
        y <= rect.y &&
        bottom >= rect.bottom;
  }

  bool containsPoint(Point pt) => contains(pt.x, pt.y);

  bool contains(double px, double py) {
    return px >= left &&
        px < right &&
        py >= top &&
        py < bottom;
  }

  // Intersection
  bool intersectsWith(Rect r) {
    return !((left >= r.right) ||
        (right <= r.left) ||
        (top >= r.bottom) ||
        (bottom <= r.top));
  }

  static Rect fromLTRB(
      double left,
      double top,
      double right,
      double bottom,
      ) {
    return Rect(
      x: left,
      y: top,
      width: right - left,
      height: bottom - top,
    );
  }

  static Rect union(Rect r1, Rect r2) {
    return fromLTRB(
      min(r1.left, r2.left),
      min(r1.top, r2.top),
      max(r1.right, r2.right),
      max(r1.bottom, r2.bottom),
    );
  }

  static Rect intersect(Rect r1, Rect r2) {
    final nx = max(r1.x, r2.x);
    final ny = max(r1.y, r2.y);
    final nWidth = min(r1.right, r2.right) - nx;
    final nHeight = min(r1.bottom, r2.bottom) - ny;

    if (nWidth < 0 || nHeight < 0) {
      return Rect();
    }

    return Rect(
      x: nx,
      y: ny,
      width: nWidth,
      height: nHeight,
    );
  }

  // Inflate / Offset
  Rect inflate(Size sz) => inflateBy(sz.width, sz.height);

  Rect inflateBy(double w, double h) {
    return Rect(
      x: x - w,
      y: y - h,
      width: width + w * 2,
      height: height + h * 2,
    );
  }

  Rect offset(double dx, double dy) {
    return Rect(
      x: x + dx,
      y: y + dy,
      width: width,
      height: height,
    );
  }

  Rect offsetBy(Point dr) => offset(dr.x, dr.y);

  Rect round() {
    return Rect(
      x: x.roundToDouble(),
      y: y.roundToDouble(),
      width: width.roundToDouble(),
      height: height.roundToDouble(),
    );
  }

  DeconstructedRect deconstruct() {
    return DeconstructedRect(
      x: x,
      y: y,
      width: width,
      height: height,
    );
  }

  @override
  String toString() =>
      '{X=$x Y=$y Width=$width Height=$height}';
}

class DeconstructedRect {
  final double x;
  final double y;
  final double width;
  final double height;

  const DeconstructedRect({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });
}
