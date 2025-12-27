import 'dart:math';

import 'Size.dart';

class Point
{
  double X = 0.0;
  double Y = 0.0;

  static Point Zero = Point();

  Point([ double x = 0.0, double y = 0.0 ])
  {
    this.X = x;
    this.Y = y;
  }

  @override
  String toString()
  {
    return "{X=$X Y=$Y}";
  }

  @override
  bool operator ==(Object? other)
  {
    if (other is! Point)
      return false;

    return (X == other.X) && (Y == other.Y);
  }

  @override
  int get hashCode
  {
    return X.hashCode ^ (Y.hashCode * 397);
  }

  Point Offset(double dx, double dy)
  {
    final p = Point(X, Y);
    p.X += dx;
    p.Y += dy;
    return p;
  }

  Point Round()
  {
    return Point(X.roundToDouble(), Y.roundToDouble());
  }

  bool get IsEmpty
  {
    return (X == 0.0) && (Y == 0.0);
  }

  Size ToSize()
  {
    return Size(X, Y);
  }

  Point operator +(Size sz)
  {
    return Point(X + sz.Width, Y + sz.Height);
  }

  Point operator -(Size sz)
  {
    return Point(X - sz.Width, Y - sz.Height);
  }

  double Distance(Point other)
  {
    return sqrt(pow(X - other.X, 2.0) + pow(Y - other.Y, 2.0));
  }
}
