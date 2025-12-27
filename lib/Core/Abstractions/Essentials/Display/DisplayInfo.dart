import 'DisplayOrientation.dart';
import 'DisplayRotation.dart';

class DisplayInfo
{
    final double Width;
    final double Height;
    final double Density;
    final DisplayOrientation Orientation;
    final DisplayRotation Rotation;
    final double RefreshRate;

    DisplayInfo(
        this.Width,
        this.Height,
        this.Density,
        this.Orientation,
        this.Rotation,
        this.RefreshRate
    );
}
