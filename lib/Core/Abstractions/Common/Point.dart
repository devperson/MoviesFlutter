import 'dart:math';

import 'Size.dart';

class Point
{
  double x = 0.0;
  double y = 0.0;

  static Point Zero = Point();

  Point([ double x = 0.0, double y = 0.0 ])
  {
    this.x = x;
    this.y = y;
  }

  @override
  String toString()
  {
    return "{X=$x Y=$y}";
  }

  @override
  bool operator ==(Object? other)
  {
    if (other is! Point)
      return false;

    return (x == other.x) && (y == other.y);
  }

  @override
  int get hashCode
  {
    return x.hashCode ^ (y.hashCode * 397);
  }

  Point Offset(double dx, double dy)
  {
    final p = Point(x, y);
    p.x += dx;
    p.y += dy;
    return p;
  }

  Point Round()
  {
    return Point(x.roundToDouble(), y.roundToDouble());
  }

  bool get IsEmpty
  {
    return (x == 0.0) && (y == 0.0);
  }

  Size ToSize()
  {
    return Size(x, y);
  }

  Point operator +(Size sz)
  {
    return Point(x + sz.Width, y + sz.Height);
  }

  Point operator -(Size sz)
  {
    return Point(x - sz.Width, y - sz.Height);
  }

  double Distance(Point other)
  {
    return sqrt(pow(x - other.x, 2.0) + pow(y - other.y, 2.0));
  }
}
