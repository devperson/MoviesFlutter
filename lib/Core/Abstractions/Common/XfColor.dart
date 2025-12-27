import 'dart:math';

enum Mode { Default, Rgb, Hsl }

class XfColor {
  final Mode _mode;

  final double _a;
  final double _r;
  final double _g;
  final double _b;

  final double _hue;
  final double _saturation;
  final double _luminosity;

  // ------------------------
  // Getters
  // ------------------------

  bool get isDefault => _mode == Mode.Default;

  double get A => _a;
  double get R => _r;
  double get G => _g;
  double get B => _b;

  double get Hue => _hue;
  double get Saturation => _saturation;
  double get Luminosity => _luminosity;

  // ------------------------
  // Private ctor
  // ------------------------

  const XfColor._internal(
      this._r,
      this._g,
      this._b,
      this._a,
      this._hue,
      this._saturation,
      this._luminosity,
      this._mode,
      );

  factory XfColor._(
      double w,
      double x,
      double y,
      double z,
      Mode mode,
      ) {
    switch (mode) {
      case Mode.Default:
        return const XfColor._internal(
          -1, -1, -1, -1,
          -1, -1, -1,
          Mode.Default,
        );

      case Mode.Rgb:
        final r = _clamp(w);
        final g = _clamp(x);
        final b = _clamp(y);
        final a = _clamp(z);

        final hsl = _convertToHsl(r, g, b);
        return XfColor._internal(
          r, g, b, a,
          hsl.h, hsl.s, hsl.l,
          Mode.Rgb,
        );

      case Mode.Hsl:
        final h = _clamp(w);
        final s = _clamp(x);
        final l = _clamp(y);
        final a = _clamp(z);

        final rgb = _convertToRgb(h, s, l);
        return XfColor._internal(
          rgb.r, rgb.g, rgb.b, a,
          h, s, l,
          Mode.Hsl,
        );
    }
  }

  // ------------------------
  // Public constructors
  // ------------------------

  factory XfColor(double r, double g, double b, [double a = 1.0]) =>
      XfColor._(r, g, b, a, Mode.Rgb);

  factory XfColor.value(double v) =>
      XfColor._(v, v, v, 1.0, Mode.Rgb);

  // ------------------------
  // Instance methods
  // ------------------------

  XfColor multiplyAlpha(double alpha) {
    if (_mode == Mode.Default) {
      throw StateError('Invalid on Color.Default');
    }
    return XfColor._(
      _mode == Mode.Rgb ? _r : _hue,
      _mode == Mode.Rgb ? _g : _saturation,
      _mode == Mode.Rgb ? _b : _luminosity,
      _a * alpha,
      _mode,
    );
  }

  XfColor addLuminosity(double delta) {
    if (_mode == Mode.Default) {
      throw StateError('Invalid on Color.Default');
    }
    return XfColor._(_hue, _saturation, _luminosity + delta, _a, Mode.Hsl);
  }

  XfColor withHue(double hue) =>
      XfColor._(hue, _saturation, _luminosity, _a, Mode.Hsl);

  XfColor withSaturation(double s) =>
      XfColor._(_hue, s, _luminosity, _a, Mode.Hsl);

  XfColor withLuminosity(double l) =>
      XfColor._(_hue, _saturation, l, _a, Mode.Hsl);

  // ------------------------
  // Equality / Hash
  // ------------------------

  @override
  bool operator ==(Object other) {
    if (other is! XfColor) return false;

    if (_mode == Mode.Default && other._mode == Mode.Default) return true;
    if (_mode != other._mode) return false;

    if (_mode == Mode.Hsl) {
      return _hue == other._hue &&
          _saturation == other._saturation &&
          _luminosity == other._luminosity &&
          _a == other._a;
    }

    return _r == other._r &&
        _g == other._g &&
        _b == other._b &&
        _a == other._a;
  }

  @override
  int get hashCode {
    var h = _r.hashCode;
    h = (h * 397) ^ _g.hashCode;
    h = (h * 397) ^ _b.hashCode;
    h = (h * 397) ^ _a.hashCode;
    return h;
  }

  // ------------------------
  // String / Hex
  // ------------------------

  @override
  String toString() =>
      '[Color: A=$A, R=$R, G=$G, B=$B, '
          'Hue=$Hue, Saturation=$Saturation, Luminosity=$Luminosity]';

  String toHex() {
    String b(double v) =>
        _clampInt((v * 255).round(), 0, 255)
            .toRadixString(16)
            .padLeft(2, '0')
            .toUpperCase();

    return '#${b(A)}${b(R)}${b(G)}${b(B)}';
  }

  // ------------------------
  // Static / Factory methods
  // ------------------------

  static final XfColor Default = XfColor._(0, 0, 0, 0, Mode.Default);
  static XfColor Accent = Default;

  static void setAccent(XfColor value) {
    Accent = value;
  }

  static XfColor fromRgb(int r, int g, int b) =>
      fromRgba(r, g, b, 255);

  static XfColor fromRgba(int r, int g, int b, int a) =>
      XfColor._(r / 255, g / 255, b / 255, a / 255, Mode.Rgb);

  static XfColor fromRgbD(double r, double g, double b) =>
      XfColor._(r, g, b, 1.0, Mode.Rgb);

  static XfColor fromRgbaD(double r, double g, double b, double a) =>
      XfColor._(r, g, b, a, Mode.Rgb);

