import 'dart:math';

import 'Size.dart';

class Point {
  final double x;
  final double y;

  /// Zero point (0,0)
  static const Point zero = Point();

  const Point({this.x = 0.0, this.y = 0.0});

  /// Offset point by dx, dy
  Point offset(double dx, double dy) {
    return Point(
      x: x + dx,
      y: y + dy,
    );
  }

  /// Rounded point
  Point round() {
    return Point(
      x: x.roundToDouble(),
      y: y.roundToDouble(),
    );
  }

  /// Is empty (0,0)
  bool get isEmpty => x == 0.0 && y == 0.0;

  /// Convert to Flutter Size
  Size toSize() => Size(width: x, height: y);

  /// Distance to another point
  double distance(Point other) {
    return sqrt(pow(x - other.x, 2) + pow(y - other.y, 2));
  }

  /// Add Size to Point
  Point operator +(Size size) {
    return Point(
      x: x + size.width,
      y: y + size.height,
    );
  }

  /// Subtract Size from Point
  Point operator -(Size size) {
    return Point(
      x: x - size.width,
      y: y - size.height,
    );
  }

  @override
  String toString() => '{X=$x Y=$y}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Point &&
              runtimeType == other.runtimeType &&
              x == other.x &&
              y == other.y;

  @override
  int get hashCode => Object.hash(x, y);
}