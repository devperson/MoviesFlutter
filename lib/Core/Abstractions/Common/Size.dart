import 'Point.dart';

class Size
{
  double _width = 0.0;
  double _height = 0.0;

  static final Size Zero = Size(0.0, 0.0);

  Size(double width, double height)
  {
    if (width.isNaN)
      throw ArgumentError("NaN is not a valid value for width");

    if (height.isNaN)
      throw ArgumentError("NaN is not a valid value for height");

    _width = width;
    _height = height;
  }

  bool get IsZero
  {
    return (_width == 0.0) && (_height == 0.0);
  }

  double get Width
  {
    return _width;
  }

  set Width(double value)
  {
    if (value.isNaN)
      throw ArgumentError("NaN is not a valid value for Width");

    _width = value;
  }

  double get Height
  {
    return _height;
  }

  set Height(double value)
  {
    if (value.isNaN)
      throw ArgumentError("NaN is not a valid value for Height");

    _height = value;
  }

  Size operator +(Size other)
  {
    return Size(_width + other._width, _height + other._height);
  }

  Size operator -(Size other)
  {
    return Size(_width - other._width, _height - other._height);
  }

  Size operator *(double value)
  {
    return Size(_width * value, _height * value);
  }

  bool Equals(Size other)
  {
    return _width == other._width && _height == other._height;
  }

  @override
  bool operator ==(Object? other)
  {
    if (other == null)
      return false;

    return other is Size && Equals(other);
  }

  @override
  int get hashCode
  {
    return (_width.hashCode * 397) ^ _height.hashCode;
  }

  @override
  String toString()
  {
    return "{Width=$_width Height=$_height}";
  }

  Point ToPoint()
  {
    return Point(Width, Height);
  }
}
