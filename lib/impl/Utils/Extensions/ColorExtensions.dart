import 'dart:ui';
import '../../Common/XfColor.dart';

extension XfColorToFlutterColor on XfColor
{
  Color toFlutterColor()
  {
    return Color.fromARGB(
      (A * 255).round(),
      (R * 255).round(),
      (G * 255).round(),
      (B * 255).round(),
    );
  }
}