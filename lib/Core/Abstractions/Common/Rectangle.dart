import 'dart:math';
import 'Size.dart';
import 'Point.dart';
import 'Rect.dart';

class Rectangle
{
    double X = 0.0;
    double Y = 0.0;
    double Width = 0.0;
    double Height = 0.0;

    Rectangle({this.X = 0.0, this.Y = 0.0, this.Width = 0.0, this.Height = 0.0});

    static Rectangle Zero = Rectangle();

    static Rectangle FromLTRB(double left, double top, double right, double bottom) {
        return Rectangle(X: left, Y: top, Width: right - left, Height: bottom - top);
    }

    static Rectangle UnionStatic(Rectangle r1, Rectangle r2) {
        return FromLTRB(min(r1.Left, r2.Left), min(r1.Top, r2.Top), max(r1.Right, r2.Right), max(r1.Bottom, r2.Bottom));
    }

    static Rectangle IntersectStatic(Rectangle r1, Rectangle r2) {
        final x = max(r1.X, r2.X);
        final y = max(r1.Y, r2.Y);
        final width = min(r1.Right, r2.Right) - x;
        final height = min(r1.Bottom, r2.Bottom) - y;

        if (width < 0 || height < 0) {
            return Zero;
        }
        return Rectangle(X: x, Y: y, Width: width, Height: height);
    }

    Rectangle.fromPointAndSize(Point loc, Size sz) : this(X: loc.X, Y: loc.Y, Width: sz.Width, Height: sz.Height);

    @override
    String toString() {
        return "{X=$X Y=$Y Width=$Width Height=$Height}";
    }

    bool Equals(Rectangle other) {
        return X == other.X && Y == other.Y && Width == other.Width && Height == other.Height;
    }

    @override
    bool operator ==(Object other) {
        if (other is Rectangle) return Equals(other);
        if (other is Rect) return X == other.X && Y == other.Y && Width == other.Width && Height == other.Height;
        return false;
    }

    @override
    int get hashCode {
        var hashCode = X.hashCode;
        hashCode = (hashCode * 397) ^ Y.hashCode;
        hashCode = (hashCode * 397) ^ Width.hashCode;
        hashCode = (hashCode * 397) ^ Height.hashCode;
        return hashCode;
    }

    // Hit Testing / Intersection / Union
    bool Contains(Rectangle rect) {
        return X <= rect.X && Right >= rect.Right && Y <= rect.Y && Bottom >= rect.Bottom;
    }

    bool ContainsPoint(Point pt) {
        return ContainsXY(pt.X, pt.Y);
    }

    bool ContainsXY(double x, double y) {
        return (x >= Left) && (x < Right) && (y >= Top) && (y < Bottom);
    }

    bool IntersectsWith(Rectangle r) {
        return !((Left >= r.Right) || (Right <= r.Left) || (Top >= r.Bottom) || (Bottom <= r.Top));
    }

    Rectangle Union(Rectangle r) {
        return UnionStatic(this, r);
    }

    Rectangle Intersect(Rectangle r) {
        return IntersectStatic(this, r);
    }

    // Position/Size
    double get Top => Y;
    set Top(double value) { Y = value; }

    double get Bottom => Y + Height;
    set Bottom(double value) { Height = value - Y; }

    double get Right => X + Width;
    set Right(double value) { Width = value - X; }

    double get Left => X;
    set Left(double value) { X = value; }

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

    // Inflate and Offset
    Rectangle InflateWithSize(Size sz) {
        return Inflate(sz.Width, sz.Height);
    }

    Rectangle Inflate(double width, double height) {
        final r = this.copy();
        r.X -= width;
        r.Y -= height;
        r.Width += width * 2;
        r.Height += height * 2;
        return r;
    }

    Rectangle Offset(double dx, double dy) {
        final r = this.copy();
        r.X += dx;
        r.Y += dy;
        return r;
    }

    Rectangle OffsetPoint(Point dr) {
        return Offset(dr.X, dr.Y);
    }

    Rectangle Round() {
        return Rectangle(X: X.roundToDouble(), Y: Y.roundToDouble(), Width: Width.roundToDouble(), Height: Height.roundToDouble());
    }

    Rectangle copy() => Rectangle(X: X, Y: Y, Width: Width, Height: Height);

    Rect toRect() => Rect(X: X, Y: Y, Width: Width, Height: Height);
}

extension RectExtensions on Rect {
    Rectangle toRectangle() => Rectangle(X: X, Y: Y, Width: Width, Height: Height);
}
