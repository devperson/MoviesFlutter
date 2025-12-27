
import 'Point.dart';

class Size {
  double _width;
  double _height;

  /// Zero size (0,0)
  static final Size zero = Size(width: 0.0, height: 0.0);

  Size({double width = 0.0, double height = 0.0})
      : _width = _validate(width, 'width'),
        _height = _validate(height, 'height');

  /// Validate NaN (Swift fatalError equivalent)
  static double _validate(double value, String name) {
    if (value.isNaN) {
      throw ArgumentError('NaN is not a valid value for $name');
    }
    return value;
  }

  bool get isZero => _width == 0.0 && _height == 0.0;

  double get width => _width;
  set width(double value) {
    _width = _validate(value, 'width');
  }

  double get height => _height;
  set height(double value) {
    _height = _validate(value, 'height');
  }

  /// Add sizes
  Size operator +(Size other) {
    return Size(
      width: _width + other._width,
      height: _height + other._height,
    );
  }

  /// Subtract sizes
  Size operator -(Size other) {
    return Size(
      width: _width - other._width,
      height: _height - other._height,
    );
  }

  /// Multiply by scalar
  Size operator *(double value) {
    return Size(
      width: _width * value,
      height: _height * value,
    );
  }

  bool equals(Size other) =>
      _width == other._width && _height == other._height;

  /// Convert to Point (your custom Point class)
  Point toPoint() => Point(x: width, y: height);

  @override
  String toString() => '{Width=$_width Height=$_height}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Size &&
              runtimeType == other.runtimeType &&
              _width == other._width &&
              _height == other._height;

  @override
  int get hashCode => Object.hash(_width, _height);
}
