import 'dart:math';

class XfColor
{
  final _Mode _mode;

  static XfColor get Default => XfColor._(-1.0, -1.0, -1.0, -1.0, _Mode.Default);

  static XfColor Accent = Default;

  static void SetAccent(XfColor value)
  {
    Accent = value;
  }

  double _a;
  double _r;
  double _g;
  double _b;
  double _hue;
  double _saturation;
  double _luminosity;

  bool get IsDefault => _mode == _Mode.Default;

  double get A => _a;
  double get R => _r;
  double get G => _g;
  double get B => _b;
  double get Hue => _hue;
  double get Saturation => _saturation;
  double get Luminosity => _luminosity;

  XfColor(double r, double g, double b, [ double a = 1.0 ])
      : this._(r, g, b, a, _Mode.Rgb);

  XfColor._(double w, double x, double y, double z, _Mode mode)
      : _mode = mode,
        _r = mode == _Mode.Rgb ? Clamp(w, 0.0, 1.0) : -1.0,
        _g = mode == _Mode.Rgb ? Clamp(x, 0.0, 1.0) : -1.0,
        _b = mode == _Mode.Rgb ? Clamp(y, 0.0, 1.0) : -1.0,
        _a = Clamp(z, 0.0, 1.0),
        _hue = mode == _Mode.Hsl ? Clamp(w, 0.0, 1.0) : -1.0,
        _saturation = mode == _Mode.Hsl ? Clamp(x, 0.0, 1.0) : -1.0,
        _luminosity = mode == _Mode.Hsl ? Clamp(y, 0.0, 1.0) : -1.0
  {
    if (mode == _Mode.Rgb)
    {
      final hsl = _ConvertToHsl(_r, _g, _b);
      _hue = hsl.h;
      _saturation = hsl.s;
      _luminosity = hsl.l;
    }
    else if (mode == _Mode.Hsl)
    {
      final rgb = _ConvertToRgb(_hue, _saturation, _luminosity);
      _r = rgb.r;
      _g = rgb.g;
      _b = rgb.b;
    }
  }

  XfColor MultiplyAlpha(double alpha)
  {
    if (_mode == _Mode.Default)
      throw StateError("Invalid on Color.Default");

    return _mode == _Mode.Rgb
        ? XfColor._(_r, _g, _b, _a * alpha, _Mode.Rgb)
        : XfColor._(_hue, _saturation, _luminosity, _a * alpha, _Mode.Hsl);
  }

  XfColor AddLuminosity(double delta)
  {
    if (_mode == _Mode.Default)
      throw StateError("Invalid on Color.Default");

    return XfColor._(_hue, _saturation, _luminosity + delta, _a, _Mode.Hsl);
  }

  XfColor WithHue(double hue)
  {
    if (_mode == _Mode.Default)
      throw StateError("Invalid on Color.Default");

    return XfColor._(hue, _saturation, _luminosity, _a, _Mode.Hsl);
  }

  XfColor WithSaturation(double saturation)
  {
    if (_mode == _Mode.Default)
      throw StateError("Invalid on Color.Default");

    return XfColor._(_hue, saturation, _luminosity, _a, _Mode.Hsl);
  }

  XfColor WithLuminosity(double luminosity)
  {
    if (_mode == _Mode.Default)
      throw StateError("Invalid on Color.Default");

    return XfColor._(_hue, _saturation, luminosity, _a, _Mode.Hsl);
  }

  @override
  bool operator ==(Object? other)
  {
    if (other is! XfColor)
      return false;

    if (_mode == _Mode.Default && other._mode == _Mode.Default)
      return true;

    if (_mode != other._mode)
      return false;

    return _mode == _Mode.Hsl
        ? _hue == other._hue && _saturation == other._saturation && _luminosity == other._luminosity && _a == other._a
        : _r == other._r && _g == other._g && _b == other._b && _a == other._a;
  }

  @override
  int get hashCode
  {
    int hash = _r.hashCode;
    hash = (hash * 397) ^ _g.hashCode;
    hash = (hash * 397) ^ _b.hashCode;
    hash = (hash * 397) ^ _a.hashCode;
    return hash;
  }

  @override
  String toString()
  {
    return "[Color: A=$A, R=$R, G=$G, B=$B, Hue=$Hue, Saturation=$Saturation, Luminosity=$Luminosity]";
  }

  String ToHex()
  {
    String toHexByte(double v)
    {
      final int i = (v * 255).round().clamp(0, 255);
      final h = i.toRadixString(16).toUpperCase();
      return h.length == 1 ? "0$h" : h;
    }

    return "#${toHexByte(A)}${toHexByte(R)}${toHexByte(G)}${toHexByte(B)}";
  }

  // ---------- Helpers ----------

  static XfColor FromHex(String hex)
  {
    if (hex.length < 3)
      return Default;

    int idx = hex.startsWith('#') ? 1 : 0;

    switch (hex.length - idx)
    {
      case 3:
        final r = _ToHexD(hex[idx++]);
        final g = _ToHexD(hex[idx++]);
        final b = _ToHexD(hex[idx]);
        return FromRgb(r, g, b);

      case 6:
        return FromRgb(
          (_ToHex(hex[idx++]) << 4) | _ToHex(hex[idx++]),
          (_ToHex(hex[idx++]) << 4) | _ToHex(hex[idx++]),
          (_ToHex(hex[idx++]) << 4) | _ToHex(hex[idx]),
        );

      default:
        return Default;
    }
  }

