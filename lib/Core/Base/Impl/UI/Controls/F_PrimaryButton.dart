import 'package:flutter/material.dart';
import '../../Utils/ColorConstants.dart';
import '../../Utils/NumConstants.dart';
import 'F_RectButton.dart';

class F_PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const F_PrimaryButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double height = NumConstants.btnHeight;

    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: F_RectButton(
        normalColor: ColorConstants.PrimaryColor,
        pressedColor: ColorConstants.PrimaryDark,
        onTouchDown: () {},
        onTouchUp: onTap,
        height: height,
        child: SizedBox(
          width: double.infinity,
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Sen',
                fontWeight: FontWeight.w700, // Sen-Bold
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
