import 'package:flutter/material.dart';
import 'package:movies_flutter/Core/Base/Impl/Utils/FontConstants.dart';

import 'F_RectButton.dart';

class F_IconTextButton extends StatelessWidget
{
  final Color normalColor;
  final Color pressedColor;

  // callbacks
  final VoidCallback onTouchDown;
  final VoidCallback onTouchUp;

  // main properties
  final IconData icon;
  final String text;

  final double horizontalPadding;
  final double spacing;
  final double iconSize;
  final Color textColor;
  final bool isVertical;
  final CrossAxisAlignment crossAxisAlignment;
  final double corner;
  final double height;

  const F_IconTextButton({
    super.key,
    required this.normalColor,
    required this.pressedColor,
    required this.onTouchDown,
    required this.onTouchUp,
    required this.icon,
    required this.text,
    this.horizontalPadding = 20,
    this.spacing = 16,
    this.iconSize = 34,
    this.textColor = Colors.black,
    this.isVertical = false,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.corner = 0,
    this.height = 60,
  });

  @override
  Widget build(BuildContext context)
  {
    return F_RectButton(
      normalColor: normalColor,
      pressedColor: pressedColor,
      onTouchDown: onTouchDown,
      onTouchUp: onTouchUp,
      height: height,
      child: _buildLayout(),
    );
  }

  Widget _buildLayout()
  {
    if (isVertical)
    {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          _iconView(),
          SizedBox(height: spacing),
          _textView(),
        ],
      );
    }
    else
    {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _iconView(),
          SizedBox(width: spacing),
          _textView(),
        ],
      );
    }
  }

  Widget _iconView()
  {
    return Icon(
      icon,
      size: iconSize,
      color: textColor,
    );
  }

  Widget _textView()
  {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: FontConstants.RegularFont,
        fontSize: 22,
        fontWeight: FontWeight.w400,
      ).copyWith(color: textColor),
    );
  }
}