  static XfColor FromUint(int argb)
  {
    return FromRgba(
      (argb >> 16) & 0xFF,
      (argb >> 8) & 0xFF,
      argb & 0xFF,
      (argb >> 24) & 0xFF,
    );
  }

  static XfColor FromRgb(int r, int g, int b)
  {
    return FromRgba(r, g, b, 255);
  }

  static XfColor FromRgba(int r, int g, int b, int a)
  {
    return XfColor._(
        r / 255.0,
        g / 255.0,
        b / 255.0,
        a / 255.0,
        _Mode.Rgb
    );
  }

  static XfColor FromRgbD(double r, double g, double b)
  {
    return XfColor._(r, g, b, 1.0, _Mode.Rgb);
  }

  static XfColor FromRgbaD(double r, double g, double b, double a)
  {
    return XfColor._(r, g, b, a, _Mode.Rgb);
  }

  static XfColor FromHsla(double h, double s, double l, [ double a = 1.0 ])
  {
    return XfColor._(h, s, l, a, _Mode.Hsl);
  }

  static XfColor FromHsva(double h, double s, double v, double a)
  {
    final hClamped = Clamp(h, 0.0, 1.0);
    final sClamped = Clamp(s, 0.0, 1.0);
    final vClamped = Clamp(v, 0.0, 1.0);

    final range = (hClamped * 6).floor() % 6;
    final f = hClamped * 6 - (hClamped * 6).floor();

    final p = vClamped * (1 - sClamped);
    final q = vClamped * (1 - f * sClamped);
    final t = vClamped * (1 - (1 - f) * sClamped);

    switch (range)
    {
      case 0: return FromRgbaD(vClamped, t, p, a);
      case 1: return FromRgbaD(q, vClamped, p, a);
      case 2: return FromRgbaD(p, vClamped, t, a);
      case 3: return FromRgbaD(p, q, vClamped, a);
      case 4: return FromRgbaD(t, p, vClamped, a);
      default: return FromRgbaD(vClamped, p, q, a);
    }
  }

  static XfColor FromHsv(double h, double s, double v)
  {
    return FromHsva(h, s, v, 1.0);
  }

  static XfColor FromHsvaI(int h, int s, int v, int a)
  {
    return FromHsva(
        h / 360.0,
        s / 100.0,
        v / 100.0,
        a / 100.0
    );
  }

  static XfColor FromHsvI(int h, int s, int v)
  {
    return FromHsvaI(h, s, v, 100);
  }

  static int _ToHexD(String c)
  {
    final int j = _ToHex(c);
    return (j << 4) | j;
  }


  static int _ToHex(String c)
  {
    final int x = c.codeUnitAt(0);

    if (x >= '0'.codeUnitAt(0) && x <= '9'.codeUnitAt(0))
      return x - '0'.codeUnitAt(0);

    final int xOr = x | 0x20;
    if (xOr >= 'a'.codeUnitAt(0) && xOr <= 'f'.codeUnitAt(0))
      return xOr - 'a'.codeUnitAt(0) + 10;

    return 0;
  }



  static double Clamp(double self, double min, double max)
  {
    if (max < min) return max;
    if (self < min) return min;
    if (self > max) return max;
    return self;
  }

  static _RgbResult _ConvertToRgb(double h, double s, double l)
  {
    if (l == 0) return _RgbResult(0, 0, 0);
    if (s == 0) return _RgbResult(l, l, l);

    final temp2 = l <= 0.5 ? l * (1 + s) : l + s - l * s;
    final temp1 = 2 * l - temp2;

    double hueToRgb(double t)
    {
      if (t < 0) t += 1;
      if (t > 1) t -= 1;
      if (6 * t < 1) return temp1 + (temp2 - temp1) * 6 * t;
      if (2 * t < 1) return temp2;
      if (3 * t < 2) return temp1 + (temp2 - temp1) * (2 / 3 - t) * 6;
      return temp1;
    }

    return _RgbResult(
        hueToRgb(h + 1 / 3),
        hueToRgb(h),
        hueToRgb(h - 1 / 3)
    );
  }

  static _HslResult _ConvertToHsl(double r, double g, double b)
  {
    final v = max(r, max(g, b));
    final m = min(r, min(g, b));
    final l = (v + m) / 2;

    if (l <= 0) return _HslResult(0, 0, 0);

    final vm = v - m;
    double s = vm / (l <= 0.5 ? v + m : 2 - v - m);

    double h;
    if (r == v)
      h = (g == m ? 5 + (v - b) / vm : 1 - (v - g) / vm);
    else if (g == v)
      h = (b == m ? 1 + (v - r) / vm : 3 - (v - b) / vm);
    else
      h = (r == m ? 3 + (v - g) / vm : 5 - (v - r) / vm);

    return _HslResult(h / 6, s, l);
  }

  static final XfColor Black = XfColor(0, 0, 0);
  static final XfColor Red = XfColor(1, 0, 0);
  static final XfColor White = XfColor(1, 1, 1);
}

enum _Mode
{
  Default,
  Rgb,
  Hsl
}

class _RgbResult
{
  final double r;
  final double g;
  final double b;

  _RgbResult(this.r, this.g, this.b);
}

class _HslResult
{
  final double h;
  final double s;
  final double l;

  _HslResult(this.h, this.s, this.l);
}
