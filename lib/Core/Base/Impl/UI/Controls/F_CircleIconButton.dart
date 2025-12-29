
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_flutter/Core/Base/Impl/Utils/ColorConstants.dart';

class F_CircleIconButton extends StatelessWidget
{
  final VoidCallback onPressed;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final double iconPadding;
  final double iconSize;

  const F_CircleIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor = Colors.white,
    this.iconColor = ColorConstants.DefaultTextColor,
    this.iconPadding = 12,
    this.iconSize = 26
  });

  @override
  Widget build(BuildContext context)
  {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: EdgeInsets.all(iconPadding),
        backgroundColor: backgroundColor,
        foregroundColor: iconColor, // splash & icon
        elevation: 0,
      ),
      child: Icon(icon, size: iconSize, color: iconColor,),
    );
  }
}
