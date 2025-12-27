import 'dart:math';
import 'Point.dart';
import 'Rect.dart';
import 'Size.dart';

class Rectangle {
  double x;
  double y;
  double width;
  double height;

  /// Zero rectangle
  static final Rectangle zero = Rectangle();

  Rectangle({
    this.x = 0.0,
    this.y = 0.0,
    this.width = 0.0,
    this.height = 0.0,
  });

  /// From location + size
  Rectangle.fromPointSize(Point loc, Size sz)
      : x = loc.x,
        y = loc.y,
        width = sz.width,
        height = sz.height;

  /// From left/top/right/bottom
  static Rectangle fromLTRB(
      double left,
      double top,
      double right,
      double bottom,
      ) {
    return Rectangle(
      x: left,
      y: top,
      width: right - left,
      height: bottom - top,
    );
  }

  /// Union
  static Rectangle union(Rectangle r1, Rectangle r2) {
    return fromLTRB(
      min(r1.left, r2.left),
      min(r1.top, r2.top),
      max(r1.right, r2.right),
      max(r1.bottom, r2.bottom),
    );
  }

  /// Intersect
  static Rectangle intersect(Rectangle r1, Rectangle r2) {
    final nx = max(r1.x, r2.x);
    final ny = max(r1.y, r2.y);
    final nWidth = min(r1.right, r2.right) - nx;
    final nHeight = min(r1.bottom, r2.bottom) - ny;

    if (nWidth < 0 || nHeight < 0) {
      return Rectangle.zero;
    }

    return Rectangle(
      x: nx,
      y: ny,
      width: nWidth,
      height: nHeight,
    );
  }

  // ------------------------
  // Equality
  // ------------------------

  bool equals(Rectangle other) =>
      x == other.x &&
          y == other.y &&
          width == other.width &&
          height == other.height;

  /// Kotlin-style equals(other: Any?)
  bool equalsAny(Object? other) {
    if (other is Rectangle) {
      return equals(other);
    }
    if (other is Rect) {
      return x == other.x &&
          y == other.y &&
          width == other.width &&
          height == other.height;
    }
    return false;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Rectangle &&
              x == other.x &&
              y == other.y &&
              width == other.width &&
              height == other.height;

  /// Kotlin-like hashCode()
  int hashCodeValue() {
    var result = x.hashCode;
    result = (result * 397) ^ y.hashCode;
    result = (result * 397) ^ width.hashCode;
    result = (result * 397) ^ height.hashCode;
    return result;
  }

  @override
  int get hashCode => Object.hash(x, y, width, height);

  // ------------------------
  // Geometry
  // ------------------------

  bool containsRect(Rectangle rect) {
    return x <= rect.x &&
        right >= rect.right &&
        y <= rect.y &&
        bottom >= rect.bottom;
  }

  bool containsPoint(Point pt) => contains(pt.x, pt.y);

  bool contains(double px, double py) {
    return (px >= left) &&
        (px < right) &&
        (py >= top) &&
        (py < bottom);
  }

  bool intersectsWith(Rectangle r) {
    return !((left >= r.right) ||
        (right <= r.left) ||
        (top >= r.bottom) ||
        (bottom <= r.top));
  }

  Rectangle unionWith(Rectangle r) => Rectangle.union(this, r);

  Rectangle intersectWith(Rectangle r) =>
      Rectangle.intersect(this, r);

  // ------------------------
  // Computed properties
  // ------------------------

  double get top => y;
  set top(double value) => y = value;

  double get bottom => y + height;
  set bottom(double value) => height = value - y;

  double get right => x + width;
  set right(double value) => width = value - x;

  double get left => x;
  set left(double value) => x = value;

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

  Point get center =>
      Point(x: x + width / 2, y: y + height / 2);

  // ------------------------
  // Inflate / Offset
  // ------------------------

  Rectangle inflate(Size sz) =>
      inflateBy(sz.width, sz.height);

  Rectangle inflateBy(double w, double h) {
    return Rectangle(
      x: x - w,
      y: y - h,
      width: width + w * 2,
      height: height + h * 2,
    );
  }

  Rectangle offset(double dx, double dy) {
    return Rectangle(
      x: x + dx,
      y: y + dy,
      width: width,
      height: height,
    );
  }

  Rectangle offsetBy(Point dr) =>
      offset(dr.x, dr.y);

  Rectangle round() {
    return Rectangle(
      x: x.roundToDouble(),
      y: y.roundToDouble(),
      width: width.roundToDouble(),
      height: height.roundToDouble(),
    );
  }

  /// Convert to Rect
  Rect toRect() {
    return Rect(
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

// ------------------------------------------------------------------
// Extension on Rect → Rectangle
// ------------------------------------------------------------------

extension RectToRectangle on Rect {
  Rectangle toRectangle() {
    return Rectangle(
      x: x,
      y: y,
      width: width,
      height: height,
    );
  }
}
