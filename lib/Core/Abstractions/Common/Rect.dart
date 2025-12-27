import 'dart:math';
import 'Size.dart';
import 'Point.dart';
import 'Rectangle.dart';

class Rect
{
    double X = 0.0;
    double Y = 0.0;
    double Width = 0.0;
    double Height = 0.0;

    Rect({this.X = 0.0, this.Y = 0.0, this.Width = 0.0, this.Height = 0.0});

    Rect.fromPointAndSize(Point loc, Size sz) : this(X: loc.X, Y: loc.Y, Width: sz.Width, Height: sz.Height);

    double get Top => Y;

    double get Bottom => Y + Height;

    double get Right => X + Width;

    double get Left => X;

    bool get IsEmpty => (Width <= 0) || (Height <= 0);

    Size get size => Size(Width, Height);
    set size(Size value) {
        Width = value.Width;
        Height = value.Height;
    }

    Point get Location => Point(X, Y);
    set Location(Point value) {
        X = value.X;
        Y = value.Y;
    }

    Point get Center => Point(X + Width / 2, Y + Height / 2);

    bool Equals(Rect other) => X == other.X && Y == other.Y && Width == other.Width && Height == other.Height;

    @override
    bool operator ==(Object other) {
        if (other is Rect) return Equals(other);
        if (other is Rectangle) return EqualsRectangle(other);
        return false;
    }

    bool EqualsRectangle(Rectangle other) => X == other.X && Y == other.Y && Width == other.Width && Height == other.Height;

    @override
    int get hashCode {
        var hashCode = X.hashCode;
        hashCode = (hashCode * 397) ^ Y.hashCode;
        hashCode = (hashCode * 397) ^ Width.hashCode;
        hashCode = (hashCode * 397) ^ Height.hashCode;
        return hashCode;
    }

    // Hit Testing / Intersection / Union
    bool Contains(Rect rect) => X <= rect.X && Right >= rect.Right && Y <= rect.Y && Bottom >= rect.Bottom;

    bool ContainsPoint(Point pt) => ContainsXY(pt.X, pt.Y);

    bool ContainsXY(double x, double y) => (x >= Left) && (x < Right) && (y >= Top) && (y < Bottom);

    bool IntersectsWith(Rect r) => !((Left >= r.Right) || (Right <= r.Left) || (Top >= r.Bottom) || (Bottom <= r.Top));

    Rect Union(Rect r) => UnionStatic(this, r);

    Rect Intersect(Rect r) => IntersectStatic(this, r);

    // Inflate and Offset
    Rect InflateWithSize(Size sz) => Inflate(sz.Width, sz.Height);

    Rect Inflate(double width, double height) {
        final r = this.copy();
        r.X -= width;
        r.Y -= height;
        r.Width += width * 2;
        r.Height += height * 2;
        return r;
    }

    Rect Offset(double dx, double dy) {
        final r = this.copy();
        r.X += dx;
        r.Y += dy;
        return r;
    }

    Rect OffsetPoint(Point dr) => Offset(dr.X, dr.Y);

    Rect Round() => Rect(X: X.roundToDouble(), Y: Y.roundToDouble(), Width: Width.roundToDouble(), Height: Height.roundToDouble());

    DeconstructedRect Deconstruct() {
        return DeconstructedRect(X, Y, Width, Height);
    }

    Rect copy() => Rect(X: X, Y: Y, Width: Width, Height: Height);

    @override
    String toString() => "{X=$X Y=$Y Width=$Width Height=$Height}";

    static Rect Zero = Rect();

    static Rect FromLTRB(double left, double top, double right, double bottom) => Rect(X: left, Y: top, Width: right - left, Height: bottom - top);

    static Rect UnionStatic(Rect r1, Rect r2) => FromLTRB(min(r1.Left, r2.Left), min(r1.Top, r2.Top), max(r1.Right, r2.Right), max(r1.Bottom, r2.Bottom));

    static Rect IntersectStatic(Rect r1, Rect r2) {
        final x = max(r1.X, r2.X);
        final y = max(r1.Y, r2.Y);
        final width = min(r1.Right, r2.Right) - x;
        final height = min(r1.Bottom, r2.Bottom) - y;

        if (width < 0 || height < 0)
            return Zero;

        return Rect(X: x, Y: y, Width: width, Height: height);
    }
}

class DeconstructedRect {
    final double x;
    final double y;
    final double width;
    final double height;
    DeconstructedRect(this.x, this.y, this.width, this.height);
}
