import 'package:flutter/material.dart';

class F_RectButton extends StatefulWidget {
  final Color normalColor;
  final Color pressedColor;
  final VoidCallback onTouchDown;
  final VoidCallback onTouchUp;
  final Widget child;
  final double height;
  final double horizontalPadding;

  const F_RectButton({
    super.key,
    required this.normalColor,
    required this.pressedColor,
    required this.onTouchDown,
    required this.onTouchUp,
    required this.child,
    this.height = 50,
    this.horizontalPadding = 16,
  });

  @override
  State<F_RectButton> createState() => _F_RectButtonState();
}

class _F_RectButtonState extends State<F_RectButton> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value) return;

    setState(() {
      _isPressed = value;
    });

    if (value) {
      widget.onTouchDown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) {
        _setPressed(false);
        widget.onTouchUp();
      },
      onTapCancel: () => _setPressed(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeInOut,
        width: double.infinity,
        height: widget.height,
        color: _isPressed
            ? widget.pressedColor
            : widget.normalColor,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: widget.horizontalPadding,
          ),
          child: Center(
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