  static XfColor fromHsla(double h, double s, double l, [double a = 1.0]) =>
      XfColor._(h, s, l, a, Mode.Hsl);

  static XfColor fromHsv(double h, double s, double v) =>
      fromHsva(h, s, v, 1.0);

  static XfColor fromHsva(double h, double s, double v, double a) {
    final hh = _clamp(h);
    final ss = _clamp(s);
    final vv = _clamp(v);

    final range = (hh * 6).floor() % 6;
    final f = hh * 6 - (hh * 6).floor();

    final p = vv * (1 - ss);
    final q = vv * (1 - f * ss);
    final t = vv * (1 - (1 - f) * ss);

    switch (range) {
      case 0:
        return fromRgbaD(vv, t, p, a);
      case 1:
        return fromRgbaD(q, vv, p, a);
      case 2:
        return fromRgbaD(p, vv, t, a);
      case 3:
        return fromRgbaD(p, q, vv, a);
      case 4:
        return fromRgbaD(t, p, vv, a);
      default:
        return fromRgbaD(vv, p, q, a);
    }
  }

  // ------------------------
  // FromHex (FULL)
  // ------------------------

  static XfColor fromHex(String hex) {
    if (hex.length < 3) return Default;

    int idx = hex.startsWith('#') ? 1 : 0;
    final chars = hex.split('');
    final len = chars.length - idx;

    switch (len) {
      case 3:
        return fromRgb(
          _hexD(chars[idx++]),
          _hexD(chars[idx++]),
          _hexD(chars[idx]),
        );

      case 4:
        final a = _hexD(chars[idx++]);
        final r = _hexD(chars[idx++]);
        final g = _hexD(chars[idx++]);
        final b = _hexD(chars[idx]);
        return fromRgba(r, g, b, a);

      case 6:
        final r = (_hex(chars[idx]) << 4) | _hex(chars[idx + 1]);
        idx += 2;
        final g = (_hex(chars[idx]) << 4) | _hex(chars[idx + 1]);
        idx += 2;
        final b = (_hex(chars[idx]) << 4) | _hex(chars[idx + 1]);
        return fromRgb(r, g, b);

      case 8:
        final a = (_hex(chars[idx]) << 4) | _hex(chars[idx + 1]);
        idx += 2;
        final r = (_hex(chars[idx]) << 4) | _hex(chars[idx + 1]);
        idx += 2;
        final g = (_hex(chars[idx]) << 4) | _hex(chars[idx + 1]);
        idx += 2;
        final b = (_hex(chars[idx]) << 4) | _hex(chars[idx + 1]);
        return fromRgba(r, g, b, a);

      default:
        return Default;
    }
  }

  // ------------------------
  // Helpers
  // ------------------------

  static double _clamp(double v) => v.clamp(0.0, 1.0);

  static int _clampInt(int v, int min, int max) =>
      v < min ? min : (v > max ? max : v);

  static int _hex(String c) {
    final code = c.codeUnitAt(0);
    if (code >= 48 && code <= 57) return code - 48;
    final lower = code | 0x20;
    if (lower >= 97 && lower <= 102) return lower - 97 + 10;
    return 0;
  }

  static int _hexD(String c) {
    final v = _hex(c);
    return (v << 4) | v;
  }

  // ------------------------
  // HSL / RGB conversion
  // ------------------------

  static _Rgb _convertToRgb(double h, double s, double l) {
    if (l == 0) return const _Rgb(0, 0, 0);
    if (s == 0) return _Rgb(l, l, l);

    final t2 = l <= 0.5 ? l * (1 + s) : l + s - l * s;
    final t1 = 2 * l - t2;

    double c(double t) {
      if (t < 0) t += 1;
      if (t > 1) t -= 1;
      if (6 * t < 1) return t1 + (t2 - t1) * 6 * t;
      if (2 * t < 1) return t2;
      if (3 * t < 2) return t1 + (t2 - t1) * (2 / 3 - t) * 6;
      return t1;
    }

    return _Rgb(c(h + 1 / 3), c(h), c(h - 1 / 3));
  }

  static _Hsl _convertToHsl(double r, double g, double b) {
    final v = max(r, max(g, b));
    final m = min(r, min(g, b));
    final l = (m + v) / 2;

    if (l == 0) return const _Hsl(0, 0, 0);

    final vm = v - m;
    if (vm == 0) return _Hsl(0, 0, l);

    final s = l <= 0.5 ? vm / (v + m) : vm / (2 - v - m);

    double h;
    if (r == v) {
      h = g == m ? 5 + (v - b) / vm : 1 - (v - g) / vm;
    } else if (g == v) {
      h = b == m ? 1 + (v - r) / vm : 3 - (v - b) / vm;
    } else {
      h = r == m ? 3 + (v - g) / vm : 5 - (v - r) / vm;
    }

    return _Hsl(h / 6, s, l);
  }

  // ------------------------
  // Predefined
  // ------------------------

  static final Black = fromRgb(0, 0, 0);
  static final Red = fromRgb(255, 0, 0);
  static final White = fromRgb(255, 255, 255);
}

// ------------------------
// Internal structs
// ------------------------

class _Rgb {
  final double r, g, b;
  const _Rgb(this.r, this.g, this.b);
}

class _Hsl {
  final double h, s, l;
  const _Hsl(this.h, this.s, this.l);
}
